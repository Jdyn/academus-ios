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
    var mainController: MainController?
    
    var logInError = "Check your internet connection and try again."
    var apnsToken: String?
    var impact = UIImpactFeedbackGenerator()
    
    let welcomeLabel = UILabel().setUpLabel(text: "Welcome Back", font: UIFont.header!, fontColor: .navigationsWhite)
    let emailField = UITextField().setupTextField(bottomBorder: true, ghostText: "Email")
    let passwordField = UITextField().setupTextField(bottomBorder: true, ghostText: "Password", isSecure: true)
    let logInButton = UIButton().setUpButton(title: "LOG IN", font: UIFont.standard!, fontColor: .navigationsGreen)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setupUI()
    }
    
    func setupUI() {
        
        view.backgroundColor = .tableViewDarkGrey
        
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none

        let screen = UIScreen.main.bounds
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
        
        scrollView.contentSize = CGSize(width: screen.width, height: screen.height + 100)
        scrollView.addSubviews(views: [emailField, passwordField, logInButton, welcomeLabel])
        view.addSubview(scrollView)
        
        emailField.adjustsFontForContentSizeCategory = true
        
        welcomeLabel.textAlignment = .center
        welcomeLabel.anchors(top: scrollView.topAnchor, topPad: scrollView.bounds.height * 1/4, centerX: scrollView.centerXAnchor)
        emailField.anchors(top: welcomeLabel.bottomAnchor, topPad: 32, centerX: scrollView.centerXAnchor, width: screen.width - 64, height: fieldHeight)
        passwordField.anchors(top: emailField.bottomAnchor, topPad: 16, centerX: scrollView.centerXAnchor, width: screen.width - 64, height: fieldHeight)
        logInButton.anchors(top: passwordField.bottomAnchor, topPad: 32, centerX: scrollView.centerXAnchor, width: 150)
        
        logInButton.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
    }
    
    @objc func logInPressed() {
        self.passwordField.resignFirstResponder()
        impact.impactOccurred()

        if (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            alertMessage(title: "Alert", message: "There is a missing field.")
            return
        }
        
        authService.logInErrorDelegate = self
        loadingAlert(title: "Attempting to log in", message: "Please wait...")
        
        authService.logInUser(email: emailField.text!, password: passwordField.text!, appleToken: mainController?.apnsToken)
        { (success) in
            if success {
                self.dismiss(animated: true, completion: { self.dismiss(animated: true, completion: nil) })
            } else {
                self.dismiss(animated: true, completion: { self.alertMessage(title: "Ooops.", message: self.logInError) })
            }
        }
    }
}
