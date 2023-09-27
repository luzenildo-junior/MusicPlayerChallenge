//
//  MusicPlayerChallengeUITests.swift
//  MusicPlayerChallengeUITests
//
//  Created by Luzenildo Junior on 21/09/23.
//

import XCTest

class MusicPlayerChallengeUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment = ["UITEST_DISABLE_ANIMATIONS" : "YES"]
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    private func searchForFearOfTheDark() {
        UIPasteboard.general.string = "fear of the dark"
        
        let homeView = app.otherElements["homeView"]
        _ = homeView.waitForExistence(timeout: 5.0)
        let homeSearchBar = app.otherElements["searchBar-field"]
        
        homeSearchBar.tap()
        homeSearchBar.doubleTap()
        // Make sure that your simulator is set as en_us
        app.menuItems["Paste"].tap()
    }
    
    func testIfSplashScreenAppears() {
        app.launch()
        let landingView = app.otherElements["splash-view"]
        let fuzeLogo = app.images["splash-logo"]
        
        XCTAssertTrue(landingView.exists)
        XCTAssertTrue(fuzeLogo.exists)
    }
    
    func testIfHomeViewAppears() {
        app.launch()
        
        let homeView = app.otherElements["homeView"]
        _ = homeView.waitForExistence(timeout: 5.0)
        let homeTableView = app.tables["songSearch-tableView"]
        let homeSearchBar = app.otherElements["searchBar-field"]
        
        XCTAssertTrue(homeView.exists)
        XCTAssertTrue(homeTableView.exists)
        XCTAssertTrue(homeSearchBar.exists)
    }
    
    func testTrackSearch() {
        app.launch()
        searchForFearOfTheDark()
        
        let homeTableView = app.tables["songSearch-tableView"]
        let cell = homeTableView.cells.element(matching: .cell, identifier: "songDetailsCell_0")
        _ = cell.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(cell.exists)
    }
    
    func testIfAlbumViewAppears() {
        app.launch()
        searchForFearOfTheDark()
        
        let homeTableView = app.tables["songSearch-tableView"]
        let cell = homeTableView.cells.element(matching: .cell, identifier: "songDetailsCell_0")
        _ = cell.waitForExistence(timeout: 5.0)
        cell.tap()
        sleep(1)
        
        let playerView = app.otherElements["playerView"]
        _ = playerView.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(playerView.exists)
    }
    
    func testIfMoreOptionsScreenAppears() {
        app.launch()
        searchForFearOfTheDark()
        
        let homeTableView = app.tables["songSearch-tableView"]
        let cell = homeTableView.cells.element(matching: .cell, identifier: "songDetailsCell_0")
        _ = cell.waitForExistence(timeout: 5.0)
        cell.tap()
        sleep(1)
        
        let playerView = app.otherElements["playerView"]
        _ = playerView.waitForExistence(timeout: 5.0)
        let moreOptionsButton = app.buttons["moreOptionsButton"]
        _ = moreOptionsButton.waitForExistence(timeout: 5.0)
        moreOptionsButton.tap()
        
        let moreOptionsView = app.otherElements["moreOptionsView"]
        _ = moreOptionsView.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(moreOptionsView.exists)
    }
    
    func testIfAlbumScreenAppears() {
        app.launch()
        searchForFearOfTheDark()
        
        let homeTableView = app.tables["songSearch-tableView"]
        let songDetailsCell = homeTableView.cells.element(matching: .cell, identifier: "songDetailsCell_0")
        _ = songDetailsCell.waitForExistence(timeout: 5.0)
        songDetailsCell.tap()
        sleep(1)
        
        let playerView = app.otherElements["playerView"]
        _ = playerView.waitForExistence(timeout: 5.0)
        let moreOptionsButton = app.buttons["moreOptionsButton"]
        _ = moreOptionsButton.waitForExistence(timeout: 5.0)
        moreOptionsButton.tap()
        
        let moreOptionsView = app.otherElements["moreOptionsView"]
        _ = moreOptionsView.waitForExistence(timeout: 5.0)
        let moreOptionsTableView = app.tables["moreOptions-tableView"]
        let moreOptionsCell = moreOptionsTableView.cells.element(matching: .cell, identifier: "moreOptionsCell_0")
        _ = moreOptionsCell.waitForExistence(timeout: 5.0)
        moreOptionsCell.tap()
        
        let albumView = app.otherElements["albumScreenView"]
        _ = albumView.waitForExistence(timeout: 5.0)
        let albumTableView = app.tables["albumScreen-tableView"]
        _ = albumTableView.waitForExistence(timeout: 5.0)
        let albumCell = albumTableView.cells.element(matching: .cell, identifier: "albumScreenCell_0")
        _ = albumCell.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(albumCell.exists)
    }
}
