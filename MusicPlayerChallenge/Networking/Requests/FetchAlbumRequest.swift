//
//  FetchAlbumRequest.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Foundation

struct FetchAlbumRequest: APIRequest {
    let albumId: Int64
    
    var path: String {
        "lookup"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    /// Parameters for album request
    ///     - Parameters:
    ///         - albumId: A int64 id of the album to fetch the tracks
    var parameters: RequestParameters {
        .queryItems(
            [
                "id": albumId,
                "entity": "song"
            ]
        )
    }
}
