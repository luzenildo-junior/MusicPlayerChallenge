//
//  PlayerManagerTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Combine
import XCTest
@testable import MusicPlayerChallenge

final class PlayerManagerTests: XCTestCase {
    private let playerManager = PlayerManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    func test_startPlayingSong() {
        // Given
        let playlist: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        let expectation = expectation(description: "expected to parse the data")
        expectation.assertForOverFulfill = false
        
        // When
        playerManager.$playerState
            .receive(on: DispatchQueue.main)
            .sink { playerState in
                switch playerState {
                case .playSong(let song, let canPlayNextSong, let canPlayPreviousSong):
                    // Then
                    XCTAssertEqual(song.trackName, "Fear of the Dark")
                    XCTAssertFalse(canPlayPreviousSong)
                    XCTAssertTrue(canPlayNextSong)
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        playerManager.startPlaying(playlist: playlist.results, playSongIndex: 0)
        
        waitForExpectations(timeout: 5.0)
    }
    
    func test_playNextSong() {
        // Given
        let playlist: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let expectation = expectation(description: "expected to parse the data")
        expectation.assertForOverFulfill = false
        var fulfilmentCount = 0
        
        // When
        playerManager.$playerState
            .receive(on: DispatchQueue.main)
            .sink { playerState in
                switch playerState {
                case .playSong(let song, let canPlayNextSong, let canPlayPreviousSong):
                    // Then
                    if fulfilmentCount == 1 {
                        XCTAssertEqual(song.trackName, "From Here to Eternity")
                        XCTAssertTrue(canPlayPreviousSong)
                        XCTAssertTrue(canPlayNextSong)
                    }
                    fulfilmentCount += 1
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        playerManager.startPlaying(playlist: Array(playlist.results.dropFirst()), playSongIndex: 0)
        playerManager.playNextSong()
        
        waitForExpectations(timeout: 5.0)
    }
    
    func test_playPreviousSong() {
        // Given
        let playlist: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let expectation = expectation(description: "expected to parse the data")
        expectation.assertForOverFulfill = false
        var fulfilmentCount = 0
        
        // When
        playerManager.$playerState
            .receive(on: DispatchQueue.main)
            .sink { playerState in
                switch playerState {
                case .playSong(let song, let canPlayNextSong, let canPlayPreviousSong):
                    // Then
                    if fulfilmentCount == 2 {
                        XCTAssertEqual(song.trackName, "Fear of the Dark")
                        XCTAssertFalse(canPlayPreviousSong)
                        XCTAssertTrue(canPlayNextSong)
                    }
                    fulfilmentCount += 1
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        playerManager.startPlaying(playlist: Array(playlist.results.dropFirst()), playSongIndex: 0)
        playerManager.playPreviousSong()
        
        waitForExpectations(timeout: 5.0)
    }
    
    func test_playPauseSong() {
        // Given
        let playlist: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let expectation = expectation(description: "expected to parse the data")
        expectation.assertForOverFulfill = false
        var didUpdatePlayButton = false
        
        // When
        playerManager.$playerState
            .receive(on: DispatchQueue.main)
            .sink { playerState in
                switch playerState {
                case .updatePlayPauseButton:
                    didUpdatePlayButton = true
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        playerManager.startPlaying(playlist: Array(playlist.results.dropFirst()), playSongIndex: 0)
        playerManager.playPauseSong()
        
        // Then
        waitForExpectations(timeout: 5.0)
        XCTAssertTrue(didUpdatePlayButton)
    }
    
    func test_setTrackTime() {
        // Given
        let playlist: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        let expectation = expectation(description: "expected to parse the data")
        expectation.assertForOverFulfill = false
        var didUpdateTrackTimer = false
        
        // When
        playerManager.$playerState
            .receive(on: DispatchQueue.main)
            .sink { playerState in
                switch playerState {
                case .updateTrackTimer:
                    didUpdateTrackTimer = true
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        playerManager.startPlaying(playlist: Array(playlist.results.dropFirst()), playSongIndex: 0)
        playerManager.setTrackTime(newValue: 12345)
        
        // Then
        waitForExpectations(timeout: 5.0)
        XCTAssertTrue(didUpdateTrackTimer)
    }
}
