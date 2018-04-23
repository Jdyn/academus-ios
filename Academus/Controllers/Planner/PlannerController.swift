//
//  PlannerController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData
import Locksmith

class PlannerController: UITableViewController, PlannerCardDelegate {
    
    var cards = [UpdatedCourses]()
    var plannerService = PlannerService()
    var cells = [PlannerCellManager]()
    var cellId = "dmgonsdjg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewDarkGrey
        tableView.separatorStyle = .none
        
//        setupAddButtonInNavBar(selector: #selector(addPlannerCard))
        setupChatButtonInNavBar()
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        tableView.register(PlannerCell.self, forCellReuseIdentifier: cellId)

        plannerService.delegate = self
        plannerService.getPlannerCards { (success) in
            if success {
                
                self.cards.forEach({ (card) in
                    self.cells.append(.coursePlannerCard)
                })
                print(self.cells)
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetPlannerCards(cards: [UpdatedCourses]) {
        self.cards.removeAll()
        for card in cards {
            self.cards.append(card)
        }
    }
    
    @objc func addPlannerCard() {
        let createController = MainNavigationController(rootViewController: CardCreationController())
        navigationController?.present(createController, animated: true, completion: {
            // COMPLETION CODE HERE
        })
    }
    
    @objc func refreshTable() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
            self.refreshControl?.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                self.tableView.reloadData()
            })
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cards.count == 0 {
            self.tableViewEmptyLabel(message: "Hello :) \nThis feature is coming soon!", show: true)
        } else {
            self.tableViewEmptyLabel(show: false)
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlannerCell {
        
        let model = cards[indexPath.row]
        let manager = cells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlannerCell
        cell.setup(type: manager.getTitle(), createdDate: (model.currentGrade?.loggedAt)!)
        return coursePlannerCard(cell: cell, model: model, manager: manager)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 165 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 9 }
}

extension PlannerController {
    
    func coursePlannerCard(cell: PlannerCell, model: UpdatedCourses, manager: PlannerCellManager) -> PlannerCell {
        cell.backgroundColor = .tableViewDarkGrey
        
        let title = UILabel().setUpLabel(text: "Your grade in \((model.course?.name)!) has changed:" , font: UIFont.standard!, fontColor: .navigationsWhite)
        let grade = UILabel().setUpLabel(text: "Grade: \(model.previousGrade?.gradePercent ?? 0)% → \(model.currentGrade?.gradePercent ?? 0)%", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true
        title.lineBreakMode = .byWordWrapping
//        title.backgroundColor = .red
        
        cell.addSubviews(views: [title, grade])
        
        title.anchors(top: cell.divider.bottomAnchor, topPad: 9, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: 0)
        grade.anchors(top: title.bottomAnchor, topPad: 9, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -6)
        
        return cell
    }
}
