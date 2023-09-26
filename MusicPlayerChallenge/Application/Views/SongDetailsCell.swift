//
//  SongDetailsCell.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 23/09/23.
//

import Foundation
import Kingfisher
import UIKit

struct SongDetailsDisplayableContent {
    let songName: String?
    let songArtist: String
    let albumImageLink: String?
    let songTotalTime: Int32?
}

final class SongDetailsCell: UITableViewCell {
    private lazy var songName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var songArtist: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = AppColors.songDetailsArtistTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var albumImage: UIImageView = {
        let imageView = UIImageView()
        let defaultIcon = UIImage(named: "note-icon")
        imageView.image = defaultIcon
        imageView.backgroundColor = AppColors.defaultNoteIconBackgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(codser:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let mainStackView = createMainStackView()
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            albumImage.widthAnchor.constraint(equalToConstant: AppSizes.albumImageSize),
            albumImage.heightAnchor.constraint(equalToConstant: AppSizes.albumImageSize),
        ])
        
        isAccessibilityElement = true
        accessibilityIdentifier = "songDetailsCell"
    }
    
    private func createSongInfoStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [songName, songArtist])
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createMainStackView() -> UIStackView {
        let songInfoStackView = createSongInfoStackView()
        let stackView = UIStackView(arrangedSubviews: [albumImage, songInfoStackView])
        stackView.spacing = 16.0
        stackView.layoutMargins = UIEdgeInsets(top: 8.0,
                                               left: 24.0,
                                               bottom: 8.0,
                                               right: 24.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupSongInfo(songDetails: SongDetailsDisplayableContent) {
        songName.text = songDetails.songName
        songArtist.text = songDetails.songArtist
        if let albumLink = songDetails.albumImageLink {
            albumImage.kf.setImage(
                with: URL(string: albumLink)
            )
        }
    }
}
