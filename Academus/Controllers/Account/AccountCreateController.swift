//
//  SignUpController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class AccountCreateController: UIViewController, accountCreateErrorDelegate {
    
    let welcomeLabel = UILabel().setUpLabel(text: "Create an Account", font: UIFont.header!, fontColor: .navigationsWhite)
    let signUpButton = UIButton(type: UIButtonType.roundedRect).setUpButton(title: "SIGN UP", font: UIFont.standard!, fontColor: .navigationsGreen)
    
    var scrollView: UIScrollView?
    var fields = [UITextField]()
    
    let impact = UIImpactFeedbackGenerator()
    
    var mainController: MainController? // An instance of MainController
    var accountCreateError: String = "An unknown error has occured. Please try again."
    let authService = AuthService()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setupUI()
    }
    
    private func setupUI() {
        let titles = ["First Name", "Last Name", "Email", "Password", "Verify Password"]
        let screen = UIScreen.main.bounds
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
        scrollView!.contentSize = CGSize(width: screen.width, height: screen.height + 150)
        scrollView!.addSubviews(views: [welcomeLabel, signUpButton])
        
        for title in titles {
            let textField = UITextField().setupTextField(bottomBorder: true, ghostText: title)
            scrollView!.addSubview(textField)
            self.fields.append(textField)
        }
        
        fields[2].keyboardType = .emailAddress
        fields[2].autocapitalizationType = .none
        
//        fields[0].autocapitalizationType = .none
        fields[2].keyboardType = .emailAddress
        fields[3].isSecureTextEntry = true
        fields[4].isSecureTextEntry = true

        view.backgroundColor = .tableViewDarkGrey
        view.addSubview(scrollView!)
        
//        fields[0].anchors(top: scrollView!.topAnchor, topPad: view.bounds.height * 1/4, left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, height: fieldHeight)
        fields[0].anchors(top: scrollView!.topAnchor, topPad: view.bounds.height * 1/4, left: view.leftAnchor, leftPad: 12, right: view.centerXAnchor, rightPad: -6, height: fieldHeight)
        fields[1].anchors(top: scrollView!.topAnchor, topPad: view.bounds.height * 1/4, left: view.centerXAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -12, height: fieldHeight)
        fields[2].anchors(top: fields[1].bottomAnchor, topPad: 16, left: fields[0].leftAnchor, right: fields[1].rightAnchor, height: fieldHeight)
        fields[3].anchors(top: fields[2].bottomAnchor, topPad: 16, left: fields[0].leftAnchor, right: fields[0].rightAnchor, height: fieldHeight)
        fields[4].anchors(top: fields[2].bottomAnchor, topPad: 16, left: fields[1].leftAnchor, right: fields[1].rightAnchor, height: fieldHeight)
        welcomeLabel.anchors(bottom: fields[0].topAnchor, bottomPad: -32, centerX: view.centerXAnchor)
        signUpButton.anchors(top: fields[4].bottomAnchor, topPad: 32, centerX: view.centerXAnchor, width: 145, height: 45)
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
    }
    
    @objc func signUpPressed() {
        impact.impactOccurred()

        for field in fields {
            field.resignFirstResponder()
            if (field.text?.isEmpty)! {
                self.alertMessage(title: "Hey!", message: "Please fill out all fields to continue.")
                return
            }
        }
        if ((fields[3].text! == fields[4].text!) != true) {
            alertMessage(title: "Watch out...", message: "Passwords do not match.")
            return
        } else if fields[3].text!.count < 6 {
            alertMessage(title: "What is Security...", message: "Password must be at least 6 characters.")
            return
        }

        loadingAlert(title: "Attempting to Create Account", message: "Please wait...")
        authService.accountCreateDelegate = self
        
        authService.registerUser(firstName: (fields[0].text)!, lastName: (fields[1].text)!, email: (fields[2].text)!, password: (fields[3].text)!, appleToken: self.mainController?.apnsToken) { (success) in
            if success {
                self.dismiss(animated: true, completion: {
                    let controller = IntegrationSelectController()
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            } else {
                self.dismiss(animated: true, completion: {
                    self.alertMessage(title: "Alert", message: self.accountCreateError)
                })
            }
        }
    }
}
