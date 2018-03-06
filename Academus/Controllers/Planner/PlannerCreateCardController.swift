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
    func didAddCard (card: PlannerCard)
}

class PlannerCreateCardController: UIViewController {
    
    var delegate : CreateCardDelegate?
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let nameField: UITextField = {
        let field = UITextField()
        field.setBorderBottom(backGroundColor: .tableViewLightGrey, borderColor: .navigationsGreen)
        field.setGhostText(message: "Set a title", color: .ghostText, font: UIFont.UIStandard!)
        field.textColor = .navigationsWhite
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
        
        let card = NSEntityDescription.insertNewObject(forEntityName: "PlannerCard", into: context)
        card.setValue(nameField.text, forKey: "name")
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddCard(card: card as! PlannerCard)
            })
            
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
    }
    
    private func setupUI() {
        
        view.addSubview(background)
        view.addSubview(nameField)
        
        background.anchors(top: view.topAnchor, bottom: view.centerYAnchor, left: view.leftAnchor, right: view.rightAnchor, width: 0, height: 0)
        nameField.anchors(top: background.topAnchor, topPad: 16, left: background.leftAnchor, leftPad: 32, right: background.rightAnchor, rightPad: -32, width: 0, height: 0)
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
