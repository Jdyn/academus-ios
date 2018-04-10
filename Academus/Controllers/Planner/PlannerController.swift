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
    var showLabel: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewDarkGrey
        tableView.register(PlannerCardCell.self, forCellReuseIdentifier: cellID)
        setupAddButtonInNavBar(selector: #selector(handleAddCard))
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
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
        
        DispatchQueue.global(qos: .background).async {
            print("Fetching cards on background thread")
            self.fetchPlannerCards()
            
            DispatchQueue.main.async {
                print("We finished that.")
                self.tableView.reloadData()
            }
        }
//        tableView.tableHeaderView = profile
        
//        LocalNotificationService().setLocalNotification(title: "title", body: "body", sound: .default(), timeInterval: 5, repeats: false, indentifier: "test")
        
    }
    
    
    
    func didAddCard(card: PlannerReminderCard) {
        cards.append(plannerCard(from: card))
        let newIndexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        CoreDataManager().saveContext()
    }
    
    private func fetchPlannerCards() {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let plannerRequest = NSFetchRequest<PlannerCards>(entityName: "PlannerCards")
        do {
            let cards = try context.fetch(plannerRequest)
            self.cards = cards
            showLabel = false
        } catch let error {
            showLabel = true
            print("Failed to fetch planner cards:", error)
        }
    }
    
    @objc func handleAddCard() {
        let createCardController = PlannerCreateCardController()
        let navController = MainNavigationController(rootViewController: createCardController)
        createCardController.delegate = self
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if showLabel == true {
            if cards.count == 0 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)).setUpLabel(text: "No Cards Available", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
                label.textAlignment = .center
                self.tableView.backgroundView = label
                return 0
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlannerCardCell
        
        cell.backgroundColor = .tableViewDarkGrey
        
        let cards = self.cards[indexPath.row]
        cell.card = cards
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 150 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    
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
                        CoreDataManager().saveContext()
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
