//
//  CreateAccountVC.swift
//  Academus
//
//  Created by Jaden Moore on 2/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Alamofire

class CreateAccountVC: UIViewController {

    @IBOutlet weak var betaCodeTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifedPasswordTextField: UITextField!
    
    @IBAction func SignUpButton(_ sender: Any) {
        
        //Check if any fields are empty
        emptyFieldsCheck()
        //Check if the passwords match
        equalPasswordCheck()
        //Show Loading indicator
        loadingIndicator()
        //Create User
        AuthService.instance.registerUser(betaCode: (betaCodeTextField.text)!, firstName: (firstNameTextField.text)!, lastName: (lastNameTextField.text)!, email: (emailTextField.text)!, password: (passwordTextField.text)!)
        { (success) in
            if success {
                print("registered user")
            } else {
                print("register failure")
            }
        }
    }
    
    func emptyFieldsCheck() {
        if (betaCodeTextField.text?.isEmpty)! ||
            (firstNameTextField.text?.isEmpty)! ||
            (lastNameTextField.text?.isEmpty)! ||
            (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (verifedPasswordTextField.text?.isEmpty)! {
            
            alertMessage(userMessage: "Enter all of the fields.")
            return
        }
    }
    
    func equalPasswordCheck() {
        if ((passwordTextField.text! == verifedPasswordTextField.text!) != true) {
            alertMessage(userMessage: "Ensure Passwords are matching.")
            return
        }
    }
    
    func alertMessage(userMessage: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                (action:UIAlertAction!) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func loadingIndicator() {
        let ActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        ActivityIndicator.center = view.center
        ActivityIndicator.hidesWhenStopped = false
        ActivityIndicator.startAnimating()
        view.addSubview(ActivityIndicator)
    }
}
