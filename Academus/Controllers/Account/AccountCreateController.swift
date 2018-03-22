//
//  SignUpController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class AccountCreateController: UIViewController {

    let welcomeLabel: UILabel = UILabel().setUpLabel(text: "Welcome Back", font: UIFont.UIHeader!, fontColor: .navigationsWhite)
    let betaCodeField: UITextField = UITextField().setupTextField(bgColor: .tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "Beta Code", isLeftImage: false, leftImage: .none, isSecure: false)
    let firstNameField: UITextField = UITextField().setupTextField(bgColor: .tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "First Name", isLeftImage: false, leftImage: .none, isSecure: false)
    let lastNameField: UITextField = UITextField().setupTextField(bgColor: .tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "Last Name", isLeftImage: false, leftImage: .none, isSecure: false)
    let emailField: UITextField = UITextField().setupTextField(bgColor: .tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "Email", isLeftImage: false, leftImage: .none, isSecure: false)
    let passwordField: UITextField = UITextField().setupTextField(bgColor: .tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "Password", isLeftImage: false, leftImage: .none, isSecure: true)
    let verifyPasswordField: UITextField = UITextField().setupTextField(bgColor: .tableViewDarkGrey, isBottomBorder: true, isGhostText: true, ghostText: "Verify Password", isLeftImage: false, leftImage: .none, isSecure: true)
    let signUpButton: UIButton = UIButton(type: .system).setUpButton(bgColor: .tableViewDarkGrey, text: "SIGN UP", font: UIFont.UIStandard!, color: .navigationsGreen, state: .normal)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI() {
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, betaCodeField, firstNameField, lastNameField, emailField, passwordField, verifyPasswordField, signUpButton])
        view.backgroundColor = .tableViewDarkGrey
        view.addSubviews(views: [stackView, welcomeLabel, betaCodeField, firstNameField, lastNameField, emailField, passwordField, verifyPasswordField, signUpButton])

        stackView.axis = .vertical
        stackView.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 400)
        welcomeLabel.anchors(top: stackView.topAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        betaCodeField.anchors(top: welcomeLabel.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        firstNameField.anchors(top: betaCodeField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.centerXAnchor, rightPad: -6, width: 0, height: 0)
        lastNameField.anchors(top: betaCodeField.bottomAnchor, topPad: 32, left: stackView.centerXAnchor, leftPad: 6, right: stackView.rightAnchor, width: 0, height: 0)
        emailField.anchors(top: firstNameField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.rightAnchor, width: 0, height: 0)
        passwordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.leftAnchor, right: stackView.centerXAnchor, rightPad: -6, width: 0, height: 0)
        verifyPasswordField.anchors(top: emailField.bottomAnchor, topPad: 32, left: stackView.centerXAnchor, leftPad: 6, right: stackView.rightAnchor, width: 0, height: 0)
        signUpButton.anchors(bottom: passwordField.bottomAnchor, bottomPad: 64, centerX: stackView.centerXAnchor, width: 64, height: 0)
    }
    
    @objc func signUpPressed() {
        if (betaCodeField.text?.isEmpty)! || (firstNameField.text?.isEmpty)! || (lastNameField.text?.isEmpty)! || (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! ||   (verifyPasswordField.text?.isEmpty)! {
            self.alertMessage(title: "You didn't think I would notice?", message: "There are missing fields.")
            return
        } else if ((passwordField.text! == verifyPasswordField.text!) != true) {
            alertMessage(title: "Watch out..", message: "Passwords do not match.")
            return
        } else if passwordField.text!.count < 6 {
            alertMessage(title: "What is Security..", message: "Password much be 6 characters long.")
            return
        }
        AuthService().registerUser(betaCode: (betaCodeField.text)!, firstName: (firstNameField.text)!, lastName: (lastNameField.text)!, email: (emailField.text)!, password: (passwordField.text)!) { (success) in
            if success {
                let controller = IntegrationSelectController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                self.alertMessage(title: "Alert", message: "An Error has occured. Try Again.")
            }
        }
    }
}
