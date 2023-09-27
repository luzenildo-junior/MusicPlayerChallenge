//
//  HomeViewModelTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Combine
import XCTest
@testable import MusicPlayerChallenge

final class HomeViewModelTests: XCTestCase {
    private var sessionMock: MusicPlayerSessionMock!
    private var service: HomeService!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        sessionMock = MusicPlayerSessionMock()
        service = HomeService(service: sessionMock)
    }
    
    func test_searchForTermAfterDelay() {
        // Given
        let expectedResult: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        let viewModel = HomeViewModel(service: service) { action in
            XCTFail("should not enter here")
        }
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        viewModel.searchForTermAfterDelay(query: "queryString")
        
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .finishedSearching:
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(viewModel.numberOfSearchedSongs(), 50)
    }
    
    func test_loadMoreData() {
        // Given
        let expectedResult: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        let viewModel = HomeViewModel(service: service) { action in
            XCTFail("should not enter here")
        }
        let expectations = [expectation(description: "expected to fetch term"),
                           expectation(description: "expected to fetch more")]
        var expectationCount = 0
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .finishedSearching:
                    expectations[expectationCount].fulfill()
                    expectationCount += 1
                default:
                    break
                }
            }
            .store(in: &cancellables)
        viewModel.searchForTermAfterDelay(query: "queryString")
        wait(for: [expectations[0]], timeout: 5.0)
        viewModel.loadMoreData(query: "queryString")
        
        // Then
        wait(for: [expectations[1]], timeout: 5.0)
        XCTAssertEqual(viewModel.numberOfSearchedSongs(), 100)
    }
    
    func test_getSongInfo() {
        // Given
        let expectedResult: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        let viewModel = HomeViewModel(service: service) { action in
            XCTFail("should not enter here")
        }
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .finishedSearching:
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        viewModel.searchForTermAfterDelay(query: "queryString")
        waitForExpectations(timeout: 5.0)
        let track = viewModel.getSongInfo(for: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertNotNil(track)
        XCTAssertEqual(track?.songName, "Fear of the Dark")
    }
    
    func test_cleanSearchData() {
        // Given
        let expectedResult: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        let viewModel = HomeViewModel(service: service) { action in
            XCTFail("should not enter here")
        }
        let expectations = [expectation(description: "expected to fetch term"),
                            expectation(description: "expected to get empty")]
        var expectationCount = 0
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .finishedSearching:
                    expectations[expectationCount].fulfill()
                    expectationCount += 1
                case .empty:
                    guard expectationCount >  0 else { return }
                    expectations[expectationCount].fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        viewModel.searchForTermAfterDelay(query: "queryString")
        wait(for: [expectations[0]], timeout: 5.0)
        viewModel.cleanSeachData()
        
        // Then
        wait(for: [expectations[1]], timeout: 5.0)
        XCTAssertEqual(viewModel.numberOfSearchedSongs(), 0)
    }
    
    func test_didSelectSong() {
        // Given
        let expectedResult: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        var didNavigateToPlayer = false
        let viewModel = HomeViewModel(service: service) { action in
            switch action {
            case .navigateToPlayer:
                didNavigateToPlayer = true
            }
        }
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .finishedSearching:
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        viewModel.searchForTermAfterDelay(query: "queryString")
        waitForExpectations(timeout: 5.0)
        viewModel.didSelectedSong(at: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertTrue(didNavigateToPlayer)
    }
}
