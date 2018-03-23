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

class PlannerController: UITableViewController, CreateCardDelegate, CreateReminderCardDelegate {
    
    var cards = [PlannerCards]()
    private let cellID = "PlannerCardCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewGrey
        tableView.register(PlannerCardCell.self, forCellReuseIdentifier: cellID)
        setupAddButtonInNavBar(selector: #selector(handleAddCard))
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
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
    
    func didAddCard(card: PlannerCards) {
        cards.append(card)
        let newIndexPath = IndexPath(row: cards.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didAddCard(card: PlannerReminderCard) {
        cards.append(plannerCard(from: card))
        let newIndexPath = IndexPath(row: cards.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    private func fetchPlannerCards() {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let plannerRequest = NSFetchRequest<PlannerCards>(entityName: "PlannerCards")
        // let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlannerCard")
        // let delete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
        do {
            
            let cards = try context.fetch(plannerRequest)
            // try context.execute(delete)
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
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let view = UIView()
    //        view.backgroundColor = .tableViewGrey
    //        let headerLabel = UILabel()
    //        headerLabel.setUpLabel(text: "Main Feed", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
    //        headerLabel.textAlignment = .center
    //        view.addSubview(headerLabel)
    //        headerLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 0)
    //        return view
    //    }
    //
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "HEADER"
    //    }
    //
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 35
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlannerCardCell
        
        cell.backgroundColor = .tableViewGrey
        
        let cards = self.cards[indexPath.row]
        cell.card = cards
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
            context.delete(cards[indexPath.row] as NSManagedObject)
            cards.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager().saveContext()
        }
    }
    
    func plannerCard(from card: PlannerReminderCard) -> PlannerCards {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let plannerCard = NSEntityDescription.insertNewObject(forEntityName: "PlannerCards", into: context) as! PlannerCards
        plannerCard.name = card.title
        plannerCard.plannerReminder = card
        CoreDataManager().saveContext()
        return plannerCard
    }
}
