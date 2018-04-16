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
        view.backgroundColor = .tableViewSeperator
        return view
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("GET STARTED", for: .normal)
        button.titleLabel?.font = UIFont.standard
        button.setTitleColor(.navigationsGreen, for: .normal)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
    }()
    
    let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Academus"
        label.font = UIFont(name: "AvenirNext-demibold", size: 26)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let subWelcomeText: UILabel = {
        let label = UILabel()
        label.text = "A student's best friend."
        label.font = UIFont(name: "AvenirNext-medium", size: 18)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let logInText: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont(name: "AvenirNext-medium", size: 12)
        label.font = label.font.withSize(12)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = UIFont.standard
        button.setTitleColor(.navigationsGreen, for: .normal)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = .tableViewDarkGrey
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
    }

    @objc func logInPressed() {
        navigationController?.pushViewController(AccountLogInController(), animated: true)
    }
    
    @objc func signUpPressed() {
        navigationController?.pushViewController(AccountCreateController(), animated: true)
    }
    
    func setupUI() {
        
        view.backgroundColor = .tableViewDarkGrey
        let stackView = UIStackView(arrangedSubviews: [ appLogo, welcomeText, subWelcomeText, divider, signUpButton])
        
        stackView.axis = .vertical
        
        view.addSubviews(views: [stackView, logInButton, logInText, appLogo, welcomeText, subWelcomeText, divider, signUpButton])
        
        stackView.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 350)
        appLogo.anchors(top: stackView.topAnchor, centerX: stackView.centerXAnchor, width: 128, height: 128)
        welcomeText.anchors(top: appLogo.bottomAnchor, topPad: 16, centerX: stackView.centerXAnchor, width: 0, height: 0)
        subWelcomeText.anchors(top: welcomeText.bottomAnchor, centerX: stackView.centerXAnchor, width: 0, height: 0)
        divider.anchors(top: subWelcomeText.bottomAnchor, topPad: 12, centerX: stackView.centerXAnchor, width: 150, height: 1)
        signUpButton.anchors(top: divider.bottomAnchor, topPad: 6,centerX: stackView.centerXAnchor, width: 128, height: 0)
        logInButton.anchors(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, width: 128, height: 0)
        logInText.anchors(bottom: logInButton.topAnchor, centerX: view.centerXAnchor, width: 0, height: 0)
    }
}
