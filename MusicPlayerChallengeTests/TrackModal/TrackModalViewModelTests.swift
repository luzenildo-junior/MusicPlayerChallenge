//
//  TrackModalViewModelTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 27/09/23.
//

import Combine
import XCTest
@testable import MusicPlayerChallenge

final class TrackModalViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func test_getTrackDisplayableContent() {
        // Given
        let track: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let viewModel = TrackModalViewModel(trackDetails: track.results[1]) { _ in
            XCTFail("Should not call action")
        }
        let expectation = expectation(description: "expected to fetch data")
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { viewState in
                switch viewState {
                case .configureModal(let trackDisplayableContent):
                    // Then
                    XCTAssertEqual(trackDisplayableContent.songName, "Be Quick or Be Dead")
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        viewModel.getTrackDisplayableContent()
        
        waitForExpectations(timeout: 5.0)
    }
    
    func test_numberOfOptions() {
        // Given
        let track: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let viewModel = TrackModalViewModel(trackDetails: track.results[1]) { _ in
            XCTFail("Should not call action")
        }
        
        // When
        let numberOfOptions = viewModel.numberOfOptions()
        
        // Then
        XCTAssertEqual(numberOfOptions, 1)
    }
    
    func test_getOptionDisplayableContent() {
        // Given
        let track: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let viewModel = TrackModalViewModel(trackDetails: track.results[1]) { _ in
            XCTFail("Should not call action")
        }
        
        // When
        let displayableContent = viewModel.getOptionDisplayableContent(for: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertEqual(displayableContent?.optionTitle, "Open Album")
    }
    
    func test_didTapOption() {
        // Given
        var didCallNavigateToAlbum = false
        let track: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let viewModel = TrackModalViewModel(trackDetails: track.results[1]) { action in
            switch action {
            case .navigateToAlbumScreen:
                didCallNavigateToAlbum = true
            }
        }
        
        // When
        viewModel.didTapOption(for: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertTrue(didCallNavigateToAlbum)
    }
}
