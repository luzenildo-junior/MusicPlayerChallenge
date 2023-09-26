//
//  PlayerButtonsView.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 24/09/23.
//

import Foundation
import UIKit

final class PlayerButtonsView: UIView {
    var viewAction: ((Action) -> ())?

    private lazy var previousSongButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "backward-icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        button.tag = 2
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play-icon"), for: .normal)
        button.backgroundColor = .white
        button.tag = 0
        button.layer.cornerRadius = 32.0
        button.imageEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextSongButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward-icon"), for: .normal)
        button.tag = 1
        button.imageEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [previousSongButton, playButton, nextSongButton].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // Play Button
            playButton.topAnchor.constraint(equalTo: topAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 64.0),
            playButton.heightAnchor.constraint(equalToConstant: 64.0),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Previous Song Button
            previousSongButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -20.0),
            previousSongButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            previousSongButton.widthAnchor.constraint(equalToConstant: 48.0),
            previousSongButton.heightAnchor.constraint(equalToConstant: 48.0),
            
            // Next Song Button
            nextSongButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 20.0),
            nextSongButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            nextSongButton.widthAnchor.constraint(equalToConstant: 48.0),
            nextSongButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
    }
    
    @objc func didTapButton(sender: UIButton!) {
        guard let tappedButtonAction = Action(rawValue: sender.tag) else { return }
        viewAction?(tappedButtonAction)
    }
    
    func configureButtonsView(canPlayPreviousSong: Bool,
                              canPlayNextSong: Bool) {
        previousSongButton.isEnabled = canPlayPreviousSong
        nextSongButton.isEnabled = canPlayNextSong
    }
}

extension PlayerButtonsView {
    enum Action: Int {
        case didTapPlayButton
        case didTapNextSongButton
        case didTapPreviousSongButton
    }
}
