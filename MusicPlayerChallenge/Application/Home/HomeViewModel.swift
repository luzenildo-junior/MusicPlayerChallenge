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
    private var currentSearchQuery = ""
    private var currentPage = 0
    private let maxNumberOfPages = 4
    private var isLoadingMoreData = false
    
    private let viewModelAction: (Action) -> ()
    
    init(service: HomeService = HomeService(),
         viewModelAction: @escaping (Action) -> ()) {
        self.service = service
        self.viewModelAction = viewModelAction
    }
    
    func searchForTermAfterDelay(query: String) {
        currentPage = 0
        
        searchDispatchWork?.cancel()
        let searchDispatchWork = DispatchWorkItem(block: {
            if query != self.currentSearchQuery {
                self.currentSearchQuery = query
                self.searchForTerm(query: query)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,
                                      execute: searchDispatchWork)
        self.searchDispatchWork = searchDispatchWork
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
                                             albumImageLink: song.artworkUrl100,
                                             songTotalTime: song.trackTimeMillis)
    }
    
    func cleanSeachData() {
        searchDispatchWork?.cancel()
        searchedSongs.removeAll()
        viewState = .empty
    }
    
    func didSelectedSong(at indexPath: IndexPath) {
        guard indexPath.row < searchedSongs.count else {
            return
        }
        viewModelAction(.navigateToPlayer)
        PlayerManager.shared.startPlaying(playlist: searchedSongs, playSongIndex: indexPath.row)
    }
}

extension HomeViewModel {
    enum State {
        case empty
        case loading
        case finishedSearching
        case error
    }
    
    enum Action {
        case navigateToPlayer
    }
}
