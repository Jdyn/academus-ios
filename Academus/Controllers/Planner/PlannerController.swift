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
import MaterialShowcase

    class PlannerController: UITableViewController, PlannerCardDelegate, UIViewControllerPreviewingDelegate {
        
    var cards = [PlannerCard]()
    var plannerService = PlannerService()
    var cells: [PlannerCellManager] = [PlannerCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewDarkGrey
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        registerForPreviewing(with: self, sourceView: tableView)
        tableView.showsVerticalScrollIndicator = false

//        setupAddButtonInNavBar(selector: #selector(addPlannerCard))
//        setupChatButtonInNavBar()
                
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        cells = [.assignmentPostedCard, .assignmentUpdatedCard, .courseUpdatedCard, .upcomingAssignmentCard]
        
        cells.forEach { (cell) in
            self.tableView.register(PlannerCell.self, forCellReuseIdentifier: cell.getType())
        }
        
        cells = []
        plannerService.delegate = self
        plannerService.getPlannerCards { (success) in
            if success {
                self.cards.forEach({ (card) in
                    if card.type == "course_updated" {
                        self.cells.append(.courseUpdatedCard)
                    } else if card.type == "assignment_posted" {
                        self.cells.append(.assignmentPostedCard)
                    } else if card.type == "assignment_updated" {
                        self.cells.append(.assignmentUpdatedCard)
                    } else if card.type == "upcoming_assignment" {
                        self.cells.append(.upcomingAssignmentCard)
                    }
                })
                UIView.transition(with: self.tableView,duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                })
            } else {
                self.errorLabel(show: true)
            }
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200.0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            guidedTutorial()
        }
        
    func guidedTutorial() {
        guard UserDefaults.standard.bool(forKey: "PlannerOpened") != true else { return }
        guard !tableView.visibleCells.isEmpty else { return }
        guard let first = tableView.visibleCells.first else { return }
        guard let firstCourse = first as? PlannerCell else { return }
        
        UserDefaults.standard.set(true, forKey: "PlannerOpened")
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: firstCourse)
        showcase.primaryText = "Have an iPhone 6s or better? Try pressing harder on stuff around the app."
        showcase.secondaryText = ""
        showcase.shouldSetTintColor = false
        showcase.targetHolderColor = .clear
        showcase.targetHolderRadius = 0
        showcase.backgroundPromptColor = .navigationsDarkGrey
        showcase.backgroundPromptColorAlpha = 0.9
        showcase.show(animated: true, completion: nil)
    }
    
    func didGetPlannerCards(cards: [PlannerCard]) {
        self.cards.removeAll()
        for card in cards {
            self.cards.append(card)
        }
    }
    
    func fetchCards(completion: @escaping CompletionHandler) {
        plannerService.delegate = self
        plannerService.getPlannerCards { (success) in
            if success {
//                self.cells.removeAll()
                self.cards.forEach({ (card) in
                    if card.type == "course_updated" {
                        self.cells.append(.courseUpdatedCard)
                    } else if card.type == "assignment_posted" {
                        self.cells.append(.assignmentPostedCard)
                    } else if card.type == "assignment_updated" {
                        self.cells.append(.assignmentUpdatedCard)
                    } else if card.type == "upcoming_assignment" {
                        self.cells.append(.upcomingAssignmentCard)
                    }
                })
                completion(true)
            } else {
                completion(false)
                self.errorLabel(show: true)
            }
        }
    }
    
    @objc func addPlannerCard() {
        let createController = MainNavigationController(rootViewController: CardCreationController())
        navigationController?.present(createController, animated: true, completion: {
            // COMPLETION CODE HERE
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
    
        let cell = tableView.dequeueReusableCell(withIdentifier: manager.getType(), for: indexPath) as! PlannerCell
        cell.setup(type: manager.getTitle(), createdDate: (model.date)!, color: manager.getColor())
                
        switch manager {
        case .courseUpdatedCard: return courseUpdatedCell(cell: cell, model: model, manager: manager) //cell.assignments = model.affectingAssignments!; 
        case .assignmentPostedCard: return assignmentPostedCell(cell: cell, model: model, manager: manager)
        case .assignmentUpdatedCard: return assignmentUpdatedCell(cell: cell, model: model, manager: manager)
        case .upcomingAssignmentCard: return upcomingAssignment(cell: cell, model: model, manager: manager)
        }
    }
    
    func errorLabel(show: Bool) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)).setUpLabel(text: "Oops... :( \nCheck your Internet connection \nand refresh", font: UIFont.standard!, fontColor: .navigationsLightGrey)
        label.textAlignment = .center
        label.numberOfLines = 0
        if show {
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 6  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .assignmentUpdatedCard, .assignmentPostedCard:
            let assignmentDetailController = AssignmentDetailController()
            assignmentDetailController.navigationItem.title = cards[indexPath.row].assignment?.name
            assignmentDetailController.assignment = cards[indexPath.row].assignment
            assignmentDetailController.card = cards[indexPath.row]
            navigationController?.pushViewController(assignmentDetailController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case .courseUpdatedCard:
            let courseDetailsController = CourseDetailsController()
            courseDetailsController.barbutton = false
            courseDetailsController.navigationItem.title = cards[indexPath.row].course?.name
            courseDetailsController.course = cards[indexPath.row].course
            courseDetailsController.courseID = cards[indexPath.row].course?.id
            navigationController?.pushViewController(courseDetailsController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        default: break
        }
    }
        
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard
            let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? PlannerCell
            else {
                return nil
        }
        
        previewingContext.sourceRect = cell.frame
        
        switch cells[indexPath.row] {
        case .assignmentPostedCard, .assignmentUpdatedCard:
            let assignmentDetailController = AssignmentDetailController()
            assignmentDetailController.assignment = cards[indexPath.row].assignment
            assignmentDetailController.card = cards[indexPath.row]
            return assignmentDetailController
        case .courseUpdatedCard:
            let courseDetailsController = CourseDetailsController()
            courseDetailsController.navigationItem.title = cards[indexPath.row].course?.name
            courseDetailsController.course = cards[indexPath.row].course
            courseDetailsController.courseID = cards[indexPath.row].course?.id
            return courseDetailsController
        default: return UIViewController()
        }
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        viewControllerToCommit.navigationItem.rightBarButtonItem?.isEnabled = false
        viewControllerToCommit.navigationItem.rightBarButtonItem?.tintColor = .clear
        show(viewControllerToCommit, sender: self)
    }
    
    @objc func refreshTable() {
        fetchCards { (success) in
            if success {
                self.errorLabel(show: false)
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (time) in
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                        self.tableView.reloadData()
                    })
                })
            } else {
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (time) in
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                        self.alertMessage(title: "Could not refresh :(", message: "Check your internet connection and try again")
                    })
                })
            }
        }
    }
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
        
        let currentGradeText = (model.newGrade?.gradePercent != nil) ? "\(currentGrade)%" : "N/A"
        let previousGradeText = (model.previousGrade?.gradePercent != nil) ? "\(previousGrade)%" : "N/A"
        
        let gradeText = "Grade: \(previousGradeText) → \(currentGradeText)"
        let gradeString = NSMutableAttributedString(string: gradeText)
        gradeString.setColorForText(textForAttribute: "\(previousGradeText)", withColor: previousGradeColor)
        gradeString.setColorForText(textForAttribute: "\(currentGradeText)", withColor: currentGradeColor)

        cell.gradeLabel.textColor = .tableViewLightGrey
        cell.gradeLabel.attributedText = gradeString
        
        let courseTitle = "Your grade in \((model.course?.name) ?? "a course") has been updated"
        let courseNameString: NSMutableAttributedString = NSMutableAttributedString(string: courseTitle)
        courseNameString.setColorForText(textForAttribute: "\((model.course?.name) ?? "unknown")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.attributedText = courseNameString
        
//        print(cell.buttons.count)
        
//        cell.buttons.forEach { (button) in
//            cell.addSubview(button)
//            cell.stack.addArrangedSubview(button)
//
//        }
        
        cell.addSubviews(views: [cell.titleLabel, cell.gradeLabel, cell.stack])
        
        cell.stack.anchors(top: cell.gradeLabel.bottomAnchor, bottom: cell.subBackground.bottomAnchor, left: cell.subBackground.leftAnchor, right: cell.subBackground.rightAnchor)
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 6, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 16, bottom: cell.subBackground.bottomAnchor, bottomPad: -12, left: cell.subBackground.leftAnchor, leftPad: 12)
        
        return cell
    }
    
    func assignmentPostedCell(cell: PlannerCell, model: PlannerCard, manager: PlannerCellManager) -> PlannerCell {
        
        let titleText = "\"\((model.assignment?.name) ?? "Assignment")\" has been posted in \(model.assignment?.course?.name ?? "a course")"
        let titleString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)
        titleString.setColorForText(textForAttribute: "\"\(model.assignment?.name ?? "An assignment")\"", withColor: UIColor.navigationsGreen)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.course?.name ?? "a course")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.attributedText = titleString

        let gradeText = "Grade: \(model.assignment?.score?.text ?? "N/A")"
        let gradeString: NSMutableAttributedString = NSMutableAttributedString(string: gradeText)
        gradeString.setColorForText(textForAttribute: "\(model.assignment?.score?.text ?? "N/A")", withColor: .navigationsWhite)
        cell.gradeLabel.textColor = .tableViewLightGrey
        cell.gradeLabel.attributedText = gradeString
        
        cell.addSubviews(views: [cell.titleLabel, cell.gradeLabel])
        
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 6, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 12, bottom: cell.background.bottomAnchor, bottomPad: -12, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -12)
        return cell
    }
    
    func assignmentUpdatedCell(cell: PlannerCell, model: PlannerCard, manager: PlannerCellManager) -> PlannerCell {

        let titleText = "Your grade on \"\(model.assignment?.name ?? "an Assignment")\" in \(model.assignment?.course?.name ?? "a course") has been updated"
        let titleString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)
        titleString.setColorForText(textForAttribute: "\"\(model.assignment?.name ?? "an Assignment")\"", withColor: UIColor.navigationsGreen)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.course?.name ?? "a course")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.attributedText = titleString

        let gradeText = "\(model.previousScore?.scoreText ?? "N/A")"
        cell.gradeLabel.textColor = .tableViewLightGrey
        cell.gradeLabel.text = gradeText
        
        let grade2Text = "\(model.newScore?.scoreText ?? "N/A")"
        cell.gradeTwoLabel.textColor = .tableViewLightGrey
        cell.gradeTwoLabel.text = grade2Text
        
        cell.addSubviews(views: [cell.titleLabel, cell.gradeLabel, cell.gradeTwoLabel, cell.downArrow, ])
        
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 6, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 9, centerX: cell.background.centerXAnchor)
        cell.downArrow.anchors(top: cell.gradeLabel.bottomAnchor, topPad: 0, centerX: cell.background.centerXAnchor, width: 26, height: 26)
        cell.gradeTwoLabel.anchors(top: cell.downArrow.bottomAnchor, topPad: 0, bottom: cell.background.bottomAnchor, bottomPad: -12, centerX: cell.background.centerXAnchor)
        
        return cell
    }
    
    func upcomingAssignment(cell: PlannerCell, model: PlannerCard, manager: PlannerCellManager) -> PlannerCell {
        
        let titleText = "\(model.assignment?.name ?? "an Assignment") is coming up soon"
        let titleString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.name ?? "an Assignment")", withColor: UIColor.navigationsGreen)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.course?.name ?? "a course")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.attributedText = titleString
        
        cell.addSubviews(views: [cell.titleLabel])
        
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 16, bottom: cell.subBackground.bottomAnchor, bottomPad: -16, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        
        return cell
    }

}
