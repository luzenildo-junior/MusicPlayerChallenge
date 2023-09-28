//
//  HomeViewController.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 23/09/23.
//

import Combine
import Foundation
import UIKit

final class HomeViewController: BaseViewController {
    // MARK: View UI elements
    private let searchBar = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(type: SongDetailsCell.self)
        tableView.accessibilityIdentifier = "songSearch-tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     Nothing to see here.
                     Please search something.
                     """
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = AppColors.songDetailsArtistTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HomeViewModel
    
    // MARK: Lifecycle methods
    init(viewModel: HomeViewModel) {
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
    }
    
    // MARK: Private Methods
    private func setupView() {
        title = "Songs"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.accessibilityIdentifier = "homeView"
        setupSearchBar()
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            // tableView
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // emptyStateLabel
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.searchBar.placeholder = "Search"
        searchBar.searchBar.barStyle = .black
        searchBar.searchBar.isAccessibilityElement = true
        searchBar.searchBar.accessibilityIdentifier = "searchBar-field"
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    private func subscribeToPublishers() {
        viewModel.$viewState
            .sink { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .empty:
                    self.stopLoading()
                    self.tableView.reloadData()
                    self.emptyStateLabel.isHidden = false
                case .loading:
                    self.startLoading()
                    self.emptyStateLabel.isHidden = true
                case .finishedSearching:
                    self.emptyStateLabel.isHidden = true
                    self.stopLoading()
                    self.tableView.reloadData()
                case .error(let errorMessage):
                    self.showAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else { return }
        if searchQuery.isEmpty {
            viewModel.cleanSeachData()
        } else {
            viewModel.searchForTermAfterDelay(query: searchQuery)
        }
    }
}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSearchedSongs()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(for: SongDetailsCell.self,
                                                       indexPath: indexPath),
              let songDetails = viewModel.getSongInfo(for: indexPath) else { return UITableViewCell() }
        cell.setupSongInfo(songDetails: songDetails)
        cell.accessibilityIdentifier = "songDetailsCell_\(indexPath.row)"
        return cell
    }
}

// MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedSong(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let searchQuery = searchBar.searchBar.text else { return }
        if indexPath.row == viewModel.numberOfSearchedSongs() - 2 {
            viewModel.loadMoreData(query: searchQuery)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.searchBar.resignFirstResponder()
    }
}
