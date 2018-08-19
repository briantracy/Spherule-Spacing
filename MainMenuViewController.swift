//
//  MainMenuViewController.swift
//  spherule-spacing
//
//  Created by Brian Tracy on 8/6/18.
//  Copyright © 2018 Brian Tracy. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = Settings.colorScheme.value.mainMenuBackgroundColor
        setupButtons()
    }
    
    private func setupButtons() {
        let playButton = UIButton(type: .roundedRect)
        playButton.configureAsMainMenuButton(title: "Play", target: self, action: #selector(playClicked))
        playButton.center = CGPoint(x: UIScreen.width / 2.0, y: UIScreen.height / 3.0)
        view.addSubview(playButton)

        let settingsButton = UIButton(type: .roundedRect)
        settingsButton.configureAsMainMenuButton(title: "Settings", target: self, action: #selector(settingsClicked))
        settingsButton.center = CGPoint(x: UIScreen.width / 2.0, y: UIScreen.height * 2.0 / 3.0)
        view.addSubview(settingsButton)
    }
    
    @objc func playClicked() {
        //view.backgroundColor = .blue
        present(GameViewController(), animated: false, completion: nil)
    }
    
    @objc func settingsClicked() {
        present(SettingsViewController(), animated: false, completion: nil)
    }
    
}

extension UIButton {
    func configureAsMainMenuButton(title: String, target: Any, action: Selector) {
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 40)
        sizeToFit()
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
