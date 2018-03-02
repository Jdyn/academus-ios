//
//  SignUpController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Let's get a few things straight."
        label.font = UIFont(name: "AvenirNext-demibold", size: 20)
        label.textColor = UIColor.navigationsWhite
        return label
    }()
    
    let betaCodeField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "Beta Code", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.keyboardType = .default
        field.autocapitalizationType = .allCharacters
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let firstNameField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.keyboardType = .default
        field.autocapitalizationType = .words
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let lastNameField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.isSecureTextEntry = true
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let verifyPasswordField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "Verify Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.isSecureTextEntry = true
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-medium", size: 14)
        button.setTitleColor(UIColor.navigationsGreen, for: .normal)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tableViewGrey
        self.setUpUI()
    }
    
    @objc func signUpPressed() {
        fieldsCheck()
        
        AuthService().registerUser(betaCode: (betaCodeField.text)!, firstName: (firstNameField.text)!, lastName: (lastNameField.text)!, email: (emailField.text)!, password: (passwordField.text)!) { (success) in
            if success {
                print("registered user")
                //perform segue to log in page
            } else {
                self.alertMessage(title: "Alert", message: "Maybe try a different beta code.")
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
            welcomeText, betaCodeField, firstNameField, lastNameField, emailField, passwordField, verifyPasswordField,signUpButton
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
        
        stackView.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 32, bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomPad: -32, left: view.leftAnchor, leftPad: 16, right: view.rightAnchor, rightPad: -16 ,centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 0)
        welcomeText.anchors(top: stackView.topAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        betaCodeField.anchors(top: welcomeText.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        firstNameField.anchors(top: betaCodeField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.centerXAnchor, rightPad: -6, width: 0, height: 0)
        lastNameField.anchors(top: betaCodeField.bottomAnchor, topPad: 32, left: stackView.centerXAnchor, leftPad: 6, right: stackView.rightAnchor, width: 0, height: 0)
        emailField.anchors(top: firstNameField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, width: 0, height: 0)
        passwordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.centerXAnchor, rightPad: -6, width: 0, height: 0)
        verifyPasswordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.centerXAnchor, leftPad: 6, right: stackView.rightAnchor, width: 0, height: 0)
        signUpButton.anchors(bottom: stackView.safeAreaLayoutGuide.bottomAnchor, bottomPad: 16, centerX: stackView.centerXAnchor, width: 64, height: 0)
    }
}
