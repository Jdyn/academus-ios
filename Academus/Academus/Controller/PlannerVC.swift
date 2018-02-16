//
//  PlannerVC.swift
//  Academus
//
//  Created by Jaden Moore on 2/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerVC: UITableViewController, ExpandableHeaderViewDelegate {

//    var sections = [Section]()

    var sections = [
        Section(sectionHeaderName : "Academus",
                tasks : ["New assignment Posted in ENG 12", "New grade posted for QUIZ in Math"],
                expanded : false, isImportant : false, isFinished : false),
        Section(sectionHeaderName : "Todo List",
                 tasks : ["Go to school", "Take out the trash","Go to school", "Take out the trash","Go to school", "Take out the trash"],
                 expanded : false, isImportant : false, isFinished : false),
        Section(sectionHeaderName : "Homework",
                tasks : ["Do chapter 3 vocab", "Page 43 Math","Go to school", "Take out the trash","Go to school", "Take out the trash"],
                expanded : false, isImportant : false, isFinished : false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tasks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 50
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ExpandableHeaderView()
        headerView.customInit(title: sections[section].sectionHeaderName, section: section, delegate: self)
        
//        let borderTop = UIView(frame: CGRect(x:0, y:0, width: tableView.bounds.size.width, height: 1.0))
//        borderTop.backgroundColor = UIColor.self.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
//        headerView.addSubview(borderTop)
//
//        let borderBottom = UIView(frame: CGRect(x:0, y:60, width: tableView.bounds.size.width, height: 0.5))
//        borderBottom.backgroundColor = UIColor.self.init(red: 99/255, green: 99/255, blue: 99/255, alpha: 1.0)
//        headerView.addSubview(borderBottom)
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerCell", for: indexPath) as? PlannerCell {
            let taskName = sections[indexPath.section].tasks[indexPath.row]
            let taskNumber = "\(indexPath.row + 1)"
            cell.configureCell(name: taskName, number: taskNumber)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func toogleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        tableView.beginUpdates()
        for i in 0..<sections[section].tasks.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .fade)
        }
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPlannerDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let important = importantAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete, important])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        var section = self.sections[indexPath.section]
        let action = UIContextualAction(style: .normal, title: "important") { (action, view, completion) in
            
            section.isImportant = !section.isImportant
            
            if section.isImportant == true {
                self.tableView.beginUpdates()
                self.tableView.moveRow(at: IndexPath(row: indexPath.row, section: indexPath.section), to: IndexPath(row: 0, section: indexPath.section))
                self.tableView.endUpdates()

            }
            print(section.isImportant)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "bookmark")
        action.backgroundColor = section.isImportant ? .green : .purple
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        var section = self.sections[indexPath.section]
        let action = UIContextualAction(style: .destructive, title: "delete") { (action, view, completion) in
            self.sections[indexPath.section].tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .fade)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "plannerDelete")
        action.backgroundColor = .red
        return action
    }
}
