//
//  PlannerController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith
import CoreData

class PlannerController: UITableViewController, CreateCardDelegate {
    
    var cards = [PlannerCards]()
    private let cellID = "PlannerCardCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewGrey
        tableView.register(PlannerCardCell.self, forCellReuseIdentifier: cellID)
        setupAddButtonInNavBar(selector: #selector(handleAddCard))
        tableView.separatorStyle = .none
        tableView.separatorColor = .tableViewSeperator
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        fetchPlannerCards()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleLogOut))
    }
    
    func didAddCard(card: PlannerCards) {
        cards.append(card)
        let newIndexPath = IndexPath(row: cards.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    private func fetchPlannerCards() {
    
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PlannerCards>(entityName: "PlannerCards")
//        let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlannerCard")
//        let delete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
        do {
            let cards = try context.fetch(fetchRequest)
//            try context.execute(delete)
            cards.forEach({ (card) in
                print(card.name ?? "")
            })
            
            self.cards = cards
            self.tableView.reloadData()
            
        } catch let error {
            print("Failed to fetch cards:", error)
        }
    
    }
    

    @objc func handleLogOut() {
        if Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) != nil {
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH)
            } catch let error {
                debugPrint("could not delete locksmith data:", error)
            }
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: true, completion: nil)
        } else {
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: true, completion: nil)
        }
    }
    
    @objc func handleAddCard() {
        let createCardController = PlannerCreateCardController()
        let navController = MainNavigationController(rootViewController: createCardController)
        createCardController.delegate = self
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .tableViewGrey
        let headerLabel = UILabel()
        headerLabel.setUpLabel(text: "Main Feed", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        headerLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 0)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
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
}
