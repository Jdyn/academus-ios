//
//  LogInIntegrationController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class LogInIntegrationController: UIViewController {

    var integrationName: String?
    var integrationService: IntegrationService?
    var powerSchool = "PowerSchool"
    var studentVue = "StudentVUE"
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign into your"
        label.font = UIFont(name: "AvenirNext-medium", size: 24)
        label.textColor = UIColor.navigationsWhite
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 36)
        label.textColor = UIColor.navigationsGreen
        return label
    }()
    
    let powerSchoolCodeField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.setGhostText(message: "District Code", color: UIColor.ghostText, font: UIFont.UIStandard!)
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let usernameField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.setGhostText(message: "Username", color: UIColor.ghostText, font: UIFont.UIStandard!)
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: UIColor.tableViewGrey, borderColor: UIColor.navigationsGreen)
        field.setGhostText(message: "Password", color: UIColor.ghostText, font: UIFont.UIStandard!)
        field.tintColor = UIColor.navigationsGreen
        field.textColor = UIColor.navigationsWhite
        return field
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setUpButton(bgColor: nil, text: "LOG IN", titleFont: UIFont.UIStandard!, titleColor: UIColor.navigationsGreen, titleState: .normal)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func logInPressed() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tableViewGrey
        setUpUI()
    }
    
    func setUpUI() {
        
        if integrationName == powerSchool {
            view.addSubview(powerSchoolCodeField)
        }
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(logInButton)
        
        subTitleLabel.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 32, centerX: view.centerXAnchor ,width: 0, height: 0)
        titleLabel.anchors(top: subTitleLabel.bottomAnchor, centerX: view.centerXAnchor, width: 0, height: 0)
        if integrationName == powerSchool {
            powerSchoolCodeField.anchors(bottom: usernameField.topAnchor, bottomPad: -16, left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor,width: 0, height: 0)
        }
        usernameField.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, centerY: view.centerYAnchor, CenterYPad: -32, width: 0, height: 0)
        passwordField.anchors(top: usernameField.bottomAnchor, topPad: 16, left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, width: 0, height: 0)
        logInButton.anchors(top: passwordField.bottomAnchor, topPad: 32,centerX: view.centerXAnchor,width: 64, height: 0)
    }
}
