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
                self.tableView.tableHeaderView = self.header()
            }
        }
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(ManageInvitesCell.self, forCellReuseIdentifier: cellID)
    }
    
    func header() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let counter = UILabel().setUpLabel(text: "", font: UIFont.UISubtext!, fontColor: .navigationsWhite)
        
        if self.invitesLeft == 0 {
            counter.text! = "You've run out of invites! Thank you!"
        } else if self.invitesLeft == 1 {
            counter.text! = "You have \(self.invitesLeft) more invite to use!"
        } else {
            counter.text! = "You have \(self.invitesLeft) more invites to use!"
        }
        
        header.addSubviews(views: [background, counter])
        
        background.anchors(top: header.topAnchor, topPad: 0, bottom: header.bottomAnchor, bottomPad: 0, left: header.leftAnchor, leftPad: 6, right: header.rightAnchor, rightPad: -6, width: 0, height: 0)
        counter.anchors(centerX: background.centerXAnchor, centerY: background.centerYAnchor)
        return header
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
    
    func didGetInvites(invites: [Invite], invitesLeft: Int) {
        self.invites.removeAll()
        for invite in invites {
            self.invites.append(invite)
        }
        self.invitesLeft = invitesLeft
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ManageInvitesCell {
            if indexPath.section == 0 {
                let invitesFiltered = invites.filter { $0.redeemed == false }
                cell.invite = invitesFiltered[indexPath.row]
                let button = shareButton(type: .system)
                button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
                button.tintColor = .tableViewLightGrey
                button.inviteCode = cell.invite?.code!
                button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
                cell.addSubview(button)
                button.anchors(right: cell.background.rightAnchor, rightPad: -12, centerY: cell.background.centerYAnchor, width: 32, height: 32)
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
    
    @objc func buttonClicked(_ sender: shareButton) {
        guard let code = sender.inviteCode else {return}
        let message = "Hey, Try out Academus on the app store. Get notified when your grades change and more. Use this code: \(code)"
        let objectsToShare = [message] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
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
