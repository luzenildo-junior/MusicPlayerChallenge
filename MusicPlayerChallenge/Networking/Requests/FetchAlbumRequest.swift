//
//  FetchAlbumRequest.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Foundation

struct FetchAlbumRequest: APIRequest {
    let albumID: String
    
    var path: String {
        "lookup"
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
                "id": albumID,
                "entity": "song"
            ]
        )
    }
}
