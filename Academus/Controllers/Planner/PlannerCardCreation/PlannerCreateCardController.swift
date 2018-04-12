//
//  PlannerCreateController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData

class PlannerCreateCardController: UITableViewController {
    
    var cellTypes = [CardFormManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create a Card"
        setupCancelButtonInNavBar()
    }
    
    func currentCell(c: PlannerMainCell, index: Int){
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let c = cellTypes[indexPath.row]
        return c.cellType().getHeight()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = cellTypes[indexPath.row]
        let cellClass = c.cellType().getClass()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.cellReuseIdentifier(), for: indexPath) as! PlannerMainCell
        cell.set(placeholder: c.placeholder(), secureEntry: c.keyboardSecure(), keyboardType: c.keyboardType())
        cell.type = c.cellType()
        if cell.type == .dropdown { cell.pickerOptions = c.pickerOptions() }
        currentCell(c: cell, index: indexPath.row)
        
        return cell
    }
}
