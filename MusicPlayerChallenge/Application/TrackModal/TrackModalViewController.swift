//
//  TrackModalViewController.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Combine
import Foundation
import UIKit

final class TrackModalViewController: UIViewController {
    private lazy var trackName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackArtist: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = AppColors.songDetailsArtistTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(type: MoreOptionsCell.self)
        tableView.accessibilityIdentifier = "moreOptions-tableView"
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: TrackModalViewModel
    
    init(viewModel: TrackModalViewModel) {
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
        viewModel.getTrackDisplayableContent()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = AppColors.modalBackgroundColor
        
        let infoStackView = createTrackInfoStackView()
        view.addSubview(infoStackView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // track info stack view
            infoStackView.topAnchor.constraint(equalTo: view.topAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.accessibilityIdentifier = "moreOptionsView"
    }
    
    private func subscribeToPublishers() {
        viewModel.$viewState
            .sink { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .configureModal(let trackDisplayableContent):
                    self.trackName.text = trackDisplayableContent.songName
                    self.trackArtist.text = trackDisplayableContent.songArtist
                    self.tableView.reloadData()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func createTrackInfoStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [trackName, trackArtist])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 14.0
        stackView.layoutMargins = UIEdgeInsets(top: 30.0,
                                               left: 16.0,
                                               bottom: 16.0,
                                               right: 16.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}

extension TrackModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOptions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(for: MoreOptionsCell.self,
                                                       indexPath: indexPath),
              let optionData = viewModel.getOptionDisplayableContent(for: indexPath) else { return UITableViewCell() }
        cell.configureMoreOptions(title: optionData.optionTitle, icon: optionData.optionIcon)
        cell.accessibilityIdentifier = "moreOptionsCell_\(indexPath.row)"
        return cell
    }
}

extension TrackModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapOption(for: indexPath)
    }
}
