//
//  CoordinatorProtocol.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 22/09/23.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    init(navigationController: UINavigationController)
    func start()
}
