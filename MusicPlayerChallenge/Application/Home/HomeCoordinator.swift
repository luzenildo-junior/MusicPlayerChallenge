//
//  HomeCoordinator.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 23/09/23.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVM = HomeViewModel { action in
            switch action {
            case .navigateToPlayer:
                self.navigateToPlayerView()
            }
        }
        let homeVC = HomeViewController(viewModel: homeVM)
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    private func navigateToPlayerView() {
        let playerCoordinator = PlayerCoordinator(navigationController: navigationController)
        playerCoordinator.start()
        childCoordinators.append(playerCoordinator)
    }
}
