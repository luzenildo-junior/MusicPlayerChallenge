//
//  UINavigationControllerMock.swift
//  MusicPlayerChallengeTests
//
//  Created by Luzenildo Junior on 26/09/23.
//

import UIKit

final class UINavigationControllerMock: UINavigationController {
    var didTriedToPushViewController = false
    var didPresentViewController = false
    
    var pushedViewController: UIViewController?
    var mockPresentedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        didTriedToPushViewController = true
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        didPresentViewController = true
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        didPresentViewController = true
        mockPresentedViewController = viewControllerToPresent
    }
}
