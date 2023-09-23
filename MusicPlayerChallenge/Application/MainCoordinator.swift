//
//  MainCoordinator.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 22/09/23.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHomeView()
        showSplashScreen()
    }
    
    private func showSplashScreen() {
        let splashScreenVM = SplashScreenViewModel()
        let splashScreenVC = SplashScreenViewController(viewModel: splashScreenVM)
        splashScreenVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(splashScreenVC, animated: false)
    }
    
    private func showHomeView() {
        let someView = UIViewController()
        someView.view.backgroundColor = .white
        navigationController.pushViewController(someView, animated: false)
    }
}
