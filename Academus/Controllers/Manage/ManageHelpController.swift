//
//  HelpController.swift
//  Academus
//
//  Created by Jaden Moore on 3/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Crisp
import Locksmith

class ManageHelpController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chat"
        
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) else { return }
        let email = dictionary["email"] as! String
        let firstName = dictionary["firstName"] as! String
        let lastName = dictionary["lastName"] as! String
        
        Crisp.user.set(email: email)
        Crisp.user.set(nickname: firstName + " " + lastName)
        
        Crisp.session.set(segment: "chat")
        Crisp.session.set(segment: "ios")
        

        let crispView = CrispView()
        view.addSubview(crispView)
        
        crispView.anchors(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
}
