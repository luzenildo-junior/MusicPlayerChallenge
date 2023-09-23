//
//  ItunesSearchResponseTest.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 21/09/23.
//

@testable import MusicPlayerChallenge
import XCTest

final class ItunesSearchResponseTest: XCTestCase {
    func testModelParse_withSearchTerm() {
        // Given
        let parsedData: ItunesSearchResponse = "SearchResult".decodeJSONFromFileName()
        
        // When
        let parsedObject = parsedData.results[0]
        
        // Then
        XCTAssertEqual(parsedObject.artistName, "Iron Maiden")
        XCTAssertNotNil(parsedObject.artworkUrl100)
        XCTAssertEqual(parsedObject.collectionName, "Fear of the Dark")
        XCTAssertEqual(parsedObject.trackName, "Fear of the Dark")
        XCTAssertNotNil(parsedObject.collectionId)
        XCTAssertEqual(parsedObject.trackTimeMillis, 438114)
    }
    
    func testModelParse_withAlbumFetch() {
        // Given
        let parsedData: ItunesSearchResponse = "FetchAlbumResult".decodeJSONFromFileName()
        
        // When
        let parsedObject = parsedData.results[1] // get first track of the album
        
        // Then
        XCTAssertEqual(parsedObject.artistName, "Iron Maiden")
        XCTAssertNotNil(parsedObject.artworkUrl100)
        XCTAssertEqual(parsedObject.collectionName, "Fear of the Dark")
        XCTAssertEqual(parsedObject.trackName, "Be Quick or Be Dead")
        XCTAssertNotNil(parsedObject.collectionId)
        XCTAssertEqual(parsedObject.trackTimeMillis, 203650)
    }
}
