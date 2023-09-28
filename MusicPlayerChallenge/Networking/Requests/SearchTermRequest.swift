//
//  SearchTermRequest.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Foundation

struct SearchTermRequest: APIRequest {
    let searchQuery: String
    let page: Int
    let numberOfFetchedItems = 30
    
    var path: String {
        "search"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    /// Parameters to search request
    ///     - Parameters:
    ///         - albumId: A searchQuery and page to search for songs.
    var parameters: RequestParameters {
        .queryItems(
            [
                "term": searchQuery,
                "media": "music",
                "entity": "song",
                "limit": numberOfFetchedItems,
                "offset": page * numberOfFetchedItems
            ]
        )
    }
}
