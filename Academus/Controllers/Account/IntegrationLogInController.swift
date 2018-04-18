//
//  LogInIntegrationController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationLogInController: UIViewController {

    var integrationService: IntegrationService?
    var integration: IntegrationChoice?
    var integrationName: String?
    var fields: [UITextField] = []

    let titleLabel = UILabel().setUpLabel(text: "", font: UIFont(name: "AvenirNext-demibold", size: 36)!, fontColor: .navigationsGreen)
    let subtitle = UILabel().setUpLabel(text: "Sign into your", font: UIFont(name: "AvenirNext-medium", size: 24)!, fontColor: .navigationsWhite)
    let button = UIButton(type: .system).setUpButton(title: "SIGN IN", font: UIFont.standard!, fontColor: .navigationsGreen)
    
    @objc func logInPressed() {
        guard let fieldsCounts = integration?.fields.count else {return}
        for i in 0...fieldsCounts - 1 {
            if (fields[i].text?.isEmpty)! {
                alertMessage(title: "Alert", message: "There is a missing field.")
                return
            }
        }
        loadingAlert(title: "Pleast wait", message: "Attempting to add new integration")
        integrationService?.addIntegration(fields: fields) { (success) in
            if success {
                self.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                    (UIApplication.shared.delegate as! AppDelegate).mainController?.clearBlur()
                })
            } else {
                print("failure here")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setUpUI()
    }

    private func setUpUI() {

        view.backgroundColor = .tableViewDarkGrey
        
        guard let fieldsCounts = integration?.fields.count else {return}
        for i in 0...fieldsCounts - 1 {
            let field = UITextField().setupTextField(bgColor: .tableViewDarkGrey, bottomBorder: true, ghostText: integration?.fields[i].id, isLeftImage: false, isSecure: false)
            field.font = UIFont.standard!
            if integration?.fields[i].id == "password" {
                field.isSecureTextEntry = true
            }
            view.addSubview(field)
            field.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, width: 0, height: 0)
            fields.append(field)
        }

        let stackView = UIStackView(arrangedSubviews: fields)
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubviews(views: [stackView, subtitle, titleLabel, button])
        stackView.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, centerY: view.centerYAnchor, CenterYPad: -32)
        subtitle.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 32, centerX: view.centerXAnchor)
        titleLabel.anchors(top: subtitle.bottomAnchor, centerX: view.centerXAnchor, width: 0, height: 0)
        button.anchors(top: stackView.bottomAnchor, topPad: 32, centerX: view.centerXAnchor, width: 84)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
    }
}

