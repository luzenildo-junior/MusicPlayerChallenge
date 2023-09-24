//
//  HomeViewModel.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 23/09/23.
//

import Foundation

final class HomeViewModel {
    @Published var viewState: State = .empty
    private let service: HomeService
    private var searchedSongs = [ItunesSearchObject]()
    private var searchDispatchWork: DispatchWorkItem?
    private var currentPage = 0
    private let maxNumberOfPages = 4
    private var isLoadingMoreData = false
    
    init(service: HomeService = HomeService()) {
        self.service = service
    }
    
    func searchForTermAfterDelay(query: String) {
        currentPage = 0
        searchDispatchWork?.cancel()
        searchDispatchWork = DispatchWorkItem(block: {
            self.searchForTerm(query: query)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,
                                      execute: searchDispatchWork!)
    }
    
    func searchForTerm(query: String) {
        viewState = .loading
        self.service.searchForTerm(query: query, page: self.currentPage) { result in
            switch result {
            case .success(let songs):
                self.searchedSongs.append(contentsOf: songs)
                self.viewState = .finishedSearching
                self.isLoadingMoreData = false
            case .failure:
                self.viewState = .error
            }
        }
    }
    
    func loadMoreData(query: String) {
        if !isLoadingMoreData && currentPage < maxNumberOfPages {
            viewState = .loading
            isLoadingMoreData = true
            currentPage += 1
            searchForTerm(query: query)
        }
    }
    
    func numberOfSearchedSongs() -> Int {
        searchedSongs.count
    }
    
    func getSongInfo(for indexPath: IndexPath) -> SongDetailsDisplayableContent? {
        guard indexPath.row < searchedSongs.count else {
            return nil
        }
        let song = searchedSongs[indexPath.row]
        return SongDetailsDisplayableContent(songName: song.trackName,
                                             songArtist: song.artistName,
                                             albumImageLink: song.artworkUrl100)
    }
    
    func cleanSeachDate() {
        searchDispatchWork?.cancel()
        searchedSongs.removeAll()
        viewState = .empty
    }
    
    func didSelectedSong(at indexPath: IndexPath) {
        guard indexPath.row < searchedSongs.count else {
            return
        }
        let song = searchedSongs[indexPath.row]
    }
}

extension HomeViewModel {
    enum State {
        case empty
        case loading
        case finishedSearching
        case error
    }
}
