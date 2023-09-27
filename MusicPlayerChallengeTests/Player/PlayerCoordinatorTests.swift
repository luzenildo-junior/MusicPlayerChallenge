//
//  PlayerCoordinatorTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import XCTest
@testable import MusicPlayerChallenge

class PlayerCoordinatorTests: XCTestCase {
    var navigationControllerMock: UINavigationControllerMock!
    var coordinator: PlayerCoordinator!

    override func setUp() {
        super.setUp()
        navigationControllerMock = UINavigationControllerMock()
        coordinator = PlayerCoordinator(navigationController: navigationControllerMock)
    }

    func test_startCoordinatorWithDisplayableContent() {
        // When
        coordinator.start()
        
        XCTAssertTrue(navigationControllerMock.didTriedToPushViewController)
        XCTAssert(navigationControllerMock.pushedViewController is PlayerViewController)
    }
}
