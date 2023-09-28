//
//  HomeService.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 23/09/23.
//

import Combine
import Foundation

final class HomeService {
    private let service: MusicPlayerSessionProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: MusicPlayerSessionProtocol = MusicPlayerSession()) {
        self.service = service
    }
    
    func searchForTerm(query: String,
                       page: Int,
                       completion: @escaping (Result<[ItunesSearchObject], Error>) -> ()) {
        service.searchForTerm(query: query, page: page)
            .receive(on: DispatchQueue.main)
            .sink { promiseCompletion in
                switch promiseCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                completion(.success(response.results))
            }
            .store(in: &cancellables)
    }
}
