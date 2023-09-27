//
//  HomeServiceTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Combine
import XCTest
@testable import MusicPlayerChallenge

final class HomeServiceTests: XCTestCase {
    private var sessionMock: MusicPlayerSessionMock!
    private var service: HomeService!
    
    override func setUp() {
        super.setUp()
        sessionMock = MusicPlayerSessionMock()
        service = HomeService(service: sessionMock)
    }
    
    func test_searchForTerm_success() {
        // Given
        let expectedResult: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        sessionMock.promiseFuture = Future { $0(.success(expectedResult)) }
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        service.searchForTerm(query: "query", page: 0) { result in
            switch result {
            case .success(let model):
                // Then
                XCTAssertEqual(model.count, 50)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func test_searchForTerm_failure() {
        // Given
        let expectation = expectation(description: "expected to parse the data")
        
        // When
        service.searchForTerm(query: "query", page: 0) { result in
            switch result {
            case .success:
                // Then
                XCTFail("should not succeed here")
            case .failure(let error):
                XCTAssertEqual(error as! APIErrors, APIErrors.NetworkError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0)
    }
}
