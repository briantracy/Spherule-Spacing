//
//  Math.swift
//  spherule-spacing
//
//  Created by Brian Tracy on 8/6/18.
//  Copyright © 2018 Brian Tracy. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    static func -(a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
}

func distance(from: CGPoint, to: CGPoint) -> CGFloat {
    let delta = to - from
    // yeet typecasting in swift
    return CGFloat(sqrtf(Float(delta.x * delta.x + delta.y * delta.y)))
}

extension CGVector {
    
    static func *(vector: CGVector, constant: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * constant, dy: vector.dy * constant)
    }
    
    func magnitude() -> CGFloat {
        return CGFloat(dx * dx + dy * dy).squareRoot()
    }
    
    func norm() -> CGVector {
        return self * (1.0 / magnitude())
    }
    
    func fixLength(to len: CGFloat) -> CGVector {
        return self.norm() * len
    }
}

/// inclusive range [lower, upper]
func randInRange(_ lower: Int, _ upper: Int) -> Int {
    assert(upper >= lower)
    let r = Int(arc4random_uniform(UInt32(upper - lower + 1)))
    return lower + r
}

extension UIScreen {
    static let size = UIScreen.main.bounds.size
    static let width = size.width
    static let height = size.height
    static let center = CGPoint(x: width / 2.0, y: height / 2.0)
}
