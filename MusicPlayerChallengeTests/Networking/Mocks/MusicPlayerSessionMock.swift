//
//  MusicPlayerSessionMock.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Combine
@testable import MusicPlayerChallenge
import Foundation

final class MusicPlayerSessionMock: MusicPlayerSessionProtocol {
    var didSearchForTerm = false
    var didGetAlbumTracks = false

    var promiseFuture: Future<ItunesSearchResponse, Error>?
    
    func searchForTerm(query: String, page: Int) -> Future<ItunesSearchResponse, Error> {
        didSearchForTerm = true
        return returnPromise()
    }
    
    func getAlbumTracks(albumId: Int64) -> Future<ItunesSearchResponse, Error> {
        didGetAlbumTracks = true
        return returnPromise()
    }
    
    private func returnPromise() -> Future<ItunesSearchResponse, Error> {
        guard let promiseFuture = promiseFuture else {
            return Future { $0(.failure(APIErrors.NetworkError)) }
        }
        return promiseFuture
    }
}
