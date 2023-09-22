//
//  ItunesSearchResponse.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Foundation

struct ItunesSearchResponse: Decodable {
    let resultCount: Int
    let results: [ItunesSearchObject]
}

struct ItunesSearchObject: Decodable {
    let artistName: String
    let collectionName: String
    let collectionId: Int64
    let trackName: String?
    let artworkUrl100: String
    let trackTimeMillis: Int32?
}
