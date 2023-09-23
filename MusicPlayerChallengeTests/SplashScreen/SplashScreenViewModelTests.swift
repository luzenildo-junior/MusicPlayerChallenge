//
//  SplashScreenViewModelTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 23/09/23.
//

import Combine
@testable import MusicPlayerChallenge
import XCTest

class SplashScreenViewModelTests: XCTestCase {
    private var viewModel: SplashScreenViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        viewModel = SplashScreenViewModel()
    }
    
    func test_dismissViewWhenCountdownFinishes() {
        // Given
        let expectation = expectation(description: "expected to dismiss the view")
        
        viewModel.$dismissSplash
            .sink { value in
                // Then
                if value {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.dismissSplashAfter(seconds: 3.0)
        waitForExpectations(timeout: 5.0)
    }
}
