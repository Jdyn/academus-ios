//
//  SignUpController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class AccountCreateController: UIViewController {

    let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Let's get a few things straight."
        label.font = UIFont(name: "AvenirNext-demibold", size: 20)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let betaCodeField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Beta Code", color: .ghostText, font: UIFont.UIStandard!)
        field.keyboardType = .default
        field.autocapitalizationType = .allCharacters
        field.tintColor = .navigationsGreen
        field.textColor = .navigationsWhite
        return field
    }()
    
    let firstNameField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Beta Code", color: .ghostText, font: UIFont.UIStandard!)
        field.keyboardType = .default
        field.autocapitalizationType = .words
        field.tintColor = .navigationsGreen
        field.textColor = .navigationsWhite
        return field
    }()
    
    let lastNameField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Beta Code", color: .ghostText, font: UIFont.UIStandard!)
        field.tintColor = .navigationsGreen
        field.textColor = .navigationsWhite
        return field
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Beta Code", color: .ghostText, font: UIFont.UIStandard!)
        field.tintColor = .navigationsGreen
        field.textColor = .navigationsWhite
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Password", color: .ghostText, font: UIFont.UIStandard!)
        field.isSecureTextEntry = true
        field.tintColor = .navigationsGreen
        field.textColor = .navigationsWhite
        return field
    }()
    
    let verifyPasswordField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Verify Password", color: .ghostText, font: UIFont.UIStandard!)
        field.isSecureTextEntry = true
        field.textColor = .navigationsWhite
        return field
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-medium", size: 14)
        button.setTitleColor(.navigationsGreen, for: .normal)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tableViewGrey
        self.setUpUI()
    }
    
    @objc func signUpPressed() {
        fieldsCheck()
        
        AuthService().registerUser(betaCode: (betaCodeField.text)!, firstName: (firstNameField.text)!, lastName: (lastNameField.text)!, email: (emailField.text)!, password: (passwordField.text)!) { (success) in
            if success {
                print("registered user")
                let controller = IntegrationSelectController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                self.alertMessage(title: "Alert", message: "An Error has occured. Try Again.")
                print("register failure")
            }
        }
    }

    func fieldsCheck() {
        
        if (betaCodeField.text?.isEmpty)! ||
            (firstNameField.text?.isEmpty)! ||
            (lastNameField.text?.isEmpty)! ||
            (emailField.text?.isEmpty)! ||
            (passwordField.text?.isEmpty)! ||
            (verifyPasswordField.text?.isEmpty)! {
            
            alertMessage(title: "You didn't think I would notice?", message: "There are missing fields.")
            return
        }
        
        if ((passwordField.text! == verifyPasswordField.text!) != true) {
            alertMessage(title: "I think I just saved your life.", message: "Passwords do not match.")
            return
        }
        
        if passwordField.text!.count < 6 {
            alertMessage(title: "Bro, come on.", message: "Password much be 6 characters long.")
            return
        }
    }
    
    func setUpUI() {
        
        let stackView = UIStackView(arrangedSubviews: [
            welcomeText, betaCodeField, firstNameField, lastNameField, emailField, passwordField, verifyPasswordField, signUpButton
            ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        view.addSubview(stackView)
        view.addSubview(welcomeText)
        view.addSubview(betaCodeField)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(verifyPasswordField)
        view.addSubview(signUpButton)
        
        stackView.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 400)
        welcomeText.anchors(top: stackView.topAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        betaCodeField.anchors(top: welcomeText.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        firstNameField.anchors(top: betaCodeField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.centerXAnchor, rightPad: -6, width: 0, height: 0)
        lastNameField.anchors(top: betaCodeField.bottomAnchor, topPad: 32, left: stackView.centerXAnchor, leftPad: 6, right: stackView.rightAnchor, width: 0, height: 0)
        emailField.anchors(top: firstNameField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, width: 0, height: 0)
        passwordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.centerXAnchor, rightPad: -6, width: 0, height: 0)
        verifyPasswordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.centerXAnchor, leftPad: 6, right: stackView.rightAnchor, width: 0, height: 0)
        signUpButton.anchors(bottom: passwordField.bottomAnchor, bottomPad: 64, centerX: stackView.centerXAnchor, width: 64, height: 0)
    }
}
