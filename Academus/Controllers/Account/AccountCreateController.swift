//
//  SignUpController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class AccountCreateController: UIViewController {

    let welcomeLabel = UILabel().setUpLabel(text: "Welcome Back", font: UIFont.UIHeader!, fontColor: .navigationsWhite)
    let signUpButton = UIButton(type: .system).setUpButton(title: "SIGN UP", font: UIFont.UIStandard!, fontColor: .navigationsGreen)
    var fields = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI() {
        let stack = UIStackView()
        let titles = ["Beta Code", "First Name", "Last Name", "Email", "Password", "Verify Password"]
        for title in titles {
            let textField = UITextField().setupTextField(bottomBorder: true, ghostText: title)
            stack.addArrangedSubview(textField)
            view.addSubview(textField)
            self.fields.append(textField)
        }
        
        view.backgroundColor = .tableViewDarkGrey
        view.addSubviews(views: [stack, welcomeLabel, signUpButton])
        
        stack.axis = .vertical
        stack.anchors(top: view.topAnchor, topPad: view.bounds.height * 1/4, bottom: view.bottomAnchor, bottomPad: view.bounds.height * -1/4, left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32)
        fields[0].anchors(top: stack.topAnchor, left: stack.leftAnchor, right: stack.rightAnchor, centerX: stack.centerXAnchor)
        fields[1].anchors(top: fields[0].bottomAnchor, topPad: 32, left: stack.leftAnchor, right: view.centerXAnchor, rightPad: -6)
        fields[2].anchors(top: fields[0].bottomAnchor, topPad: 32, left: stack.centerXAnchor, leftPad: 6, right: stack.rightAnchor)
        fields[3].anchors(top: fields[2].bottomAnchor, topPad: 32, left: stack.leftAnchor, right: stack.rightAnchor)
        fields[4].anchors(top: fields[3].bottomAnchor, topPad: 32, left: stack.leftAnchor, right: stack.centerXAnchor, rightPad: -6)
        fields[5].anchors(top: fields[3].bottomAnchor, topPad: 32, left: stack.centerXAnchor, leftPad: 6, right: stack.rightAnchor)
        welcomeLabel.anchors(bottom: stack.topAnchor, centerX: stack.centerXAnchor)
        signUpButton.anchors(top: stack.bottomAnchor, topPad: 0, centerX: stack.centerXAnchor, width: 64)
    }
    
    @objc func signUpPressed() {
        for field in fields {
            if (field.text?.isEmpty)! {
                self.alertMessage(title: "You didn't think I would notice?", message: "There are missing fields.")
                return
            }
        }
        if ((fields[4].text! == fields[5].text!) != true) {
            alertMessage(title: "Watch out..", message: "Passwords do not match.")
            return
        } else if fields[4].text!.count < 6 {
            alertMessage(title: "What is Security..", message: "Password much be 6 characters long.")
            return
        }
        AuthService().registerUser(betaCode: (fields[0].text)!, firstName: (fields[1].text)!, lastName: (fields[2].text)!, email: (fields[3].text)!, password: (fields[4].text)!) { (success) in
            if success {
                let controller = IntegrationSelectController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                self.alertMessage(title: "Alert", message: "An Error has occured. Try Again.")
            }
        }
    }
}
