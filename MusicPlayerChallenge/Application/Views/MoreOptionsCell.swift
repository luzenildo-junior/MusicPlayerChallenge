//
//  MoreOptionsCell.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Foundation
import UIKit

struct MoreOptionsDisplayableContent {
    let optionTitle: String
    let optionIcon: UIImage?
}

final class MoreOptionsCell: UITableViewCell {
    private lazy var optionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionIcon: UIImageView = {
        let imageView = UIImageView()
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
            
            optionIcon.widthAnchor.constraint(equalToConstant: AppSizes.moreOptionsCellIconSize),
            optionIcon.heightAnchor.constraint(equalToConstant: AppSizes.moreOptionsCellIconSize),
        ])
        
        isAccessibilityElement = true
    }
    
    func configureMoreOptions(title: String, icon: UIImage?) {
        optionTitleLabel.text = title
        optionIcon.image = icon
    }
    
    private func createMainStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [optionIcon, optionTitleLabel])
        stackView.spacing = 16.0
        stackView.layoutMargins = UIEdgeInsets(top: 18.0,
                                               left: 32.0,
                                               bottom: 18.0,
                                               right: 32.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
