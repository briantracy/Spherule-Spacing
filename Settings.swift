//
//  Constants.swift
//  spherule-spacing
//
//  Created by Brian Tracy on 8/6/18.
//  Copyright © 2018 Brian Tracy. All rights reserved.
//

/*
 Most of the application does not know that these can be injected
 by the user.
*/

import Foundation
import UIKit

struct Settings {
    
    static var numberOfBalls = Setting("numberOfBalls", initialValue: 2, description: "The number of balls that are required to be thrown before the timer starts. Set this to 0 to throw as many balls as you like.")
    static var ballRadius = Setting("ballRadius", initialValue: CGFloat(15.0), description: "The radius, in points, of the balls that are thrown. This is some more text to wrap lines.")
    static var ballVelocity = Setting("ballVelocity", initialValue: CGFloat(200), description: "sdf")
    static var tailMarkerRadius = Setting("tailMarkerRadius", initialValue: CGFloat(2), description: "sdf")
    static var tipMarkerRadius = Setting("tipMarkerRadius", initialValue: CGFloat(15.0), description: "sdf")
     
    static var hideStatusBar = Setting("hideStatusBar", initialValue: true, description: "asdf")
    
    static var firstCollisionEndsRound = Setting("firstCollisionEndsRound", initialValue: true, description: "sdf")
    static var nthCollisionEndsRound = Setting("nthCollisionEndsRound", initialValue: -1, description: "sdf")
    static var timeSlowdownFactorWhenThrowing = Setting("timeSlowdownFactorWhenThrowing", initialValue: CGFloat(10), description: "sdf")
    static var timeSlowdownFactorAfterCollision = Setting("timeSlowdownFactorAfterCollision", initialValue: CGFloat(10), description: "sdf")
    
    static var numberOfObstacles = Setting("numberOfObstacles", initialValue: 5, description: "The number of obstacles that are placed each game.")
    static var obstacleMinWidth = Setting("obstacleMinWidth", initialValue: 60, description: "The minimum width of the obstacles.")
    static var obstacleMaxWidth = Setting("obstacleMaxWidth", initialValue: 80, description: "The maximum width of the obstacles.")
    static var obstacleMinHeight = Setting("obstacleMinHeight", initialValue: 60, description: "The minimum height of the obstacles.")
    static var obstacleMaxHeight = Setting("obstacleMaxHeight", initialValue: 80, description: "The maximum height of the obstacles.")
    
    static var colorScheme = Setting("colorScheme", initialValue: ColorSchemes.retroCRT, description: "The colorscheme used by the entire application. Current options are: retroCRT")
    
}

enum UserDefaultsKey: String {
    case scoresDictionaryKey
}

class Setting<T> {

    public let initialValue: T
    public let description: String
    public let name: String

    init(_ name: String, initialValue: T, description: String) {
        self.initialValue =  initialValue
        self.description = description
        self.name = name
        
        if let data = UserDefaults.standard.data(forKey: self.name) {
            value = NSKeyedUnarchiver.unarchiveObject(with: data) as! T
        } else {
            value = initialValue
        }
    }

    var value: T {
        didSet {
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            UserDefaults.standard.set(data, forKey: name)
        }
    }
    
    /// Attempts to parse a value from a string.
    /// - Returns: true iff the parsing is successful
    public func parseValue(from str: String) -> Bool {
        if T.self is CGFloat.Type {
            if let f = Float(str) {
                self.value = CGFloat(f) as! T
                return true
            }
        }
        
        if T.self is Bool.Type {
            if let b = Bool(str) {
                self.value = b as! T
                return true
            }
        }
        
        if T.self is Int.Type {
            if let n = Int(str) {
                self.value = n as! T
                return true
            }
        }
        return false
    }
}


struct HighScores {
    
    public typealias ScoreFormat = [Int: Float]
    
    static func getHighScores() -> ScoreFormat {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.scoresDictionaryKey.rawValue),
           let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? ScoreFormat {
                return dict
        } else {
            return ScoreFormat()
        }
    }
    
    static func setHighScores(_ scores: ScoreFormat) {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: scores),
                                  forKey: UserDefaultsKey.scoresDictionaryKey.rawValue)
    }
}









