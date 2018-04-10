//
//  PlannerController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import UserNotifications
import Locksmith
import CoreData

class PlannerController: UITableViewController, CreateReminderCardDelegate, UIGestureRecognizerDelegate {
    
    var cards = [PlannerCards]()
    private let cellID = "PlannerCardCell"
    
    var movingCell: UITableViewCell?
    var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewDarkGrey
        tableView.register(PlannerCardCell.self, forCellReuseIdentifier: cellID)
        setupAddButtonInNavBar(selector: #selector(handleAddCard))
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
//        self.fetchPlannerCards()
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        leftRecognizer.direction = .left
        leftRecognizer.delegate = self
        //leftRecognizer.require(toFail: tableView.gestureRecognizers![0])
        tableView.addGestureRecognizer(leftRecognizer)
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        rightRecognizer.direction = .left
        rightRecognizer.delegate = self
        //rightRecognizer.require(toFail: tableView.gestureRecognizers![0])
        tableView.addGestureRecognizer(rightRecognizer)
        
//        LocalNotificationService().setLocalNotification(title: "title", body: "body", sound: .default(), timeInterval: 5, repeats: false, indentifier: "test")
        
    }
    
    func didAddCard(card: PlannerReminderCard) {
        cards.append(plannerCard(from: card))
        let newIndexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .top)
        print("did add card: ", cards.count)
    }
    
    private func fetchPlannerCards() {
        self.cards.removeAll()
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let plannerRequest = NSFetchRequest<PlannerCards>(entityName: "PlannerCards")
        
        do {
            let cards = try context.fetch(plannerRequest)
            self.cards = cards
            
            cards.forEach({ (card) in
                print("fetch planner card call", card.name)
            })
            
        } catch let error {
            print("Failed to fetch planner cards:", error)
        }
    }
    
    @objc func handleAddCard() {
        let createCardController = PlannerCreateCardController()
        let navController = MainNavigationController(rootViewController: createCardController)
        createCardController.delegate = self
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func errorLabel(show: Bool) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)).setUpLabel(text: "Oops... :( \nCreate some cards or comeback later", font: UIFont.UIStandard!, fontColor: .navigationsLightGrey )
        label.textAlignment = .center
        label.numberOfLines = 0
        if show {
            self.tableView.backgroundView = label
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cards.count == 0 {
            errorLabel(show: true)
        } else {
            errorLabel(show: false)
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlannerCardCell
        
        cell.card = self.cards[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 150 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 9 }
    
    @objc func didSwipeLeft(recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            if let indexPath = tableView.indexPathForRow(at: recognizer.location(in: view)) {
                let cell = tableView(tableView, cellForRowAt: indexPath)
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                if let plannerCardCell = cell as? PlannerCardCell {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                        plannerCardCell.background.backgroundColor = UIColor.blend(colors: [.navigationsRed, .tableViewMediumGrey])
                    }, completion: { _ in
                        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
                        context.delete(self.cards[indexPath.row] as NSManagedObject)
                        self.cards.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                        do {
                            try context.save()
                        } catch let error {
                            print(error)
                        }
                        print(self.cards.count)
                    })
                }
            }
        }
    }
    
    @objc func didSwipeRight(recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            if let indexPath = tableView.indexPathForRow(at: recognizer.location(in: view)) {
                let cell = tableView(tableView, cellForRowAt: indexPath)
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                cell.transform = CGAffineTransform(scaleX: 0.4, y: 1)
                UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
                    cell.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    @objc func refreshTable() {
        fetchPlannerCards()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
            self.refreshControl?.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                self.tableView.reloadData()
            })
        })
    }
    
    func plannerCard(from card: PlannerReminderCard) -> PlannerCards {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let plannerCard = NSEntityDescription.insertNewObject(forEntityName: "PlannerCards", into: context) as! PlannerCards
        plannerCard.name = card.title
        plannerCard.plannerReminder = card
        return plannerCard
    }
}
