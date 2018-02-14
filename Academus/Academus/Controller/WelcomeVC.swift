//
//  WelcomeVC.swift
//  Academus
//
//  Created by Jaden Moore on 2/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBAction func GetStartedPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAccountCreation", sender: self)
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
        performSegue(withIdentifier: "toLogIn", sender: self)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        print("Unwinding..")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

