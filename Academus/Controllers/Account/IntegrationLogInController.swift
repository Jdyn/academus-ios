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
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign into your"
        label.font = UIFont(name: "AvenirNext-medium", size: 24)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 36)
        label.textColor = .navigationsGreen
        return label
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setUpButton(bgColor: nil, text: "LOG IN", titleFont: UIFont.UIStandard!, titleColor: .navigationsGreen, titleState: .normal)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func logInPressed() {
        print(fields[0].text!)
        print(fields[1].text!)
        integrationService?.addIntegration(fields: fields) { (success) in
            if success {
                print("success here")
            } else {
                print("failure here")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        view.backgroundColor = .tableViewGrey
    }
        
    func setUpUI() {
        
        guard let fieldsCounts = integration?.fields.count else {return}
        for i in 0...fieldsCounts - 1 {
            let field = UITextField()
            field.setBorderBottom(backGroundColor: .tableViewGrey, borderColor: .navigationsGreen)
            field.setGhostText(message: (integration?.fields[i].id)!, color: .ghostText, font: UIFont.UIStandard!)
            field.textColor = .navigationsWhite
            
            view.addSubview(field)
            field.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, width: 0, height: 0)
            fields.append(field)
        }
        
        let stackView = UIStackView(arrangedSubviews: fields)
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        view.addSubview(subTitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(logInButton)
        stackView.anchors(left: view.leftAnchor, leftPad: 32, right: view.rightAnchor, rightPad: -32, centerX: view.centerXAnchor, centerY: view.centerYAnchor, CenterYPad: -32, width: 0, height: 0)
        subTitleLabel.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 32, centerX: view.centerXAnchor ,width: 0, height: 0)
        titleLabel.anchors(top: subTitleLabel.bottomAnchor, centerX: view.centerXAnchor, width: 0, height: 0)
        logInButton.anchors(top: stackView.bottomAnchor, topPad: 32, centerX: view.centerXAnchor,width: 64, height: 0)

    }
}
