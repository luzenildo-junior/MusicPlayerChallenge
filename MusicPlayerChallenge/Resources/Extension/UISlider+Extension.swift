//
//  UISlider+Extension.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 27/09/23.
//

import Foundation
import UIKit

extension UISlider {
    func setThumb(size: CGSize, backgroundColor: UIColor){
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        [.normal, .highlighted].forEach { state in
            self.setThumbImage(image, for: state)
        }
    }
}
