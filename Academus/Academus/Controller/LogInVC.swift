//
//  LogInVC.swift
//  Academus
//
//  Created by Jaden Moore on 2/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func LoginPressed(_ sender: Any) {
        
        print(emailTextField.text!)
        print(passwordTextField.text!)
        AuthService.instance.logInUser(email: emailTextField.text!, password: passwordTextField.text!)
        { (success) in
            if success {
                print("logged in user")
            } else {
                print("log in failure")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
