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

class LogInController: UIViewController {

    var fieldCheck = false
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back."
        label.font = UIFont(name: "AvenirNext-medium", size: 24)
        label.textColor = UIColor.navigationsWhite
        return label
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
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        field.isSecureTextEntry = true
        return field
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-medium", size: 14)
        button.setTitleColor(UIColor.navigationsGreen, for: .normal)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tableViewGrey
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
        AuthService().logInUser(email: emailField.text!, password: passwordField.text!)
        { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.alertMessage(title: "Alert", message: "Wrong username or password.")
            }
            CourseService().getCourses(completion: { (success) in
                print("idk")
            })
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
        
        stackView.anchors(left: view.leftAnchor, leftPad: 16, right: view.rightAnchor, rightPad: -16, centerX: view.centerXAnchor, centerY: view.centerYAnchor,width: 0, height: 350)
        stackView.axis = .vertical
        
        welcomeLabel.anchors(top: stackView.topAnchor, centerX: stackView.centerXAnchor ,width: 0, height: 0)
        emailField.anchors(top: welcomeLabel.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        passwordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        logInButton.anchors(top: passwordField.bottomAnchor,topPad: 64, centerX: stackView.centerXAnchor, width: 64, height: 0)
    }
}
