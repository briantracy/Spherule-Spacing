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

struct SceneDismissal {
    static let dismissSceneNotificationName = Notification.Name("__dismissScene")
}

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissScene), name: SceneDismissal.dismissSceneNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func dismissScene() {
        dismiss(animated: false, completion: nil)
    }
}
