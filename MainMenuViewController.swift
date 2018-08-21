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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
    }
    
    private func setupButtons() {
        let playButton = addButton(title: "Play", action: #selector(playClicked))
        let settingsButton = addButton(title: "Settings", action: #selector(settingsClicked))
        let scoresButton = addButton(title: "Scores", action: #selector(scoresClicked))

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: settingsButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scoresButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: settingsButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scoresButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.5, constant: 0),

        ])
    }
    
    private func addButton(title: String, action: Selector) -> UIView {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: title, attributes:
            [.font: UIFont.boldSystemFont(ofSize: 40),
             .foregroundColor: Settings.colorScheme.value.textColor]), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    @objc func playClicked() {
        //view.backgroundColor = .blue
        present(GameViewController(), animated: false, completion: nil)
    }
    
    @objc func settingsClicked() {
        present(SettingsViewController(), animated: false, completion: nil)
    }
    
    @objc func scoresClicked() {
        
    }
}

