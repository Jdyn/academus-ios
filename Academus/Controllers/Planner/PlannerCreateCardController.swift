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
    
    let background: UIView = UIView()
    let nameField: UITextField = UITextField().setupTextField(bgColor: UIColor.tableViewMediumGrey, isBottomBorder: true, isGhostText: true, ghostText: "Enter a title", isLeftImage: false, leftImage: nil, isSecure: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .tableViewDarkGrey
        navigationItem.title = "Create a Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        background.backgroundColor = UIColor.tableViewMediumGrey
        
        view.addSubviews(views: [background, nameField])

        background.anchors(top: view.topAnchor, bottom: view.centerYAnchor, left: view.leftAnchor, right: view.rightAnchor, width: 0, height: 0)
        nameField.anchors(top: background.topAnchor, topPad: 32, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
    }
    
    @objc private func handleSave() {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        let card = NSEntityDescription.insertNewObject(forEntityName: "PlannerCards", into: context)
        card.setValue(nameField.text, forKey: "name")
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didAddCard(card: card as! PlannerCards)
            })
        } catch let error {
            print(error)
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
