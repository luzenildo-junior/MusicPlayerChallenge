//
//  ViewController.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Combine
import UIKit

class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    let networkAPI = MusicPlayerSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        networkAPI.searchForTerm(query: "fear of the dark")
            .receive(on: DispatchQueue.main)
            .sink { promiseCompletion in
                switch promiseCompletion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: { response in
                let songsCount = response.resultCount
                let songs = response.results
            }
            .store(in: &cancellables)
    }
}
