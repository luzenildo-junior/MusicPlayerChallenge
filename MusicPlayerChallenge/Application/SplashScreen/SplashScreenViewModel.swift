//
//  SplashScreenViewModel.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 22/09/23.
//

import Combine
import Foundation

final class SplashScreenViewModel {
    @Published var dismissSplash = false
    let affineTransformationScale = 0.2
    
    func dismissSplashAfter(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.dismissSplash = true
        }
    }
}
