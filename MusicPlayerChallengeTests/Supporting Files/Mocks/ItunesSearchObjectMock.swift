//
//  ItunesSearchObjectMock.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

@testable import MusicPlayerChallenge

extension ItunesSearchObject {
    static var mock: ItunesSearchObject {
        ItunesSearchObject(
            artistName: "artistName",
            collectionName: "collectionName",
            collectionId: 0123456,
            trackName: "trackName",
            artworkUrl100: "artworkURL",
            trackTimeMillis: 01234
        )
    }
}
