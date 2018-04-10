//
//  LogInController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class AccountLogInController: UIViewController, logInErrorDelegate, UITextFieldDelegate {
    
    private let authService = AuthService()
    
    var scrollView: UIScrollView?
    var stack: UIStackView?
    var logInError = "Check your internet connection and try again."
    
    let welcomeLabel = UILabel().setUpLabel(text: "Welcome Back", font: UIFont.UIHeader!, fontColor: .navigationsWhite)
    let emailField = UITextField().setupTextField(bottomBorder: true, ghostText: "Email")
    let passwordField = UITextField().setupTextField(bottomBorder: true, ghostText: "Password", isSecure: true)
    let logInButton = UIButton(type: .system).setUpButton(title: "LOG IN", font: UIFont.UIStandard!, fontColor: .navigationsGreen)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        setupUI()
    }
    
    func setupUI() {
        
        stack = UIStackView(arrangedSubviews: [welcomeLabel, emailField, passwordField, logInButton])
        stack!.axis = .vertical
        stack!.spacing = 32
        
        let screen = UIScreen.main.bounds
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
        scrollView!.contentSize = CGSize(width: screen.width, height: screen.height + 100)
        scrollView!.addSubview(stack!)
        view.addSubview(scrollView!)
        
        stack!.anchors(top: scrollView!.topAnchor, topPad: view.bounds.height * 1/4, left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32)
        welcomeLabel.textAlignment = .center
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
