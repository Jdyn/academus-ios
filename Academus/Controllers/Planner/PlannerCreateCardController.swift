//
//  PlannerCreateController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCardDelegate {
    func didAddCard (card: PlannerCards)
}

protocol CreateReminderCardDelegate {
    func didAddCard (card: PlannerReminderCard)
}

class PlannerCreateCardController: UIViewController {
    
    var delegate: CreateReminderCardDelegate?
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        return view
    }()
    
    let nameField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewLightGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Set a title", color: .ghostText, font: UIFont.UIStandard!)
        field.textColor = .navigationsWhite
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(endTextEditing))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        field.inputAccessoryView = toolbar
        
        return field
    }()
    
    let datePicker: UIColoredDatePicker = {
        let picker = UIColoredDatePicker()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "Create a Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = .tableViewGrey
    }
    
    @objc private func handleSave() {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        let card = NSEntityDescription.insertNewObject(forEntityName: "PlannerReminderCard", into: context)
        card.setValue(nameField.text, forKey: "title")
        card.setValue(datePicker.date, forKey: "dateDue")
        card.setValue(Date(), forKey: "dateCreated")
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddCard(card: card as! PlannerReminderCard)
            })
            
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
    }
    
    private func setupUI() {
        view.addSubview(background)
        view.addSubview(nameField)
        view.addSubview(datePicker)
        
        background.anchors(top: view.topAnchor, bottom: view.centerYAnchor, bottomPad: 50, left: view.leftAnchor, right: view.rightAnchor, width: 0, height: 0)
        nameField.anchors(top: background.topAnchor, topPad: 60, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
        datePicker.anchors(top: nameField.bottomAnchor, topPad: 16, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func endTextEditing() {
        view.endEditing(true)
    }
}
