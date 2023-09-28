//
//  AlbumScreenService.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 25/09/23.
//

import Combine
import Foundation

final class AlbumScreenService {
    private let service: MusicPlayerSessionProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: MusicPlayerSessionProtocol = MusicPlayerSession()) {
        self.service = service
    }
    
    func fetchAlbumInfo(albumId: Int64,
                        completion: @escaping (Result<[ItunesSearchObject], Error>) -> ()) {
        self.service.getAlbumTracks(albumId: albumId)
            .receive(on: DispatchQueue.main)
            .sink { promiseCompletion in
                switch promiseCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                let albumResult = Array(response.results.dropFirst())
                completion(.success(albumResult))
            }
            .store(in: &cancellables)
    }
}
