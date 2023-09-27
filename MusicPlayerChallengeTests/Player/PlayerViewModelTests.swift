//
//  PlayerViewModelTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Combine
import XCTest
@testable import MusicPlayerChallenge

final class PlayerViewModelTests: XCTestCase {
    private var viewModel: PlayerViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func test_viewState_whenPlayerStateIsPlaySong() {
        // Given
        viewModel = PlayerViewModel(viewModelAction: { action in
            XCTFail("should not enter here")
        })
        let playlist: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        let expectation = expectation(description: "expected to parse the data")
        expectation.assertForOverFulfill = false
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { viewState in
                switch viewState {
                case .updateView(let song):
                    // Then
                    XCTAssertEqual(song.songDisplayableContent.songName, "Fear of the Dark")
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        PlayerManager.shared.startPlaying(playlist: playlist.results, playSongIndex: 0)
        
        waitForExpectations(timeout: 5.0)
    }
    
    func test_viewState_whenPlayerUpdateTracker() {
        // Given
        viewModel = PlayerViewModel(viewModelAction: { action in
            XCTFail("should not enter here")
        })
        let playlist: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        let expectations = [expectation(description: "expected to parse the data"),
                            expectation(description: "expected to parse the data")]
        expectations.forEach { $0.assertForOverFulfill = false }
        var expectationCount = 0
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { viewState in
                switch viewState {
                case .updateView(let song):
                    // Then
                    XCTAssertEqual(song.songDisplayableContent.songName, "Fear of the Dark")
                    expectations[expectationCount].fulfill()
                    expectationCount += 1
                case .updateTrackTimer(_ , let currentTrackTimeInMillis):
                    XCTAssertEqual(currentTrackTimeInMillis, 438114)
                    expectations[expectationCount].fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        PlayerManager.shared.startPlaying(playlist: playlist.results, playSongIndex: 0)
        wait(for: expectations, timeout: 5.0)
    }
    
    func test_didTapMoreButton_whenPlayerStateIsPlaySong() {
        // Given
        var didOpenSongModal = false
        viewModel = PlayerViewModel(viewModelAction: { action in
            switch action {
            case .openSongModal:
                didOpenSongModal = true
            }
        })
        let playlist: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        let expectation = expectation(description: "expected to parse the data")
        expectation.assertForOverFulfill = false
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { viewState in
                switch viewState {
                case .updateView(let song):
                    XCTAssertEqual(song.songDisplayableContent.songName, "Fear of the Dark")
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        PlayerManager.shared.startPlaying(playlist: playlist.results, playSongIndex: 0)
        waitForExpectations(timeout: 5.0)
        viewModel.didTapMoreButton()
        
        // Then
        XCTAssertTrue(didOpenSongModal)
    }
}
