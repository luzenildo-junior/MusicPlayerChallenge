//
//  BaseViewController.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 22/09/23.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setBackButton()
    }
    
    func setBackButton(){
        let buttonForBack = UIButton(type: .custom)
        let image = UIImage(named: "back-icon")
        
        buttonForBack.setImage(image, for: .normal)
        buttonForBack.imageView?.tintColor = UIColor.white
        buttonForBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonForBack.addTarget(
            self,
            action: #selector(BaseViewController.closeViewController),
            for: .touchUpInside
        )
        
        let barButtonItemForClose = UIBarButtonItem(customView: buttonForBack)
        if navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationItem.setLeftBarButton(barButtonItemForClose, animated: false)
        }
    }

    @objc func closeViewController() {
        self == self.navigationController?.children.first ? {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }() : {
            self.navigationController?.popViewController(animated: true)
        }()
    }
    
    private lazy var loadingScreen: UIView = {
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(spinner)
        loadingView.backgroundColor = AppColors.defaultBackgroundColor
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        return loadingView
    }()
    
    private func setupLoadingScreen() {
        view.addSubview(loadingScreen)
        NSLayoutConstraint.activate([
            loadingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            loadingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func startLoading() {
        setupLoadingScreen()
    }
    
    func stopLoading() {
        loadingScreen.removeFromSuperview()
    }
}

private extension BaseViewController {
    func setupBackgroundColor() {
        view.backgroundColor = AppColors.defaultBackgroundColor
    }
}
