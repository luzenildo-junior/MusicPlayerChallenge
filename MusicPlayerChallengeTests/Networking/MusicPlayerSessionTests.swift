//
//  MusicPlayerSessionTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Combine
@testable import MusicPlayerChallenge
import XCTest

final class MusicPlayerSessionTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func testSearchTerm_success() {
        // Given
        let networkAPI = NetworkAPIMock<ItunesSearchResponse>(mockFilename: "SearchResult")
        let session = MusicPlayerSession(API: networkAPI)
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        session.searchForTerm(query: "queryForSearch")
            .sink { promiseCompletion in
                switch promiseCompletion {
                case .failure:
                    XCTFail("Shouldn't come here")
                case .finished:
                    break
                }
            } receiveValue: { result in
                // Then
                XCTAssertNotNil(result)
                XCTAssertEqual(result.resultCount, 50)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5)
    }
    
    func testSearchTerm_failure() {
        let networkAPI = NetworkAPIMock<ItunesSearchResponse>(mockFilename: nil)
        let session = MusicPlayerSession(API: networkAPI)
        let expectation = expectation(description: "expected to not parse the data")
        
        // When
        session.searchForTerm(query: "queryForSearch")
            .sink { promiseCompletion in
                switch promiseCompletion {
                case .failure(let error):
                    // Then
                    let apiError = error as? APIErrors
                    XCTAssertNotNil(apiError)
                    XCTAssertEqual(apiError, APIErrors.NetworkError)
                    expectation.fulfill()
                case .finished:
                    break
                }
            } receiveValue: { result in
                
                XCTFail("Shouldn't come here")
                
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5)
    }
    
    func testFetchAlbum_success() {
        // Given
        let networkAPI = NetworkAPIMock<ItunesSearchResponse>(mockFilename: "FetchAlbumResult")
        let session = MusicPlayerSession(API: networkAPI)
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        session.getAlbumTracks(albumName: "albumName")
            .sink { promiseCompletion in
                switch promiseCompletion {
                case .failure:
                    XCTFail("Shouldn't come here")
                case .finished:
                    break
                }
            } receiveValue: { result in
                // Then
                XCTAssertNotNil(result)
                XCTAssertEqual(result.resultCount, 13)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5)
    }
    
    func testFetchAlbum_failure() {
        let networkAPI = NetworkAPIMock<ItunesSearchResponse>(mockFilename: nil)
        let session = MusicPlayerSession(API: networkAPI)
        let expectation = expectation(description: "expected to not parse the data")
        
        // When
        session.getAlbumTracks(albumName: "albumName")
            .sink { promiseCompletion in
                switch promiseCompletion {
                case .failure(let error):
                    // Then
                    let apiError = error as? APIErrors
                    XCTAssertNotNil(apiError)
                    XCTAssertEqual(apiError, APIErrors.NetworkError)
                    expectation.fulfill()
                case .finished:
                    break
                }
            } receiveValue: { result in
                
                XCTFail("Shouldn't come here")
                
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5)
    }
}
