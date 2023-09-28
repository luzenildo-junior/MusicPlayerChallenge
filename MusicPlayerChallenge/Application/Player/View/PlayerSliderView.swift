//
//  PlayerSliderView.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 24/09/23.
//

import Foundation
import UIKit

final class PlayerSliderView: UIView {
    // MARK: UI elements
    private lazy var seekSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = AppColors.trackSliderColor
        slider.setThumb(size: CGSize(width: 12, height: 12), backgroundColor: .white)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        label.text = "0:00"
        label.textColor = AppColors.songTimeTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.text = "-3:20"
        label.textColor = AppColors.songTimeTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let mainStackView = createMainStackView()
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configurePlayerSlider(totalTime: Int32?, currentTime: Int32) {
        seekSlider.maximumValue = Float(totalTime ?? 0)
        seekSlider.value = Float(currentTime)
        let remainingTime = (totalTime ?? 0) - currentTime
        currentTimeLabel.text = currentTime.timeIntervalInMiliseconds()?.minuteSecond
        remainingTimeLabel.text = "-\(remainingTime.timeIntervalInMiliseconds()?.minuteSecond ?? "0:00")"
    }
    
    private func createMainStackView() -> UIStackView {
        let timeStackView = createTimeStackView()
        let stackView = UIStackView(arrangedSubviews: [seekSlider, timeStackView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.layoutMargins = UIEdgeInsets(top: 0.0,
                                               left: 20.0,
                                               bottom: 0.0,
                                               right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createTimeStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [currentTimeLabel, remainingTimeLabel])
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    @objc func sliderValueChanged(sender: UISlider, event: UIEvent) {
        if event.allTouches?.first?.phase == .ended {
            PlayerManager.shared.playSong()
            return
        }
        let newCurrentTime = Int32(sender.value)
        PlayerManager.shared.setTrackTime(newValue: newCurrentTime)
     }
}
