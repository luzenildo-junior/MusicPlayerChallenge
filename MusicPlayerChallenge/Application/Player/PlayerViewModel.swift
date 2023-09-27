//
//  PlayerViewModel.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 24/09/23.
//

import Combine
import Foundation

final class PlayerViewModel {
    @Published var viewState: State = .none
    private let playerManager = PlayerManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModelAction: (Action) -> ()
    
    init(viewModelAction: @escaping (Action) -> ()) {
        self.viewModelAction = viewModelAction
        subscribeToPublishers()
    }
        
    private func subscribeToPublishers() {
        playerManager.$playerState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] playerState in
                guard let self = self else { return }
                switch playerState {
                case .playSong(let song,
                               let canPlayNextSong,
                               let canPlayPreviousSong):
                    let songDisplayableContent = SongDetailsDisplayableContent(
                        songName: song.trackName,
                        songArtist: song.artistName,
                        albumImageLink: song.artworkUrl100,
                        songTotalTime: song.trackTimeMillis
                    )
                    self.viewState = .updateView(
                        song: PlayerDiplayableContent(
                            songDisplayableContent: songDisplayableContent,
                            canPlayNextSong: canPlayNextSong,
                            canPlayPreviousSong: canPlayPreviousSong,
                            currentSongTime: 0
                        )
                    )
                case .updateTrackTimer(let currentTrackTimeInMillis, let totalTrackTimeInMillis):
                    self.viewState = .updateTrackTimer(
                        currentTrackTimeInMillis: currentTrackTimeInMillis,
                        totalTrackTimeInMillis: totalTrackTimeInMillis
                    )
                case .updatePlayPauseButton(let isPlaying):
                    self.viewState = .updatePlayPauseButton(isPlaying: isPlaying)
                case .none:
                    break
                }
        }
            .store(in: &cancellables)
    }
    
    func didTapMoreButton() {
        viewModelAction(.openSongModal(currentPlayingTrack: playerManager.currentPlayingSong))
    }
}

extension PlayerViewModel {
    enum State {
        case none
        case updateView(song: PlayerDiplayableContent)
        case updateTrackTimer(currentTrackTimeInMillis: Int32,
                              totalTrackTimeInMillis: Int32?)
        case updatePlayPauseButton(isPlaying: Bool)
    }
    
    enum Action {
        case openSongModal(currentPlayingTrack: ItunesSearchObject)
    }
}
