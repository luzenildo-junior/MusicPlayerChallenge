//
//  API.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Combine
import Foundation

// MARK: API errors
enum APIErrors: Error {
    case JSONParseError
    case NetworkError
}

extension APIErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .JSONParseError:
            return NSLocalizedString("An error occurred when trying to get data",
                                     comment: "data error")
        case .NetworkError:
            return NSLocalizedString("An Network error occurred, please try again later",
                                     comment: "network error")
        }
    }
}

// MARK: APIProtocol
protocol APIProtocol {
    func fetchData<T: Decodable>(for urlConvertible: URLRequestConvertible,
                                 type: T.Type) -> Future<T, Error>
}

// MARK: API Implementation
final class NetworkAPI: APIProtocol {
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData<T: Decodable>(for urlConvertible: URLRequestConvertible,
                                 type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else { return }
            do {
                let decoder = JSONDecoder()
                URLSession.shared.dataTaskPublisher(for: try urlConvertible.asURLRequest())
                    .tryMap { (data, response) -> Data in
                        guard let httpResponse = response as? HTTPURLResponse,
                              httpResponse.statusCode == 200 else {
                            throw APIErrors.NetworkError
                        }
                        return data
                    }
                    .decode(type: T.self, decoder: decoder)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            promise(.failure(error))
                        case .finished:
                            break
                        }
                    } receiveValue: {
                        promise(.success($0))
                    }
                    .store(in: &self.cancellables)
            } catch {
                promise(.failure(error))
            }
        }
    }
}
