//
//  AlbumScreenViewModelTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 27/09/23.
//

import Combine
import XCTest
@testable import MusicPlayerChallenge

final class AlbumScreenViewModelTests: XCTestCase {
    private var sessionMock: MusicPlayerSessionMock!
    private var service: AlbumScreenService!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        sessionMock = MusicPlayerSessionMock()
        service = AlbumScreenService(service: sessionMock)
    }
    
    override func tearDown() {
        super.tearDown()
        sessionMock = nil
        service = nil
    }
    
    func test_fetchAlbumTracks_whenAlbumHasTracks() {
        // Given
        let expectedResult: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        let viewModel = AlbumScreenViewModel(service: service, albumId: 12345)
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        viewModel.fetchAlbumTracks()
        
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .updateAlbumScreen(let albumName):
                    XCTAssertEqual(albumName, "Fear of the Dark")
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(viewModel.numberOfTracksInTheAlbum(), 12)
    }
    
    func test_fetchAlbumTracks_whenAlbumHasNoTracks() {
        // Given
        sessionMock.promiseFuture = Future { $0(.success(ItunesSearchResponse(resultCount: 1,
                                                                              results: []))) }
        let viewModel = AlbumScreenViewModel(service: service, albumId: 12345)
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        viewModel.fetchAlbumTracks()
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .empty:
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(viewModel.numberOfTracksInTheAlbum(), 0)
    }
    
    func test_getTrackInfo() {
        // Given
        let expectedResult: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        let viewModel = AlbumScreenViewModel(service: service, albumId: 12345)
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .updateAlbumScreen(let albumName):
                    XCTAssertEqual(albumName, "Fear of the Dark")
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        viewModel.fetchAlbumTracks()
        
        // Then
        waitForExpectations(timeout: 5.0)
        let albumTrack = viewModel.getTrackInfo(for: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(albumTrack)
        XCTAssertEqual(albumTrack?.songName, "Be Quick or Be Dead")
    }
}
