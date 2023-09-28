//
//  TrackModalCoordinatorTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import XCTest
@testable import MusicPlayerChallenge

class TrackModalCoordinatorTests: XCTestCase {
    var navigationControllerMock: UINavigationControllerMock!
    var coordinator: TrackModalCoordinator!

    override func setUp() {
        super.setUp()
        navigationControllerMock = UINavigationControllerMock()
        coordinator = TrackModalCoordinator(navigationController: navigationControllerMock)
    }

    func test_startCoordinatorWithDisplayableContent() {
        // When
        coordinator.start(trackDetails: ItunesSearchObject.mock)
        
        // Then
        XCTAssertTrue(navigationControllerMock.didPresentViewController)
        XCTAssert(navigationControllerMock.mockPresentedViewController is UINavigationController)
        let navRootView = (navigationControllerMock.mockPresentedViewController as? UINavigationController)?.topViewController
        XCTAssertNotNil(navRootView)
        XCTAssert(navRootView is TrackModalViewController)
    }
}
