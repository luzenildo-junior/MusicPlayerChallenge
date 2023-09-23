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
    }
    
    func setBackButton(){
        let buttonForBack = UIButton(type: .custom)
        let image = UIImage(named: "back-button")
        
        buttonForBack.setImage(image, for: .normal)
        buttonForBack.imageView?.tintColor = UIColor.white
        buttonForBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonForBack.addTarget(
            self,
            action: #selector(BaseViewController.closeViewController),
            for: .touchUpInside
        )
        
        let barButtonItemForClose = UIBarButtonItem(customView: buttonForBack)
        self.navigationItem.setLeftBarButton(barButtonItemForClose, animated: false)
    }

    @objc func closeViewController() {
        self == self.navigationController?.children.first ? {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }() : {
            self.navigationController?.popViewController(animated: true)
        }()
    }
}

private extension BaseViewController {
    func setupBackgroundColor() {
        view.backgroundColor = AppColors.defaultBackgroundColor
    }
}
