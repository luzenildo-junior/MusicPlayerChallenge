//
//  PlayerViewController.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 24/09/23.
//

import Combine
import Foundation
import Kingfisher
import UIKit

struct PlayerDiplayableContent {
    let songDisplayableContent: SongDetailsDisplayableContent
    let canPlayNextSong: Bool
    let canPlayPreviousSong: Bool
    let currentSongTime: Int32
}

final class PlayerViewController: BaseViewController {
    private lazy var songName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0)
        label.textColor = .white
        label.text = "Song Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var songArtist: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = AppColors.songDetailsArtistTextColor
        label.text = "Artist"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var albumImage: UIImageView = {
        let imageView = UIImageView()
        let defaultIcon = UIImage(named: "note-icon")
        imageView.image = defaultIcon
        imageView.backgroundColor = AppColors.defaultNoteIconBackgroundColor
        imageView.layer.cornerRadius = 38.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerSeekSlider = PlayerSliderView()
    private let playerButtonsView = PlayerButtonsView()
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: PlayerViewModel
    
    // MARK: Lifecycle methods
    init(viewModel: PlayerViewModel) {
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
    
    private func setupView() {
        let topView = createTopView()
        let bottomView = createBottomView()
        createMoreButton()
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            // topView
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // botomView
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.accessibilityIdentifier = "playerView"
    }

    private func subscribeToPublishers() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { viewState in
                switch viewState {
                case .updateView(let displayableContent):
                    self.playerButtonsView.configureButtonsView(
                        canPlayPreviousSong: displayableContent.canPlayPreviousSong,
                        canPlayNextSong: displayableContent.canPlayNextSong
                    )
                    self.songName.text = displayableContent.songDisplayableContent.songName
                    self.songArtist.text = displayableContent.songDisplayableContent.songArtist
                    if let albumLink = displayableContent.songDisplayableContent.albumImageLink {
                        self.albumImage.kf.setImage(with: URL(string: albumLink))
                    }
                    self.playerSeekSlider.configurePlayerSlider(
                        totalTime: displayableContent.songDisplayableContent.songTotalTime,
                        currentTime: displayableContent.currentSongTime
                    )
                case .updateTrackTimer(let currentTrackTimeInMillis, let totalTrackTimeInMillis):
                    self.playerSeekSlider.configurePlayerSlider(
                        totalTime: totalTrackTimeInMillis,
                        currentTime: currentTrackTimeInMillis
                    )
                case .updatePlayPauseButton(let isPlaying):
                    self.playerButtonsView.updatePlayButton(isPlaying: isPlaying)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func createSongInfoStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [songName, songArtist])
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.layoutMargins = UIEdgeInsets(top: 0.0,
                                               left: 20.0,
                                               bottom: 0.0,
                                               right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createBottomView() -> UIView {
        playerSeekSlider.translatesAutoresizingMaskIntoConstraints = false
        playerButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        let songInfoStackView = createSongInfoStackView()
        [songInfoStackView, playerSeekSlider, playerButtonsView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // songInfoStackView
            songInfoStackView.topAnchor.constraint(equalTo: view.topAnchor),
            songInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // playerSeekSlider
            playerSeekSlider.topAnchor.constraint(equalTo: songInfoStackView.bottomAnchor, constant: 12.0),
            playerSeekSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerSeekSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // playerButtonsView
            playerButtonsView.topAnchor.constraint(equalTo: playerSeekSlider.bottomAnchor, constant: 12.0),
            playerButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createTopView() -> UIView {
        let view = UIView()
        view.addSubview(albumImage)
        
        NSLayoutConstraint.activate([
            // albumImage
            albumImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            albumImage.widthAnchor.constraint(equalToConstant: 200.0),
            albumImage.heightAnchor.constraint(equalToConstant: 200.0),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createMoreButton() {
        let moreButton = UIButton(type: .custom)
        let image = UIImage(named: "more-icon")
        
        moreButton.setImage(image, for: .normal)
        moreButton.imageView?.tintColor = UIColor.white
        moreButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        moreButton.addTarget(
            self,
            action: #selector(didTapMoreButton),
            for: .touchUpInside
        )
        
        moreButton.isAccessibilityElement = true
        moreButton.accessibilityIdentifier = "moreOptionsButton"
        let barButtonItem = UIBarButtonItem(customView: moreButton)
        navigationItem.rightBarButtonItems = [barButtonItem]
    }
    
    @objc private func didTapMoreButton() {
        viewModel.didTapMoreButton()
    }
}
