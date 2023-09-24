//
//  MusicPlayerSession.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Combine
import Foundation

protocol MusicPlayerSessionProtocol {
    func searchForTerm(query: String, page: Int) -> Future<ItunesSearchResponse, Error>
    func getAlbumTracks(albumName: String) -> Future<ItunesSearchResponse, Error>
}

final class MusicPlayerSession {
    private var cancellables = Set<AnyCancellable>()
    private let API: APIProtocol
    
    /// Public service init to be injected in main app service layer
    init() {
        self.API = NetworkAPI()
    }
    
    /// Internal service init to inject some mocked networking api.
    /// Should be used for testing purposes
    init(API: APIProtocol = NetworkAPI()) {
        self.API = API
    }
}

extension MusicPlayerSession: MusicPlayerSessionProtocol {
    func searchForTerm(query: String, page: Int) -> Future<ItunesSearchResponse, Error> {
        API.fetchData(for: SearchTermRequest(searchQuery: query, page: page), type: ItunesSearchResponse.self)
    }
    
    func getAlbumTracks(albumName: String) -> Future<ItunesSearchResponse, Error> {
        API.fetchData(for: FetchAlbumRequest(albumID: albumName), type: ItunesSearchResponse.self)
    }
}
