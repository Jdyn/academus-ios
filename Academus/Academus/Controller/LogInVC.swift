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
    
    var fieldCheck = false
    var authService = AuthService()
    
    @IBAction func logInpressed(_ sender: Any) {
        //Check if all of the fields are are entered
        userFieldCheck()
        // Log in the user
        if (fieldCheck) {
            logInUser()
        }
        CourseService.instance.getCourses { (success) in
            print(success)
        }
    }
    
    func userFieldCheck() {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            alertMessage(userMessage: "Missing field.")
            fieldCheck = false
            return
        } else {
            fieldCheck = true
        }
    }

    func logInUser() {
        AuthService.instance.logInUser(email: emailTextField.text!, password: passwordTextField.text!)
        { (success) in
            if success {
                print("logged in user")
                self.performSegue(withIdentifier: "toMainApp", sender: nil)
            } else {
                print("log in failure")
                self.alertMessage(userMessage: "Wrong username or password.")
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
