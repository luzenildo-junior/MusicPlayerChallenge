//
//  PlayerManager.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 24/09/23.
//

import AVFoundation
import Combine
import Foundation

final class PlayerManager {
    static var shared = PlayerManager()
    @Published var playerState: PlayerState = .none
    
    // Music and playlist
    private var player : AVPlayer?
    private var currentPlayingSongIndex: Int = 0
    private var currentPlaylist = [ItunesSearchObject]()
    var currentPlayingSong: ItunesSearchObject {
        return currentPlaylist[currentPlayingSongIndex]
    }
    
    // Song button controller
    private var canPlayNextSong: Bool {
        currentPlayingSongIndex + 1 < currentPlaylist.count
    }
    private var canPlayPreviousSong: Bool {
        currentPlayingSongIndex - 1 >= 0
    }
    private var isPlayingSong = false
    
    // Song timer
    private var songTimeInMillis: Int32? {
        currentPlayingSong.trackTimeMillis
    }
    private var currentSongTimeInMillis: Int32 = 0
    private var songTimer: Timer?
    
    // Public methods
    func startPlaying(playlist: [ItunesSearchObject], playSongIndex: Int) {
        guard playSongIndex < playlist.count else { return }
        currentPlaylist = playlist
        currentPlayingSongIndex = playSongIndex
        prepareToPlaySong()
    }
    
    func playNextSong() {
        if canPlayNextSong {
            currentPlayingSongIndex = currentPlayingSongIndex + 1
            prepareToPlaySong()
        }
    }
    
    func playPreviousSong() {
        if canPlayPreviousSong {
            currentPlayingSongIndex = currentPlayingSongIndex - 1
            prepareToPlaySong()
        }
    }
    
    func playPauseSong() {
        isPlayingSong ? pauseSong() : playSong()
    }
    
    func playSong() {
        player?.play()
        songTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        isPlayingSong = true
        playerState = .updatePlayPauseButton(isPlaying: isPlayingSong)
    }
    
    func setTrackTime(newValue: Int32) {
        pauseSong()
        currentSongTimeInMillis = newValue
        playerState = .updateTrackTimer(
            currentTrackTimeInMillis: currentSongTimeInMillis,
            totalTrackTimeInMillis: songTimeInMillis
        )
    }
    
    // Private methods
    private func prepareToPlaySong() {
        pauseSong()
        player = nil
        playerState = .playSong(
            song: currentPlayingSong,
            canPlayNextSong: canPlayNextSong,
            canPlayPreviousSong: canPlayPreviousSong
        )
        currentSongTimeInMillis = 0
        playTrackForReal()
        playSong()
    }
    
    @objc private func runTimer() {
        if let songTimeInMillis = songTimeInMillis,
           currentSongTimeInMillis >= songTimeInMillis - 1000 {
            pauseSong()
            playNextSong()
            return
        }
        currentSongTimeInMillis += 1000
        playerState = .updateTrackTimer(
            currentTrackTimeInMillis: currentSongTimeInMillis,
            totalTrackTimeInMillis: songTimeInMillis
        )
    }
    
    private func pauseSong() {
        player?.pause()
        songTimer?.invalidate()
        isPlayingSong = false
        playerState = .updatePlayPauseButton(isPlaying: isPlayingSong)
    }
    
    // This plays the track preview.
    private func playTrackForReal() {
        guard let previewUrl = currentPlayingSong.previewUrl,
              let url = URL(string: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}

extension PlayerManager {
    enum PlayerState {
        case none
        case playSong(
            song: ItunesSearchObject,
            canPlayNextSong: Bool,
            canPlayPreviousSong: Bool
        )
        case updateTrackTimer(
            currentTrackTimeInMillis: Int32,
            totalTrackTimeInMillis: Int32?
        )
        case updatePlayPauseButton(isPlaying: Bool)
    }
}
