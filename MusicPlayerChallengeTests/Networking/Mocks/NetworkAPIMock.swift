//
//  NetworkAPIMock.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Combine
@testable import MusicPlayerChallenge

final class NetworkAPIMock<T: Decodable>: APIProtocol {
    let mockFilename: String?
    
    init(mockFilename: String?) {
        self.mockFilename = mockFilename
    }
    
    func fetchData<T>(for urlConvertible: URLRequestConvertible,
                      type: T.Type) -> Future<T, Error> where T : Decodable {
        Future { promise in
            guard let mockFile = self.mockFilename else {
                promise(.failure(APIErrors.NetworkError))
                return
            }
            promise(.success(mockFile.decodeJSONFromFileName()))
        }
    }
}
