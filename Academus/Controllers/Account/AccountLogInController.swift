//
//  LogInController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class AccountLogInController: UIViewController, logInErrorDelegate {
    
    private let authService = AuthService()
    var logInError: String = "Check your internet connection and try again."
    let welcomeLabel: UILabel = UILabel()
    let emailField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    let logInButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .tableViewDarkGrey
        
        welcomeLabel.setUpLabel(text: "Welcome Back.", font: UIFont.UIHeader!, fontColor: .navigationsWhite)
        emailField.setupTextField(bgColor: UIColor.tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "Email", isLeftImage: true, leftImage: #imageLiteral(resourceName: "email"), isSecure: false)
        passwordField.setupTextField(bgColor: UIColor.tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "Password", isLeftImage: true, leftImage: #imageLiteral(resourceName: "lock"), isSecure: true)
        logInButton.setUpButton(bgColor: .none, text: "LOG IN", font: UIFont.UIStandard!, color: .navigationsGreen, state: .normal)
        logInButton.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, emailField, passwordField, logInButton])
        view.addSubviews(views: [stackView, welcomeLabel, emailField, passwordField, logInButton])
    
        stackView.axis = .vertical
        stackView.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, centerY: view.centerYAnchor,width: 0, height: 350)
        welcomeLabel.anchors(top: stackView.topAnchor, centerX: stackView.centerXAnchor ,width: 0, height: 0)
        emailField.anchors(top: welcomeLabel.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        passwordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        logInButton.anchors(top: passwordField.bottomAnchor,topPad: 64, centerX: stackView.centerXAnchor, width: 64, height: 0)
    }
    
    @objc func logInPressed() {
        if (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            alertMessage(title: "Alert", message: "There is a missing field.")
            return
        } else {
            authService.logInErrorDelegate = self
            loadingAlert(title: "Attempting to log in", message: "Please wait...")
            authService.logInUser(email: emailField.text!, password: passwordField.text!)
            { (success) in
                if success {
                    self.dismiss(animated: true, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    self.dismiss(animated: true, completion: {
                        self.alertMessage(title: "Ooops.", message: self.logInError)
                    })
                }
            }
        }
    }
}
