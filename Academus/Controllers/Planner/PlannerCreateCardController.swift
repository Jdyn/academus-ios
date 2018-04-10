//
//  PlannerCreateController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData

//protocol CreateCardDelegate {
//    func didAddCard (card: PlannerCards)
//}

protocol CreateReminderCardDelegate {
    func didAddCard (card: PlannerReminderCard)
}

class PlannerCreateCardController: UIViewController {
    
    var delegate: CreateReminderCardDelegate?
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let title = UITextField().setupTextField(bgColor: .tableViewMediumGrey, bottomBorder: true, ghostText: "Enter Reminder")
    let datePicker =  UIColoredDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboard()
        navigationItem.title = "Create a Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = .tableViewDarkGrey
    }
    
    @objc private func handleSave() {
        if (title.text?.isEmpty)! {
            alertMessage(title: "Wait..", message: "Card title is missing.")
            return
        }
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        let card = NSEntityDescription.insertNewObject(forEntityName: "PlannerReminderCard", into: context)
        card.setValue(title.text, forKey: "title")
        card.setValue(Date(), forKey: "dateCreated")
        card.setValue(datePicker.date, forKey: "dateDue")
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddCard(card: card as! PlannerReminderCard)
            })
            
        } catch let error {
            print("Failed to save card: ", error)
        }
    }
    
    private func setupUI() {
        view.addSubviews(views: [background, title, datePicker])
        
        background.anchors(top: view.topAnchor, bottom: datePicker.bottomAnchor, bottomPad: 16, left: view.leftAnchor, right: view.rightAnchor)
        title.anchors(top: view.topAnchor, topPad: 32, left: view.leftAnchor, leftPad: 16, right: view.rightAnchor, rightPad: -16)
        datePicker.anchors(top: title.bottomAnchor, topPad: 16, left: view.leftAnchor, leftPad: 16, right: view.rightAnchor, rightPad: -16)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
