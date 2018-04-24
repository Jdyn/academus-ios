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
    
    var cards = [PlannerCard]()
    var plannerService = PlannerService()
    var cells: [PlannerCellManager] = [PlannerCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewDarkGrey
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
//        setupAddButtonInNavBar(selector: #selector(addPlannerCard))
        setupChatButtonInNavBar()
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

        plannerService.delegate = self
        plannerService.getPlannerCards { (success) in
            if success {
                self.cards.forEach({ (card) in
                    if card.type == "course_updated" {
                        self.cells.append(.courseUpdatedCard)
                        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: card.type!)
                    } else if card.type == "assignment_posted" {
                        self.cells.append(.assignmentPostedCard)
                        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: card.type!)
                    } else if card.type == "assignment_updated" {
                        self.cells.append(.assignmentUpdatedCard)
                        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: card.type!)
                    } else if card.type == "upcoming_assignment" {
                        self.cells.append(.upcomingAssignmentCard)
                        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: card.type!)
                    }
                })
                self.tableView.reloadData()
            }
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200.0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func didGetPlannerCards(cards: [PlannerCard]) {
        print("DID GET CARDS")
        self.cards.removeAll()
        for card in cards {
            self.cards.append(card)
        }
        print(self.cards)
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
            self.tableViewEmptyLabel(message: "", show: true)
        } else {
            self.tableViewEmptyLabel(show: false)
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlannerCell {
        
        let model = cards[indexPath.row]
        let manager = cells[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: model.type!, for: indexPath) as! PlannerCell
        cell.setup(type: manager.getTitle(), createdDate: (model.date)!, color: manager.getColor())
                
        switch manager {
        case .courseUpdatedCard: return courseUpdatedCell(cell: cell, model: model, manager: manager)
        case .assignmentPostedCard: return assignmentPostedCell(cell: cell, model: model, manager: manager)
        case .assignmentUpdatedCard: return assignmentUpdatedCell(cell: cell, model: model, manager: manager)
        case .upcomingAssignmentCard: return upcomingAssignment(cell: cell, model: model, manager: manager)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 9 }
}

extension PlannerController {
    
    func courseUpdatedCell(cell: PlannerCell, model: PlannerCard, manager: PlannerCellManager) -> PlannerCell {
        
        let currentGrade = model.newGrade?.gradePercent ?? 0
        let previousGrade = model.previousGrade?.gradePercent ?? 0
        
        let currentGradeColor: UIColor
        let previousGradeColor: UIColor

        if previousGrade > currentGrade {
            currentGradeColor = .navigationsRed
            previousGradeColor = .navigationsGreen
        } else if previousGrade < currentGrade {
            currentGradeColor = .navigationsGreen
            previousGradeColor = .navigationsRed
        } else {
            previousGradeColor = .tableViewLightGrey
            currentGradeColor = .tableViewLightGrey
        }
        
        let gradeText = "Grade: \(previousGrade)% → \(currentGrade)%"
        let gradeString: NSMutableAttributedString = NSMutableAttributedString(string: gradeText)
        gradeString.setColorForText(textForAttribute: "\(previousGrade)%", withColor: previousGradeColor)
        gradeString.setColorForText(textForAttribute: "\(currentGrade)%", withColor: currentGradeColor)
        cell.gradeLabel.textColor = .tableViewLightGrey
        cell.gradeLabel.font = UIFont.standard
        cell.gradeLabel.attributedText = gradeString
        
        let courseTitle = "Your grade in \((model.course?.name) ?? "a course") has been updated:"
        let courseNameString: NSMutableAttributedString = NSMutableAttributedString(string: courseTitle)
        courseNameString.setColorForText(textForAttribute: "\((model.course?.name) ?? "unknown")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.textColor = .navigationsWhite
        cell.titleLabel.font = UIFont.subheader
        cell.titleLabel.attributedText = courseNameString

        cell.titleLabel.numberOfLines = 2
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        cell.addSubviews(views: [cell.titleLabel, cell.gradeLabel])
        
        cell.titleLabel.anchors(top: cell.divider.bottomAnchor, topPad: 6, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -9)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 16, bottom: cell.background.bottomAnchor, bottomPad: -12, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -6)
        
        return cell
    }
    
    func assignmentPostedCell(cell: PlannerCell, model: PlannerCard, manager: PlannerCellManager) -> PlannerCell {
        
        
        let titleText = "\"\((model.assignment?.name) ?? "Assignment")\" has been posted in \(model.assignment?.course?.name ?? "a course")"
        let titleString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)
        titleString.setColorForText(textForAttribute: "\"\(model.assignment?.name ?? "An assignment")\"", withColor: UIColor.navigationsGreen)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.course?.name ?? "a course")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.textColor = .navigationsWhite
        cell.titleLabel.font = UIFont.standard
        cell.titleLabel.attributedText = titleString
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.lineBreakMode = .byWordWrapping

        let gradeText = "Grade: \(model.assignment?.score?.text ?? "N/A")"
        let gradeString: NSMutableAttributedString = NSMutableAttributedString(string: gradeText)
        gradeString.setColorForText(textForAttribute: "\(model.assignment?.score?.text ?? "N/A")", withColor: .navigationsWhite)
        cell.gradeLabel.textColor = .tableViewLightGrey
        cell.gradeLabel.font = UIFont.standard
        cell.gradeLabel.attributedText = gradeString
        
        cell.addSubviews(views: [cell.titleLabel, cell.gradeLabel])
        
        cell.titleLabel.anchors(top: cell.divider.bottomAnchor, topPad: 6, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -9)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 16, bottom: cell.background.bottomAnchor, bottomPad: -12, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -6)

        
        return cell
    }
    
    func assignmentUpdatedCell(cell: PlannerCell, model: PlannerCard, manager: PlannerCellManager) -> PlannerCell {
        
        let titleText = "Your grade on \"\(model.assignment?.name ?? "an Assignment")\" in \(model.assignment?.course?.name ?? "a course") has been updated"
        let titleString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)
        titleString.setColorForText(textForAttribute: "\"\(model.assignment?.name ?? "an Assignment")\"", withColor: UIColor.navigationsGreen)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.course?.name ?? "a course")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.textColor = .navigationsWhite
        cell.titleLabel.font = UIFont.subheader
        cell.titleLabel.attributedText = titleString
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        let gradeText = "\(model.previousScore?.scoreText ?? "N/A")"
        cell.gradeLabel.textColor = .tableViewLightGrey
        cell.gradeLabel.font = UIFont.standard
        cell.gradeLabel.text = gradeText
        
        
        let grade2Text = "\(model.newScore?.scoreText ?? "N/A")"
        cell.gradeTwoLabel.textColor = .tableViewLightGrey
        cell.gradeTwoLabel.font = UIFont.standard
        cell.gradeTwoLabel.text = grade2Text
        
        cell.addSubviews(views: [cell.titleLabel, cell.gradeLabel, cell.gradeTwoLabel, cell.downArrow, ])
        
        cell.titleLabel.anchors(top: cell.divider.bottomAnchor, topPad: 6, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -9)
        
        
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 9, centerX: cell.background.centerXAnchor)
        
        cell.downArrow.anchors(top: cell.gradeLabel.bottomAnchor, topPad: 3, centerX: cell.background.centerXAnchor, width: 24, height: 24)
        
        cell.gradeTwoLabel.anchors(top: cell.downArrow.bottomAnchor, topPad: 3, bottom: cell.background.bottomAnchor, bottomPad: -12, centerX: cell.background.centerXAnchor)
        
        return cell
    }
    
    func upcomingAssignment(cell: PlannerCell, model: PlannerCard, manager: PlannerCellManager) -> PlannerCell {
        
        let titleText = "\(model.assignment?.name ?? "an Assignment") is coming up soon"
        let titleString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.name ?? "an Assignment")", withColor: UIColor.navigationsGreen)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.course?.name ?? "a course")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.textColor = .navigationsWhite
        cell.titleLabel.font = UIFont.subheader
        cell.titleLabel.attributedText = titleString
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        cell.addSubviews(views: [cell.titleLabel])
        
        cell.titleLabel.anchors(top: cell.divider.bottomAnchor, topPad: 16, bottom: cell.background.bottomAnchor, bottomPad: -16, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -9)
        
        return cell
    }

}
