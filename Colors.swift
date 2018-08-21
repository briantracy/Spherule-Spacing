//
//  Colors.swift
//  spherule-spacing
//
//  Created by Brian Tracy on 8/6/18.
//  Copyright © 2018 Brian Tracy. All rights reserved.
//

import Foundation
import UIKit

// Yikes, structs cant conform to NSCoding, so this has to be a class
// which means I have to write a ridiculous init
@objc class ColorScheme: NSObject, NSCoding {
    
    @objc var name: String!
    @objc var backgroundColor: UIColor!
    @objc var ballFillColor: UIColor!
    @objc var ballStrokeColor: UIColor!
    @objc var obstacleFillColor: UIColor!
    @objc var obstacleStrokeColor: UIColor!
    @objc var startPointColor: UIColor!
    @objc var endPointColor: UIColor!
    @objc var connectingLineColor: UIColor!
    @objc var tailMarkerFillColor: UIColor!
    @objc var tailMarkerStrokeColor: UIColor!
    @objc var tipMarkerFillColor: UIColor!
    @objc var tipMarkerStrokeColor: UIColor!
    @objc var mainMenuBackgroundColor: UIColor!
    @objc var settingsMenuBackgroundColor: UIColor!
    @objc var textColor: UIColor!
    
    init(
            name: String!,
            backgroundColor: UIColor!,
            ballFillColor: UIColor!,
            ballStrokeColor: UIColor!,
            obstacleFillColor: UIColor!,
            obstacleStrokeColor: UIColor!,
            startPointColor: UIColor!,
            endPointColor: UIColor!,
            connectingLineColor: UIColor!,
            tailMarkerFillColor: UIColor!,
            tailMarkerStrokeColor: UIColor!,
            tipMarkerFillColor: UIColor!,
            tipMarkerStrokeColor: UIColor!,
            mainMenuBackgroundColor: UIColor!,
            settingsMenuBackgroundColor: UIColor!,
            textColor: UIColor!
    ) {
        self.name = name
        self.backgroundColor = backgroundColor
        self.ballFillColor = ballFillColor
        self.ballStrokeColor = ballStrokeColor
        self.obstacleFillColor = obstacleFillColor
        self.obstacleStrokeColor = obstacleStrokeColor
        self.startPointColor = startPointColor
        self.endPointColor = endPointColor
        self.connectingLineColor = connectingLineColor
        self.tailMarkerFillColor = tailMarkerFillColor
        self.tailMarkerStrokeColor = tailMarkerStrokeColor
        self.tipMarkerFillColor = tipMarkerFillColor
        self.tipMarkerStrokeColor = tipMarkerStrokeColor
        self.mainMenuBackgroundColor = mainMenuBackgroundColor
        self.settingsMenuBackgroundColor = settingsMenuBackgroundColor
        self.textColor = textColor
    }
    override init() {}
    
    func encode(with aCoder: NSCoder) {
        for child in Mirror(reflecting: self).children {
            aCoder.encode(child.value, forKey: child.label!)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        for child in Mirror(reflecting: self).children {
            let value = aDecoder.decodeObject(forKey: child.label!)
            self.setValue(value, forKey: child.label!)
        }
    }
    
    override var description: String {
        return name
    }
}

struct ColorSchemes {
//    static let plain = ColorScheme(name: "plain", backgroundColor: .white, ballFillColor: .blue,
//                                   ballStrokeColor: .red, obstacleFillColor: .yellow, obstacleStrokeColor: .brown,
//                                   startPointColor: .orange, endPointColor: .orange, connectingLineColor: .yellow,
//                                   tailMarkerFillColor: .red, tailMarkerStrokeColor: .red, tipMarkerFillColor: .red,
//                                   tipMarkerStrokeColor: .red, mainMenuBackgroundColor: .cyan)
    static let retroCRT = ColorScheme(name: "retroCRT", backgroundColor: .black, ballFillColor: .clear,
                                   ballStrokeColor: .green, obstacleFillColor: .clear, obstacleStrokeColor: .green,
                                   startPointColor: .green, endPointColor: .green, connectingLineColor: .green,
                                   tailMarkerFillColor: .green, tailMarkerStrokeColor: .green, tipMarkerFillColor: .clear,
                                   tipMarkerStrokeColor: .green, mainMenuBackgroundColor: .black, settingsMenuBackgroundColor: .black, textColor: .green)
    static let random = ColorScheme(name: "random", backgroundColor: .random(), ballFillColor: .random(), ballStrokeColor: .random(), obstacleFillColor: .random(), obstacleStrokeColor: .random(), startPointColor: .random(), endPointColor: .random(), connectingLineColor: .random(), tailMarkerFillColor: .random(), tailMarkerStrokeColor: .random(), tipMarkerFillColor: .random(), tipMarkerStrokeColor: .random(), mainMenuBackgroundColor: .random(), settingsMenuBackgroundColor: .random(), textColor: .random())
//    static let grayscale =
//                       ColorScheme(name: "grayscale", backgroundColor: "#DDDDDD".c, ballFillColor: "#777777".c,
//                                   ballStrokeColor: "#BBBBBB".c, obstacleFillColor: "#808080".c, obstacleStrokeColor: .black,
//                                   startPointColor: .green, endPointColor: .green, connectingLineColor: .green,
//                                   tailMarkerFillColor: .green, tailMarkerStrokeColor: .green, tipMarkerFillColor: .clear,
//                                   tipMarkerStrokeColor: .green, mainMenuBackgroundColor: .cyan)
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
    
    static func random() -> UIColor {
        let r = { CGFloat(arc4random()) / CGFloat(UINT32_MAX) }
        return UIColor(red: r(), green: r(), blue: r(), alpha: max(1.0, r() + r()))
    }
}

extension String {
    var c: UIColor {
        return UIColor(hex: self)
    }
}


