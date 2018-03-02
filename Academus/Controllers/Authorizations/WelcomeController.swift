//
//  WelcomeController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class WelcomeController: UIViewController {

    let appLogo: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "logo_colored")
        return view
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewSeperator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("GET STARTED", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-medium", size: 14)
        button.setTitleColor(UIColor.navigationsGreen, for: .normal)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Academus"
        label.font = UIFont(name: "AvenirNext-demibold", size: 26)
        label.textColor = UIColor.navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subWelcomeText: UILabel = {
        let label = UILabel()
        label.text = "A student's best friend."
        label.font = UIFont(name: "AvenirNext-medium", size: 18)
        label.textColor = UIColor.navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logInText: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont(name: "AvenirNext-medium", size: 12)
        label.font = label.font.withSize(12)
        label.textColor = UIColor.navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "userAccount")
        if dictionary?["authToken"] != nil {
            
        }
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = UIColor.tableViewGrey
        self.setupUI()
    }

    @objc func logInPressed() {
        print("pressed")
        navigationController?.pushViewController(LogInController(), animated: true)
    }
    
    @objc func signUpPressed() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    func setupUI() {
        
        let centralUIStackView = UIStackView(arrangedSubviews: [
            appLogo, welcomeText, subWelcomeText, divider, signUpButton
            ])
        
        centralUIStackView.translatesAutoresizingMaskIntoConstraints = false
        centralUIStackView.axis = .vertical
        centralUIStackView.distribution = .fillEqually
        centralUIStackView.alignment = .center
        
        view.addSubview(centralUIStackView)
        view.addSubview(logInButton)
        view.addSubview(logInText)
        view.addSubview(appLogo)
        view.addSubview(welcomeText)
        view.addSubview(subWelcomeText)
        view.addSubview(divider)
        view.addSubview(signUpButton)
        
        centralUIStackView.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 350)
        appLogo.anchors(top: centralUIStackView.topAnchor, centerX: centralUIStackView.centerXAnchor, width: 128, height: 128)
        welcomeText.anchors(top: appLogo.bottomAnchor, topPad: 16, centerX: centralUIStackView.centerXAnchor, width: 0, height: 0)
        subWelcomeText.anchors(top: welcomeText.bottomAnchor, centerX: centralUIStackView.centerXAnchor, width: 0, height: 0)
        divider.anchors(top: subWelcomeText.bottomAnchor, topPad: 12, centerX: centralUIStackView.centerXAnchor, width: 150, height: 1)
        signUpButton.anchors(top: divider.bottomAnchor, topPad: 6,centerX: centralUIStackView.centerXAnchor, width: 128, height: 0)
        logInButton.anchors(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, width: 128, height: 0)
        logInText.anchors(bottom: logInButton.topAnchor, centerX: view.centerXAnchor, width: 0, height: 0)
    }
}
