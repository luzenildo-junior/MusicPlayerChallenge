//
//  TimeInterval+Extension.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 25/09/23.
//

import Foundation

extension Int32 {
    func timeIntervalInMiliseconds() -> TimeInterval? {
        TimeInterval("\(self/1000)")
    }
}

extension TimeInterval {
    var minuteSecond: String {
        String(format:"%d:%02d", minute, second)
    }
    
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
}
