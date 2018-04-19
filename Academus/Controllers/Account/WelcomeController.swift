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
    
    let appLogo = UIImageView().setupImageView(color: .clear, image: #imageLiteral(resourceName: "logo_colored"))
    let divider = UIView().setupBackground(bgColor: .tableViewSeperator)
    let signUpButton = UIButton(type: .system).setUpButton(bgColor: .none, title: "GET STARTED", font: UIFont.standard!, fontColor: .navigationsGreen, state: .normal)
    let welcomeLabel = UILabel().setUpLabel(text: "Welcome to Academus", font: UIFont(name: "AvenirNext-demibold", size: 26)!, fontColor: .navigationsWhite)
    let subwelcomeLabel = UILabel().setUpLabel(text: "A student's best friend.", font: UIFont(name: "AvenirNext-medium", size: 18)!, fontColor: .navigationsWhite)
    let logInLabel = UILabel().setUpLabel(text: "Already have an account?", font: UIFont(name: "AvenirNext-medium", size: 12)!, fontColor: .navigationsWhite)
    let logInButton = UIButton(type: .system).setUpButton(bgColor: .none, title: "LOG IN", font: UIFont.standard!, fontColor: .navigationsGreen, state: .normal)

    var mainController: MainController?
    
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
        let accountLogInController = AccountLogInController()
        accountLogInController.mainController = self.mainController
        navigationController?.pushViewController(accountLogInController, animated: true)
    }
    
    @objc func signUpPressed() {
        let accountCreateController = AccountCreateController()
        accountCreateController.mainController = self.mainController
        navigationController?.pushViewController(accountCreateController, animated: true)
    }
    
    func setupUI() {
        view.backgroundColor = .tableViewDarkGrey
        
        view.addSubviews(views: [logInButton, logInLabel, appLogo, welcomeLabel, subwelcomeLabel, divider, signUpButton])
        
        appLogo.anchors(top: view.topAnchor, topPad: UIScreen.main.bounds.size.height * 1/6, centerX: view.centerXAnchor, width: 128, height: 128)
        welcomeLabel.anchors(top: appLogo.bottomAnchor, topPad: 16, centerX: view.centerXAnchor)
        subwelcomeLabel.anchors(top: welcomeLabel.bottomAnchor, centerX: view.centerXAnchor)
        divider.anchors(top: subwelcomeLabel.bottomAnchor, topPad: 12, centerX: view.centerXAnchor, width: 150, height: 1)
        signUpButton.anchors(top: divider.bottomAnchor, topPad: 6,centerX: view.centerXAnchor, width: 128)
        logInButton.anchors(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, width: 128)
        logInLabel.anchors(bottom: logInButton.topAnchor, centerX: view.centerXAnchor)
        
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
    }
}
