//
//  GameViewController.swift
//  spherule-spacing
//
//  Created by Brian Tracy on 8/6/18.
//  Copyright © 2018 Brian Tracy. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    let spriteView = SKView(frame: UIScreen.main.bounds)
    let gameScene = GameScene(size: UIScreen.size)
    
    override func viewDidLoad() {
        view.backgroundColor = .cyan
        spriteView.backgroundColor = .red
        view.addSubview(spriteView)
        
        spriteView.presentScene(gameScene)
        spriteView.showsFPS = true
        //spriteView.showsFields = true
        //spriteView.showsPhysics = true
        spriteView.showsNodeCount = true
    }    
}
