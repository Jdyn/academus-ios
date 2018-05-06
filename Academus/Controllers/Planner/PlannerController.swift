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

class PlannerController: UITableViewController, PlannerCardDelegate, getStatusDelegate, UIViewControllerPreviewingDelegate {

    let plannerService = PlannerService()
    let statusService = StatusService()
    var statusButton: UIBarButtonItem?
    var severityColor: UIColor?
    
    var cards = [PlannerCard]()
    var components = [ComponentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        fetchCards { _ in UIView.transition(with: self.tableView,duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { self.tableView.reloadData(); DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: { if self.traitCollection.forceTouchCapability == .available { self.guidedTutorial() }})})}
        
        statusService.statusDelegate = self
        statusAlert()
    }

    func didGetStatus(components: [ComponentModel]) {
        self.components = components
        
        let testStatus1 = ComponentModel(id: 0, name: "StudentVUE", description: nil, link: nil, status: 3, order: nil, groupId: nil, createdAt: nil, updatedAt: nil, deletedAt: nil, enabled: true, statusName: "Power Outage")
        self.components.append(testStatus1)
        
        let max = self.components.max { ($0.status ?? 0) < ($1.status ?? 0)}
        let severity = max?.status
        switch severity {
        case 2: severityColor = UIColor().HexToUIColor(hex: "#EF6C00")
        case 3: severityColor = UIColor().HexToUIColor(hex: "#EF6C00")
        case 4: severityColor = .navigationsRed
        default: severityColor = .navigationsRed
        }
    }
    
    func statusAlert() {
        statusService.getStatus { (success) in
            if success {
                self.checkForStatus()
            }
        }
    }
    
    func checkForStatus() {
        let filtered = self.components.filter({ $0.status == 3 || $0.status == 4 })
        
        if filtered.isEmpty {
            navigationItem.rightBarButtonItem = nil
            tableView.tableHeaderView = nil
        } else {
            let statusDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_STATUS)
            if !(statusDictionary?[isShowing] as? Bool == true) {
                let max = filtered.max { ($0.status ?? 0) < ($1.status ?? 0)}
                
                guard
                    let name = max?.name,
                    let statusName = max?.statusName,
                    let status = max?.status
                    else { tableView.tableHeaderView = nil; return }
                
                let message = (filtered.count > 1) ? "\(filtered.count) System Outages" : "\(name): \(statusName)"
                
                tableView.tableHeaderView = statusBarHeaderView(message: message, severity: status, selector: #selector(handleStatusAlert), cancel: #selector(cancelStatusAlert))
            } else {
                tableView.tableHeaderView = nil
                
                statusButton = UIBarButtonItem(image: #imageLiteral(resourceName: "status"), style: .plain, target: self, action: #selector(self.handleStatusAlert))
                statusButton?.tintColor = severityColor
                navigationItem.rightBarButtonItem = statusButton
            }
        }
        
        tableView.reloadData()
    }
    
    @objc func handleStatusAlert() {
        let statusDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_STATUS)
        do {
            if statusDictionary?[isShowing] as? Bool == true {
                try Locksmith.updateData(data: [isShowing : false], forUserAccount: USER_STATUS)
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.navigationItem.rightBarButtonItem = nil
                    self.checkForStatus()
                })
            } else {
                try Locksmith.updateData(data: [isShowing : true], forUserAccount: USER_STATUS)
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.navigationItem.rightBarButtonItem = self.statusButton
                    self.tableView.tableHeaderView = nil
                })
                
                statusPage()
            }
        } catch {
            return
        }
    }
    
    @objc func cancelStatusAlert() {
        do {
            try Locksmith.updateData(data: [isShowing : true], forUserAccount: USER_STATUS)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.navigationItem.rightBarButtonItem = self.statusButton
                self.tableView.tableHeaderView = nil
            })
        } catch {
            return
        }
    }
    
    func guidedTutorial() {
        guard UserDefaults.standard.bool(forKey: "PlannerOpened") != true else { return }
        guard !tableView.visibleCells.isEmpty else { return }
        guard let first = tableView.visibleCells.first else { return }
        guard let firstCard = first as? PlannerCell else { return }
        
        UserDefaults.standard.set(true, forKey: "PlannerOpened")
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: firstCard.background)
        showcase.primaryText = "Hey, try pressing harder on stuff around the app."
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
                completion(true)
            } else {
                completion(false)
                self.errorLabel(show: true)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cards.count == 0 {
            self.tableViewEmptyLabel(message: "", show: true)
        } else {
            self.tableViewEmptyLabel(show: false)
        }
        return 1
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
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = previewingContext.sourceView as? PlannerCell,
              let indexPath = tableView.indexPath(for: cell)
              else { return nil }
        
        let frame = cell.colorView.frame.union(cell.background.frame)
        previewingContext.sourceRect = frame
        
        switch cards[indexPath.row].type {
        case "assignment_posted", "assignment_updated":
            let assignmentDetailController = AssignmentDetailController(style: .grouped)
            assignmentDetailController.assignment = cards[indexPath.row].assignment
            assignmentDetailController.card = cards[indexPath.row]
            return assignmentDetailController
        case "course_updated":
            let courseDetailsController = CourseDetailsController(style: .grouped)
            courseDetailsController.barbutton = false
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
                        self.statusAlert()
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
    
extension PlannerController { // TABLEVIEW FUNCTIONS
    
    func setupUI() {
        navigationItem.title = "Planner"
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200.0
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        tableView.showsVerticalScrollIndicator = false
        
        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: "course_updated")
        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: "assignment_posted")
        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: "assignment_updated")
        self.tableView.register(PlannerCell.self, forCellReuseIdentifier: "upcoming_assignment")
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 6  }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cards[indexPath.row].type {
        case "assignment_updated", "assignment_posted", "upcoming_assignment":
            let assignmentDetailController = AssignmentDetailController(style: .grouped)
            assignmentDetailController.navigationItem.title = cards[indexPath.row].assignment?.name
            assignmentDetailController.assignment = cards[indexPath.row].assignment
            assignmentDetailController.card = cards[indexPath.row]
            navigationController?.pushViewController(assignmentDetailController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case "course_updated":
            let courseDetailsController = CourseDetailsController(style: .grouped)
            courseDetailsController.barbutton = false
            courseDetailsController.navigationItem.title = cards[indexPath.row].course?.name
            courseDetailsController.course = cards[indexPath.row].course
            courseDetailsController.courseID = cards[indexPath.row].course?.id
            navigationController?.pushViewController(courseDetailsController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        default: break
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlannerCell {
        
        let model = cards[indexPath.row]
        let type = cards[indexPath.row].type
        
        let cell = tableView.dequeueReusableCell(withIdentifier: type!, for: indexPath) as! PlannerCell
        cell.setup(type: model.type!, createdDate: model.date!)
        
        registerForPreviewing(with: self, sourceView: cell)
        
        switch type {
        case "course_updated": return courseUpdatedCell(cell: cell, model: model)
        case "assignment_posted": return assignmentPostedCell(cell: cell, model: model)
        case "assignment_updated": return assignmentUpdatedCell(cell: cell, model: model)
        case "upcoming_assignment": return upcomingAssignment(cell: cell, model: model)
        default: return PlannerCell()
        }
    }
}

extension PlannerController {
    
    func courseUpdatedCell(cell: PlannerCell, model: PlannerCard) -> PlannerCell {
        
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
        
        cell.background.addSubviews(views: [cell.titleLabel, cell.gradeLabel, cell.stack])
        
        cell.stack.anchors(top: cell.gradeLabel.bottomAnchor, bottom: cell.subBackground.bottomAnchor, left: cell.subBackground.leftAnchor, right: cell.subBackground.rightAnchor)
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 6, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 16, bottom: cell.subBackground.bottomAnchor, bottomPad: -12, left: cell.subBackground.leftAnchor, leftPad: 12)
        
        return cell
    }
    
    func assignmentPostedCell(cell: PlannerCell, model: PlannerCard) -> PlannerCell {
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
        
        cell.background.addSubviews(views: [cell.titleLabel, cell.gradeLabel])
        
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 6, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 12, bottom: cell.background.bottomAnchor, bottomPad: -12, left: cell.background.leftAnchor, leftPad: 12, right: cell.background.rightAnchor, rightPad: -12)
        return cell
    }
    
    func assignmentUpdatedCell(cell: PlannerCell, model: PlannerCard) -> PlannerCell {

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
        
        cell.background.addSubviews(views: [cell.titleLabel, cell.gradeLabel, cell.gradeTwoLabel, cell.downArrow])
        
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 6, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        cell.gradeLabel.anchors(top: cell.titleLabel.bottomAnchor, topPad: 9, centerX: cell.background.centerXAnchor)
        cell.downArrow.anchors(top: cell.gradeLabel.bottomAnchor, topPad: 0, centerX: cell.background.centerXAnchor, width: 26, height: 26)
        cell.gradeTwoLabel.anchors(top: cell.downArrow.bottomAnchor, topPad: 0, bottom: cell.background.bottomAnchor, bottomPad: -12, centerX: cell.background.centerXAnchor)
        
        return cell
    }
    
    func upcomingAssignment(cell: PlannerCell, model: PlannerCard) -> PlannerCell {
        
        let titleText = "\(model.assignment?.name ?? "an Assignment") is coming up soon"
        let titleString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.name ?? "an Assignment")", withColor: UIColor.navigationsGreen)
        titleString.setColorForText(textForAttribute: "\(model.assignment?.course?.name ?? "a course")", withColor: UIColor.navigationsGreen)
        cell.titleLabel.attributedText = titleString
        
        cell.background.addSubviews(views: [cell.titleLabel])
        
        cell.titleLabel.anchors(top: cell.subBackground.topAnchor, topPad: 16, bottom: cell.subBackground.bottomAnchor, bottomPad: -16, left: cell.subBackground.leftAnchor, leftPad: 12, right: cell.subBackground.rightAnchor, rightPad: -12)
        
        return cell
    }
}
