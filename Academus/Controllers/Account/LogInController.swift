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
    
    let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back."
        label.font = UIFont(name: "AvenirNext-medium", size: 24)
        label.textColor = UIColor.navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let passwordTextField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ghostText])
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-medium", size: 14)
        button.setTitleColor(UIColor.navigationsGreen, for: .normal)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            alertMessage(title: "Alert", message: "There is a missing field.")
            fieldCheck = false
            return
        } else {
            fieldCheck = true
        }
    }
    
    func logInUser() {
        AuthService().logInUser(email: emailTextField.text!, password: passwordTextField.text!)
        { (success) in
            if success {
                self.present(MainTabBarController(), animated: true, completion: nil)
                print("LogInVC: User Log in successful")
            } else {
                self.alertMessage(title: "Alert", message: "Wrong username or password.")
                print("LogInVC: User Log in failure")
            }
        }
    }
    
    
    
    func setupUI() {
        
        let centralUIStackView = UIStackView(arrangedSubviews: [
            welcomeText, emailTextField, passwordTextField, logInButton
            ])
        
        centralUIStackView.translatesAutoresizingMaskIntoConstraints = false
        centralUIStackView.axis = .vertical
        centralUIStackView.distribution = .fillEqually
        centralUIStackView.alignment = .center
        
        view.addSubview(centralUIStackView)
        view.addSubview(welcomeText)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        
        NSLayoutConstraint.activate([
            
            centralUIStackView.heightAnchor.constraint(equalToConstant: 300),
            centralUIStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            centralUIStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            centralUIStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centralUIStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            welcomeText.topAnchor.constraint(equalTo: centralUIStackView.topAnchor),
            welcomeText.centerXAnchor.constraint(equalTo: centralUIStackView.centerXAnchor),
            
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            emailTextField.heightAnchor.constraint(equalToConstant: 32),
            emailTextField.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 16),
            emailTextField.centerXAnchor.constraint(equalTo: centralUIStackView.centerXAnchor),
            
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 32),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.centerXAnchor.constraint(equalTo: centralUIStackView.centerXAnchor),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            logInButton.centerXAnchor.constraint(equalTo: centralUIStackView.centerXAnchor),
            
            ])
    }
}
