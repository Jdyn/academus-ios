//
//  ManageInvitesController.swift
//  Academus
//
//  Created by Jaden Moore on 3/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageInvitesController: UITableViewController, userInvitesDelegate {
    
    private let invitesService = InvitesService()
    var invites = [Invite]()
    let cellID = "userInvitesCell"
    var invitesLeft: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage Invites"
        view.backgroundColor = .tableViewDarkGrey
        invitesService.delegate = self
        invitesService.getInvites { (success) in
            if success {
                self.tableView.reloadData()
                if self.invitesLeft != 0 {
                    self.setupAddButtonInNavBar(selector: #selector(self.handleAddInvite))
                }
            }
        }
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(ManageInvitesCell.self, forCellReuseIdentifier: cellID)
    }
    
    @objc func handleAddInvite() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to generate a beta code?", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.invitesService.addInvite { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.alertMessage(title: "Alert", message: "Failed to add beta code")
                }
            }
        }
        
        let actionNo = UIAlertAction(title: "No", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
    
    func didGetInvites(invites: [Invite]) {
        self.invites.removeAll()
        for invite in invites {
            self.invites.append(invite)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ManageInvitesCell {
            if indexPath.section == 0 {
                let invitesFiltered = invites.filter { $0.redeemed == false }
                cell.invite = invitesFiltered[indexPath.row]
                return cell
            }
            if indexPath.section == 1 {
                let invitesFiltered = invites.filter { $0.redeemed == true }
                cell.invite = invitesFiltered[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let invitesFiltered = invites.filter { $0.redeemed == false }
            return invitesFiltered.count
        }
        if section == 1 {
            let invitesFiltered = invites.filter { $0.redeemed == true }
            return invitesFiltered.count
        } else {
            return 0
        }
    }
}
