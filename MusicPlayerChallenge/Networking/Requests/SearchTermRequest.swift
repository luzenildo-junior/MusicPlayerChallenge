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
    
    /// Parameters for team request
    ///     - Parameters:
    ///         - id: team id to get informations from
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
