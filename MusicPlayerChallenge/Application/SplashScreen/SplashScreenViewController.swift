//
//  SplashScreenViewController.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 22/09/23.
//

import Combine
import UIKit

final class SplashScreenViewController: BaseViewController {
    // MARK: View Elements
    lazy var appLogo: UIImageView = {
        let logo = UIImage(named: "app-logo")
        return UIImageView(image: logo)
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: SplashScreenViewModel
    
    // MARK: Lifecycle methods
    init(viewModel: SplashScreenViewModel) {
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
        viewModel.dismissSplashAfter(seconds: 3.0)
    }
    
    // MARK: Private Methods
    private func setupView() {
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.addSublayer(createGradientBackground())
        view.addSubview(appLogo)
        
        NSLayoutConstraint.activate([
            appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appLogo.widthAnchor.constraint(equalToConstant: AppSizes.splashScreenImageSize),
            appLogo.heightAnchor.constraint(equalToConstant: AppSizes.splashScreenImageSize)
        ])
        
        view.accessibilityIdentifier = "splash-view"
        appLogo.accessibilityIdentifier = "splash-logo"
    }
    
    private func subscribeToPublishers() {
        viewModel.$dismissSplash
            .sink { [weak self] shouldDismiss in
                if shouldDismiss {
                    self?.animatedDismiss()
                }
            }
            .store(in: &cancellables)
    }
    
    private func animatedDismiss() {
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       options: .curveEaseInOut) {
            self.appLogo.transform = CGAffineTransform(
                scaleX: self.viewModel.affineTransformationScale,
                y: self.viewModel.affineTransformationScale
            )
            self.view.alpha = 0.0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // This piece of code was provided by Figma.
    private func createGradientBackground() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0.109, green: 0.187, blue: 0.279, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.49, 1]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(
                a: 0.86,
                b: -1.19,
                c: 1.19,
                d: 0.86,
                tx: -0.53,
                ty: 0.73
            )
        )
        gradientLayer.bounds = view.bounds.insetBy(
            dx: -0.5*view.bounds.size.width,
            dy: -0.5*view.bounds.size.height
        )
        gradientLayer.position = view.center
        return gradientLayer
    }
}
