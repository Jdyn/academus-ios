//
//  PlannerCreateController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData

class PlannerCreateCardController: UIViewController {
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let titleField = UITextField().setupTextField(bgColor: .tableViewMediumGrey, bottomBorder: true, ghostText: "Enter Reminder")
    let datePicker =  UIColoredDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tableViewDarkGrey
        
        navigationItem.title = "Create a Card"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
        hideKeyboard()
        setupCancelButtonInNavBar()
    }
    
    @objc private func handleSave() {
        if (titleField.text?.isEmpty)! {
            alertMessage(title: "Wait..", message: "Card title is missing.")
            return
        }
    }
    
    private func setupUI() {
        view.addSubviews(views: [background, titleField, datePicker])
        
        background.anchors(top: view.topAnchor, bottom: datePicker.bottomAnchor, bottomPad: 16, left: view.leftAnchor, right: view.rightAnchor)
        titleField.anchors(top: view.topAnchor, topPad: 32, left: view.leftAnchor, leftPad: 16, right: view.rightAnchor, rightPad: -16)
        datePicker.anchors(top: titleField.bottomAnchor, topPad: 16, left: view.leftAnchor, leftPad: 16, right: view.rightAnchor, rightPad: -16)
    }
}
