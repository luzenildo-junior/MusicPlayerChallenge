//
//  AlbumScreenCoordinatorTests.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import XCTest
@testable import MusicPlayerChallenge

class AlbumScreenCoordinatorTests: XCTestCase {
    var navigationControllerMock: UINavigationControllerMock!
    var coordinator: AlbumScreenCoordinator!

    override func setUp() {
        super.setUp()
        navigationControllerMock = UINavigationControllerMock()
        coordinator = AlbumScreenCoordinator(navigationController: navigationControllerMock)
    }

    func test_startCoordinatorWithDisplayableContent() {
        // Given
        let albumId: Int64 = 0123456
        
        // When
        coordinator.start(albumId: albumId)
        
        // Then
        XCTAssertTrue(navigationControllerMock.didPresentViewController)
        XCTAssert(navigationControllerMock.mockPresentedViewController is UINavigationController)
        let navRootView = (navigationControllerMock.mockPresentedViewController as? UINavigationController)?.topViewController
        XCTAssertNotNil(navRootView)
        XCTAssert(navRootView is AlbumScreenViewController)
    }
}
