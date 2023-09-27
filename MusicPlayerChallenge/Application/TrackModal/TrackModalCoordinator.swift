//
//  TrackModalCoordinator.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 26/09/23.
//

import Foundation
import UIKit

final class TrackModalCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(trackDetails: ItunesSearchObject) {
        let trackModalVM = TrackModalViewModel(
            trackDetails: trackDetails
        ) { action in
            switch action {
            case .navigateToAlbumScreen(let albumId):
                self.openAlbumScreen(albumId: albumId)
            }
        }
        let trackModalVC = TrackModalViewController(viewModel: trackModalVM)
        let trackModalNav = UINavigationController(rootViewController: trackModalVC)
        trackModalNav.modalPresentationStyle = .pageSheet
        if let sheet = trackModalNav.sheetPresentationController {
            // I'm using Xcode 13.4.1 so I don't have the .custom detent style here :/
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(trackModalNav, animated: true, completion: nil)
    }
    
    private func openAlbumScreen(albumId: Int64) {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let albumCoordinator = AlbumScreenCoordinator(navigationController: self.navigationController)
            albumCoordinator.start(albumId: albumId)
            self.childCoordinators.append(albumCoordinator)
        }
    }
}
