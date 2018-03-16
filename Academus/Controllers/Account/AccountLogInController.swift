//
//  LogInController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData
import Locksmith

class AccountLogInController: UIViewController, logInErrorDelegate {
    let fieldImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "email")
        image.tintColor = .navigationsGreen
        return image
    }()
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setUpLabel(text: "Welcome Back.", font: UIFont.UILarge!, fontColor: .navigationsWhite)
        return label
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Email", color: .ghostText, font: UIFont.UIStandard!)
        field.leftViewMode = .always
        let image = UIImageView(image: #imageLiteral(resourceName: "email"))
        image.tintColor = .navigationsGreen
        field.leftView = image
        field.textColor = .navigationsWhite
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Password", color: .ghostText, font: UIFont.UIStandard!)
        field.leftViewMode = .always
        let image = UIImageView(image: #imageLiteral(resourceName: "lock"))
        image.tintColor = .navigationsGreen
        field.leftView = image
        field.textColor = .navigationsWhite
        field.isSecureTextEntry = true
        return field
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setUpButton(bgColor: nil, text: "LOG IN", titleFont: UIFont.UIStandard!, titleColor: .navigationsGreen, titleState: .normal)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    

    
    private let authService = AuthService()
    var fieldCheck = false
    var logInError: String = "Check your internet connection and try again."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tableViewGrey
        self.setupUI()
    }
    
    @objc func logInPressed() {
        userFieldCheck()
        if (fieldCheck) {
            logInUser()
        }
    }
    
    func userFieldCheck() {
        if (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            alertMessage(title: "Alert", message: "There is a missing field.")
            fieldCheck = false
            return
        } else {
            fieldCheck = true
        }
    }
    
    func logInUser() {
        authService.logInErrorDelegate = self
        loadingAlert(title: "Attempting to log in", message: "Please wait...")
        authService.logInUser(email: emailField.text!, password: passwordField.text!)
        { (success) in
            
            if success {
                
                self.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: {
                        
                    })
                })
                
            } else {
                self.dismiss(animated: true, completion: {
                    self.alertMessage(title: "Ooops.", message: self.logInError)
                })
            }
        }
    }
    
    func setupUI() {
        
        let stackView = UIStackView(arrangedSubviews: [
            welcomeLabel, emailField, passwordField, logInButton
            ])
        
        view.addSubview(stackView)
        view.addSubview(welcomeLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(logInButton)
        
        stackView.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, centerY: view.centerYAnchor,width: 0, height: 350)
        stackView.axis = .vertical
        
        welcomeLabel.anchors(top: stackView.topAnchor, centerX: stackView.centerXAnchor ,width: 0, height: 0)
        emailField.anchors(top: welcomeLabel.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        passwordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        logInButton.anchors(top: passwordField.bottomAnchor,topPad: 64, centerX: stackView.centerXAnchor, width: 64, height: 0)
    }
}
