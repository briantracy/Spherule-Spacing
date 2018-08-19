//
//  SettingsViewController.swift
//  spherule-spacing
//
//  Created by Brian Tracy on 8/11/18.
//  Copyright © 2018 Brian Tracy. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    var lastView: UIView?
    
    override func loadView() {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.backgroundColor = Settings.colorScheme.value.settingsMenuBackgroundColor
        Settings.colorScheme.onChange { (newScheme) in
            scrollView.backgroundColor = newScheme.settingsMenuBackgroundColor
        }
        //scrollView.contentSize = CGSize(width: UIScreen.width, height: UIScreen.height)
//        scrollView.isScrollEnabled = true
        //scrollView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        self.view = scrollView
    }
    
    override func viewDidLoad() {
        addBackButton()
        addTitle()
        addSettingView(forSetting: Settings.ballRadius)
        addSettingView(forSetting: Settings.numberOfBalls)
        addSettingView(forSetting: Settings.numberOfObstacles)
        addSettingView(forSetting: Settings.nthCollisionEndsRound)
        addSettingView(forSetting: Settings.ballVelocity)
        addSettingView(forSetting: Settings.ballRadius)
        addSettingView(forSetting: Settings.numberOfBalls)
        addSettingView(forSetting: Settings.numberOfObstacles)
        addSettingView(forSetting: Settings.nthCollisionEndsRound)
        addSettingView(forSetting: Settings.ballVelocity)
        addSettingView(forSetting: Settings.numberOfObstacles)
        addSettingView(forSetting: Settings.numberOfObstacles)
        addSettingView(forSetting: Settings.numberOfObstacles)
        addSettingView(forSetting: Settings.numberOfObstacles)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    private func addSettingView<T>(forSetting setting: Setting<T>) {
        let settingView = SettingView()
        settingView.translatesAutoresizingMaskIntoConstraints = false
        settingView.backgroundColor = .red
        settingView.configure(with: setting)
        view.addSubview(settingView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: settingView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: settingView, attribute: .top, relatedBy: .equal, toItem: lastView, attribute: .bottom, multiplier: 1, constant: 15)
        ])
        lastView = settingView
    }
    
    private func addTitle() {
        let title = UILabel()
        title.text = NSLocalizedString("Settings", comment: "")
        title.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        
        lastView = title
    }
    
    private func addBackButton() {
        let back = UIButton(type: .system)
        back.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        back.titleLabel?.textColor = .orange
        view.addSubview(back)
        back.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: back, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: back, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10)
        ])
    }
}

class SettingView: UIView, UITextFieldDelegate {
    let descriptionLabel = UILabel()
    let inputField = UITextField()
    let resetButton = UIButton(type: UIButtonType.roundedRect)
    
    func configure<T>(with setting: Setting<T>) {
        self.backgroundColor = .lightGray
        preventExtraConstraints()
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "\(setting.name): ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]))
        text.append(NSAttributedString(string: setting.description, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
        
        
        descriptionLabel.attributedText = text
        descriptionLabel.backgroundColor = .orange
        descriptionLabel.numberOfLines = 0
        
        inputField.text = "\(setting.initialValue)"
        inputField.isEnabled = true
        inputField.borderStyle = .bezel
        //inputField.backgroundColor = .red
        inputField.allowsEditingTextAttributes = true
        inputField.delegate = self
        resetButton.setTitle("asdf", for: .normal)
        resetButton.isEnabled = true
        backgroundColor = .lightGray
        addSubview(descriptionLabel)
        addSubview(inputField)
        addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: descriptionLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: inputField, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: inputField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0/3.0, constant: 0),
            NSLayoutConstraint(item: resetButton, attribute: .leading, relatedBy: .equal, toItem: inputField, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: resetButton, attribute: .centerY, relatedBy: .equal, toItem: inputField, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: inputField, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        //inputField.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool  {
        return true
    }
    
    private func preventExtraConstraints() {
        //self.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inputField.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    

}
