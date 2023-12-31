//
//  PlayerCoordinator.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 24/09/23.
//

import Foundation
import UIKit

final class PlayerCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let playerVM = PlayerViewModel { action in
            switch action {
            case .openSongModal(let currentPlayingTrack):
                self.openMoreOptionsModal(currentPlayingTrack)
            }
        }
        let playerVC = PlayerViewController(viewModel: playerVM)
        navigationController.pushViewController(playerVC, animated: true)
    }
    
    private func openMoreOptionsModal(_ currentPlayingTrack: ItunesSearchObject) {
        let trackModalCoordinator = TrackModalCoordinator(navigationController: navigationController)
        trackModalCoordinator.start(trackDetails: currentPlayingTrack)
        childCoordinators.append(trackModalCoordinator)
    }
}
