//
//  TrackModalViewModel.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Combine
import Foundation
import UIKit

final class TrackModalViewModel {
    // MARK: View model elements
    @Published var viewState: ViewState = .none
    private let trackDetails: ItunesSearchObject
    private let options: [Option] = Option.allCases
    
    private let viewModelAction: (Action) -> ()
    
    init(trackDetails: ItunesSearchObject,
         viewModelAction: @escaping (Action) -> ()) {
        self.trackDetails = trackDetails
        self.viewModelAction = viewModelAction
    }
    
    // MARK: Public methods
    func getTrackDisplayableContent() {
        viewState = .configureModal(
            trackDisplayableContent: SongDetailsDisplayableContent(
                songName: trackDetails.trackName,
                songArtist: trackDetails.artistName,
                albumImageLink: nil,
                songTotalTime: nil
            )
        )
    }
    
    func numberOfOptions() -> Int {
        options.count
    }
    
    func getOptionDisplayableContent(for indexPath: IndexPath) -> MoreOptionsDisplayableContent? {
        guard indexPath.row < options.count else { return nil }
        let option = self.options[indexPath.row]
        switch option {
        case .OpenAlbum:
            return MoreOptionsDisplayableContent(optionTitle: "Open Album",
                                                 optionIcon: UIImage(named: "album-icon"))
        }
    }
    
    func didTapOption(for indexPath: IndexPath) {
        guard indexPath.row < options.count else { return }
        let option = self.options[indexPath.row]
        switch option {
        case .OpenAlbum:
            navigateToAlbumScreen()
        }
    }
    
    // MARK: Private methods
    private func navigateToAlbumScreen() {
        viewModelAction(.navigateToAlbumScreen(albumId: trackDetails.collectionId))
    }
}

extension TrackModalViewModel {
    enum ViewState {
        case none
        case configureModal(trackDisplayableContent: SongDetailsDisplayableContent)
    }
    
    enum Action {
        case navigateToAlbumScreen(albumId: Int64)
    }
    
    enum Option: CaseIterable {
        case OpenAlbum
    }
}
