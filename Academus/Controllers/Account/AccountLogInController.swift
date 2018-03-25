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
    let welcomeLabel = UILabel().setUpLabel(text: "Welcome Back..", font: UIFont.UIHeader!, fontColor: .navigationsWhite)
    let emailField = UITextField().setupTextField(bottomBorder: true, ghostText: "Email")
    let passwordField = UITextField().setupTextField(bottomBorder: true, ghostText: "Password", isSecure: true)
    let logInButton = UIButton(type: .system).setUpButton(title: "LOG IN", font: UIFont.UIStandard!, fontColor: .navigationsGreen)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, emailField, passwordField, logInButton])
        stack.axis = .vertical; stack.spacing = 32;
        view.addSubview(stack)
        view.backgroundColor = .tableViewDarkGrey
        stack.anchors(top: view.topAnchor, topPad: view.bounds.height * 1/4, left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32)
        welcomeLabel.textAlignment = .center
        logInButton.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
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
