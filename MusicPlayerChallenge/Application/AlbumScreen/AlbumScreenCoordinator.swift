//
//  AlbumScreenCoordinator.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 25/09/23.
//

import Foundation
import UIKit

final class AlbumScreenCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @available(*, deprecated, message: "Please use start(albumId)")
    func start() { }
    
    func start(albumId: Int64) {
        let albumScreenVM = AlbumScreenViewModel(albumId: albumId)
        let albumScreenVC = AlbumScreenViewController(viewModel: albumScreenVM)
        let albumScreenModalNav = UINavigationController(rootViewController: albumScreenVC)
        albumScreenModalNav.modalPresentationStyle = .pageSheet
        if let sheet = albumScreenModalNav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(albumScreenModalNav, animated: true, completion: nil)
    }
}
