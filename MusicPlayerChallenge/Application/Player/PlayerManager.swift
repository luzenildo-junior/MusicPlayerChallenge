//
//  PlayerManager.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 24/09/23.
//

import Combine
import Foundation

final class PlayerManager {
    static var shared = PlayerManager()
    
    @Published var playerState: PlayerState = .empty
    
    // Music and playlist
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
        playSong()
    }
    
    func playNextSong() {
        if canPlayNextSong {
            currentPlayingSongIndex = currentPlayingSongIndex + 1
            playSong()
        }
    }
    
    func playPreviousSong() {
        if canPlayPreviousSong {
            currentPlayingSongIndex = currentPlayingSongIndex - 1
            playSong()
        }
    }
    
    func cleanPlayer() {
        currentPlayingSongIndex = 0
        currentPlaylist = [ItunesSearchObject]()
    }
    
    func startTimer() {
        songTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        songTimer?.invalidate()
    }
    
    func setTrackTime(newValue: Int32) {
        pauseTimer()
        currentSongTimeInMillis = newValue
        playerState = .updateTrackTimer(
            currentTrackTimeInMillis: currentSongTimeInMillis,
            totalTrackTimeInMillis: songTimeInMillis
        )
    }
    
    // Private methods
    private func playSong() {
        pauseTimer()
        playerState = .playSong(
            song: currentPlayingSong,
            canPlayNextSong: canPlayNextSong,
            canPlayPreviousSong: canPlayPreviousSong
        )
        currentSongTimeInMillis = 0
        startTimer()
    }
    
    @objc private func runTimer() {
        if let songTimeInMillis = songTimeInMillis,
           currentSongTimeInMillis >= songTimeInMillis - 1000 {
            pauseTimer()
            playNextSong()
            return
        }
        currentSongTimeInMillis += 1000
        playerState = .updateTrackTimer(
            currentTrackTimeInMillis: currentSongTimeInMillis,
            totalTrackTimeInMillis: songTimeInMillis
        )
    }
}

extension PlayerManager {
    enum PlayerState {
        case empty
        case playSong(
            song: ItunesSearchObject,
            canPlayNextSong: Bool,
            canPlayPreviousSong: Bool
        )
        case updateTrackTimer(
            currentTrackTimeInMillis: Int32,
            totalTrackTimeInMillis: Int32?
        )
    }
}
