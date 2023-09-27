//
//  AlbumScreenViewModel.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 25/09/23.
//

import Combine
import Foundation

final class AlbumScreenViewModel {
    @Published var viewState: ViewState = .loading
    private let service: AlbumScreenService
    private let albumId: Int64
    private var albumTracks = [ItunesSearchObject]()
    
    init(service: AlbumScreenService = AlbumScreenService(),
         albumId: Int64) {
        self.service = service
        self.albumId = albumId
    }
    
    func fetchAlbumTracks() {
        service.fetchAlbumInfo(albumId: albumId) { result in
            switch result {
            case .success(let albumTracks):
                self.albumTracks.append(contentsOf: albumTracks)
                guard !albumTracks.isEmpty else {
                    self.viewState = .empty
                    return
                }
                self.viewState = .updateAlbumScreen(albumName: albumTracks[0].collectionName)
            case .failure(let error):
                self.viewState = .error(message: error.localizedDescription)
            }
        }
    }
    
    func numberOfTracksInTheAlbum() -> Int {
        albumTracks.count
    }
    
    func getTrackInfo(for indexPath: IndexPath) -> SongDetailsDisplayableContent? {
        guard indexPath.row < albumTracks.count else {
            return nil
        }
        let track = albumTracks[indexPath.row]
        return SongDetailsDisplayableContent(songName: track.trackName,
                                             songArtist: track.artistName,
                                             albumImageLink: track.artworkUrl100,
                                             songTotalTime: track.trackTimeMillis)
    }
}

extension AlbumScreenViewModel {
    enum ViewState {
        case updateAlbumScreen(albumName: String)
        case loading
        case empty
        case error(message: String)
    }
}
