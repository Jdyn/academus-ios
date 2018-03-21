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

class PlannerCreateCardController: UIViewController {
    
    var delegate: CreateCardDelegate?
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .navigationsWhite
        return label
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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textColor = .navigationsWhite
        return label
    }()
    
    let dateField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewLightGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Set a date", color: .ghostText, font: UIFont.UIStandard!)
        field.textColor = .navigationsWhite
        
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePickerMode.date
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(endDateEditing))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        field.inputView = picker
        field.inputAccessoryView = toolbar
        
        return field
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
        print("Trying to save company...")
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        let card = NSEntityDescription.insertNewObject(forEntityName: "PlannerCards", into: context)
        card.setValue(nameField.text, forKey: "name")
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddCard(card: card as! PlannerCards)
            })
            
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
    }
    
    private func setupUI() {
        view.addSubview(background)
        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(dateLabel)
        view.addSubview(dateField)
        
        background.anchors(top: view.topAnchor, bottom: view.centerYAnchor, left: view.leftAnchor, right: view.rightAnchor, width: 0, height: 0)
        nameLabel.anchors(top: background.topAnchor, topPad: 32, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
        nameField.anchors(top: nameLabel.bottomAnchor, topPad: 16, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
        dateLabel.anchors(top: nameField.bottomAnchor, topPad: 32, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
        dateField.anchors(top: dateLabel.bottomAnchor, topPad: 16, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func endDateEditing() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let selectedDate = formatter.string(from: (dateField.inputView as! UIDatePicker).date)
        dateField.text = selectedDate
        view.endEditing(true)
    }
    
    @objc func endTextEditing() {
        view.endEditing(true)
    }
}
