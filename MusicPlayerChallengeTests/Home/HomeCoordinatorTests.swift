//
//  HomeCoordinatorTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import XCTest
@testable import MusicPlayerChallenge

final class HomeCoordinatorTests: XCTestCase {
    var navigationControllerMock: UINavigationControllerMock!
    var coordinator: HomeCoordinator!

    override func setUp() {
        super.setUp()
        navigationControllerMock = UINavigationControllerMock()
        coordinator = HomeCoordinator(navigationController: navigationControllerMock)
    }

    func test_startCoordinatorWithDisplayableContent() {
        // When
        coordinator.start()
        
        // Then
        XCTAssertTrue(navigationControllerMock.didTriedToPushViewController)
        XCTAssert(navigationControllerMock.pushedViewController is HomeViewController)
    }
}
