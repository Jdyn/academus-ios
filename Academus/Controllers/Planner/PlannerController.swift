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
    var gestureStartLocation: CGPoint?
    var label: UILabel?
    
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
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didSwipe))
        recognizer.delegate = self
        recognizer.require(toFail: tableView.gestureRecognizers![0])
        tableView.addGestureRecognizer(recognizer)
        
        DispatchQueue.global(qos: .background).async {
            print("Fetching cards on background thread")
            self.fetchPlannerCards()
            
            DispatchQueue.main.async {
                print("We finished that.")
                self.tableView.reloadData()
            }
        }
        
//        LocalNotificationManager().setUpNotifications(title: "title", body: "body", sound: .default(), timeInterval: 5, repeats: false, indentifier: "test")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlannerCardCell
        
        cell.backgroundColor = .tableViewDarkGrey
        
        let cards = self.cards[indexPath.row]
        cell.card = cards
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard cards.count == 0 else {
            if let obj = label {
                obj.removeFromSuperview()
            }
            return cards.count
        }
        
        label = UILabel().setUpLabel(text: "No Cards Found, Make One!", font: UIFont.UIStandard!, fontColor: .navigationsLightGrey)
        label!.textAlignment = .center
        view.addSubview(label!)
        label!.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        
        return 0
    }
    
    @objc func didSwipe(recognizer: UIPanGestureRecognizer) {
        let swipeLocation = recognizer.location(in: self.tableView)
        let translation = recognizer.translation(in: self.view)
        if let cell = movingCell {
            cell.center = CGPoint(x: cell.center.x + translation.x, y: cell.center.y)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            if abs(cell.center.x - self.view.center.x) > 20 {
                self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                if let indexPath = tableView.indexPathForRow(at: swipeLocation) {
                    self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                }
                
                if let swipeStart = gestureStartLocation {
                    if abs(cell.center.x - self.view.center.x) < abs(cell.center.y - swipeStart.y) {
                        recognizer.isEnabled = false
                        if let plannerCardCell = cell as? PlannerCardCell {
                            UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
                                cell.center.x = self.view.center.x
                                plannerCardCell.background.backgroundColor = .tableViewMediumGrey
                            }, completion: {_ in})
                        }
                        movingCell = nil
                        recognizer.isEnabled = true
                    }
                }
            }
            
            if cell.center.x < 0 {
                if let plannerCardCell = cell as? PlannerCardCell {
                    if plannerCardCell.background.backgroundColor == .tableViewMediumGrey {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                        plannerCardCell.background.backgroundColor = UIColor.blend(colors: [.navigationsRed, .tableViewMediumGrey])
                    }, completion: {_ in})
                }
            }
        }
        
        if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
            if recognizer.state == .began {
                gestureStartLocation = swipeLocation
                movingCell = tableView.cellForRow(at: swipedIndexPath)
            } else if recognizer.state == .ended {
                if let cell = movingCell {
                    if cell.center.x < 0 {
                        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
                        context.delete(cards[swipedIndexPath.row] as NSManagedObject)
                        cards.remove(at: swipedIndexPath.row)
                        self.tableView.scrollToRow(at: swipedIndexPath, at: .top, animated: true)
                        self.tableView.deleteRows(at: [swipedIndexPath], with: .left)
                        CoreDataManager().saveContext()
                    } else {
                        recognizer.isEnabled = false
                        if let plannerCardCell = cell as? PlannerCardCell {
                            UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
                                cell.center.x = self.view.center.x
                                plannerCardCell.background.backgroundColor = .tableViewMediumGrey
                            }, completion: {_ in})
                        }
                        self.tableView.scrollToRow(at: swipedIndexPath, at: .middle, animated: true)
                        recognizer.isEnabled = true
                    }
                }
                
                movingCell = nil
            }
        } else {
            if let cell = movingCell {
                recognizer.isEnabled = false
                if let plannerCardCell = cell as? PlannerCardCell {
                    UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
                        cell.center.x = self.view.center.x
                        plannerCardCell.background.backgroundColor = .tableViewMediumGrey
                    }, completion: {_ in})
                }
                movingCell = nil
                recognizer.isEnabled = true
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

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (movingCell == nil) ? true : false
    }
    
    func plannerCard(from card: PlannerReminderCard) -> PlannerCards {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let plannerCard = NSEntityDescription.insertNewObject(forEntityName: "PlannerCards", into: context) as! PlannerCards
        plannerCard.name = card.title
        plannerCard.plannerReminder = card
        return plannerCard
    }
}
