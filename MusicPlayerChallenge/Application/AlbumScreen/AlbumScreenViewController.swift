//
//  AlbumScreenViewController.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 25/09/23.
//

import Combine
import Foundation
import UIKit

final class AlbumScreenViewController: BaseViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(type: SongDetailsCell.self)
        tableView.accessibilityIdentifier = "songSearch-tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: AlbumScreenViewModel
    
    // MARK: Lifecycle methods
    init(viewModel: AlbumScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        subscribeToPublishers()
        viewModel.fetchAlbumTracks()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func subscribeToPublishers() {
        viewModel.$viewState
            .sink { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .loading:
                    self.startLoading()
                case .updateAlbumScreen(let albumName):
                    self.title = albumName
                    self.stopLoading()
                    self.tableView.reloadData()
                case .error:
                    // show error view
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension AlbumScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTracksInTheAlbum()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(for: SongDetailsCell.self,
                                                       indexPath: indexPath),
              let songDetails = viewModel.getTrackInfo(for: indexPath) else { return UITableViewCell() }
        cell.setupSongInfo(songDetails: songDetails)
        return cell
    }
}
