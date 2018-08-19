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
        
        self.view = scrollView
    }
    
    override func viewDidLoad() {
        addBackButton()
        addTitle()
        addSettingView(forSetting: Settings.ballRadius)
        addSettingView(forSetting: Settings.numberOfBalls)
        addSettingView(forSetting: Settings.numberOfObstacles)
        addSettingView(forSetting: Settings.ballVelocity)
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
        (self.view as! UIScrollView).contentSize = {
            var rect = CGRect.zero
            for v in self.view.subviews {
                rect = rect.union(v.frame)
            }
            return CGSize(width: rect.size.width, height: rect.size.height + 20)
        }()
    }
    
    private func addSettingView<T>(forSetting setting: Setting<T>) {
        let settingView = SettingView<T>()
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
        title.attributedText = NSAttributedString(string: "Settings", attributes:
            [.font: UIFont.boldSystemFont(ofSize: 30),
             .foregroundColor: Settings.colorScheme.value.textColor])
        
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
        back.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    }
    
    @objc private func backClicked() {
        dismiss(animated: false, completion: nil)
    }
}

class SettingView<T>: UIView, UITextFieldDelegate {
    let descriptionLabel = UILabel()
    let inputField = UITextField()
    let resetButton = UIButton(type: UIButtonType.roundedRect)
    
    var setting: Setting<T>!
    
    func configure(with setting: Setting<T>) {
        self.setting = setting
        preventExtraConstraints()
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "\(setting.name): ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: Settings.colorScheme.value.textColor]))
        text.append(NSAttributedString(string: setting.description, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), .foregroundColor: Settings.colorScheme.value.textColor]))
        
        
        descriptionLabel.attributedText = text
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.numberOfLines = 0
        
        inputField.textColor = Settings.colorScheme.value.textColor
        inputField.text = "\(setting.value)"
        
        inputField.isEnabled = true
        inputField.borderStyle = .bezel
        //inputField.backgroundColor = .red
        inputField.allowsEditingTextAttributes = true
        inputField.delegate = self
        resetButton.setAttributedTitle(NSAttributedString(string: "Reset", attributes: [.foregroundColor: Settings.colorScheme.value.textColor]), for: .normal)
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.green.cgColor
        resetButton.layer.cornerRadius = 5
        resetButton.isEnabled = true
        resetButton.addTarget(self, action: #selector(resetClicked), for: .touchUpInside)
        backgroundColor = .clear
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
    
    @objc private func resetClicked() {
        inputField.text = "\(setting.initialValue)"
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func preventExtraConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inputField.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let str = textField.text {
            if setting.parseValue(from: str) {
                print("set successful")
            }
            else {
                print("not successful")
                textField.text = "\(setting.initialValue)"
            }
        }
    }
}
