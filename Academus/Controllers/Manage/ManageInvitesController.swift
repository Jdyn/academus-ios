//
//  ManageInvitesController.swift
//  Academus
//
//  Created by Jaden Moore on 3/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageInvitesController: UITableViewController, userInvitesDelegate, userAddInviteDelegate {

    private let invitesService = InvitesService()
    var invites = [Invite]()
    var addedInvite: Invite?
    let id = "InviteCell"
    var invitesLeft: Int = 0
    var counter: UILabel = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsWhite)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Invite Friends"
        view.backgroundColor = .tableViewDarkGrey
        self.extendedLayoutIncludesOpaqueBars = true
        invitesService.inviteDelegate = self
        invitesService.getInvites { (success) in
            if success {
                self.tableView.reloadData()
                if self.invitesLeft != 0 {
                    self.setupAddButtonInNavBar(selector: #selector(self.handleAddInvite))
                }
                self.tableView.tableHeaderView = self.header()
                if self.invites.isEmpty {
                    self.tableViewEmptyLabel(message: "Hey! \nTap the add button to begin inviting your friends", show: true)
                } else {
                    self.tableViewEmptyLabel(show: false)
                }
            } else {
                self.tableViewEmptyLabel(message: "Oh no... :( \nCheck your internet connection and try again", show: true)
            }
        }
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)
    }
    
    func header() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 45))
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        
        if self.invitesLeft == 0 {
            counter.text! = "You've run out of invites! Thank you!"
        } else if self.invitesLeft == 1 {
            counter.text! = "You have \(self.invitesLeft) more invite to use!"
        } else {
            counter.text! = "You have \(self.invitesLeft) more invites to use!"
        }
        
        background.roundCorners(corners: .bottom)
        header.addSubviews(views: [background, counter])
        
        background.anchors(top: header.topAnchor, topPad: 0, bottom: header.bottomAnchor, bottomPad: -9, left: header.leftAnchor, leftPad: 6, right: header.rightAnchor, rightPad: -6, width: 0, height: 0)
        counter.anchors(centerX: background.centerXAnchor, centerY: background.centerYAnchor)
        return header
    }
    
    @objc func handleAddInvite() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to generate a beta code?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.invitesService.addInviteDelegate = self
            self.invitesService.addInvite { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    let newIndexPath = IndexPath(row: 0, section: 0)
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                    self.invitesLeft -= 1
                    self.counter.text! = "You have \(self.invitesLeft) more invite to use!"
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
    
    func didAddInvite(invite: Invite) { self.invites.insert(invite, at: 0) }
    func didGetInvites(invites: [Invite], invitesLeft: Int) {
        print("delegate called")
        self.invites.removeAll()
        for invite in invites {
            self.invites.append(invite)
        }
        self.invitesLeft = invitesLeft
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
    
        if indexPath.section == 0 {
            let invitesFiltered = invites.filter { $0.redeemed == false }
            let invite = invitesFiltered[indexPath.row]
            return inviteCell(cell: cell, invite: invite)
        }
        
        if indexPath.section == 1 {
            let invitesFiltered = invites.filter { $0.redeemed == true }
            let invite = invitesFiltered[indexPath.row]
            return inviteCell(cell: cell, invite: invite)
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 9 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if invites.count > 0 {
            let view = UIView()
            let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
            background.roundCorners(corners: .top)
            
            view.addSubview(background)
            
            background.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
            return view
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 18 }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if invites.count > 0 {
            let view = UIView()
            let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
            background.roundCorners(corners: .bottom)
            
            view.addSubview(background)
            
            background.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -9, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
            return view

        }
        return UIView()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
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

extension ManageInvitesController {
    
    private func inviteCell(cell: UITableViewCell, invite: Invite) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let inviteCode = UILabel().setUpLabel(text: "Invite Code: \(invite.code ?? "Unknown")", font: UIFont.standard!, fontColor: .navigationsWhite)
        let redeemer = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
        
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = circle.frame.size.width / 2
        
        if invite.redeemed == false {
            circle.backgroundColor = .navigationsGreen
            redeemer.text! = "Code not used yet!"
        } else {
            let name = invite.redeemer_name
            redeemer.text! = "Code used by \(name ?? "Unknown")"
            circle.backgroundColor = .tableViewLightGrey
        }
        
        cell.addSubviews(views: [background, inviteCode, redeemer, circle])
        
        background.anchors(top: cell.topAnchor, topPad: 0, bottom: cell.bottomAnchor, bottomPad: 0, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        circle.anchors(left: background.leftAnchor, leftPad: 12, centerY: background.centerYAnchor, width: 12, height: 12)
        inviteCode.anchors(bottom: circle.centerYAnchor, bottomPad: 0, left: circle.rightAnchor, leftPad: 9)
        redeemer.anchors(top: circle.centerYAnchor, topPad: 0, left: circle.rightAnchor, leftPad: 9)
        
        if invite.redeemed == false {
            let button = shareButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
            button.tintColor = .tableViewLightGrey
            button.inviteCode = invite.code
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            cell.addSubview(button)
            button.anchors(right: background.rightAnchor, rightPad: -16, centerY: background.centerYAnchor, width: 32, height: 32)
        }
        
        return cell
    }
    
    @objc func buttonClicked(_ sender: shareButton) {
        guard let code = sender.inviteCode else {return}
        let message = "Hey, Try out Academus on the App Store. Get notified when your grades change and more. Use this code: \(code)"
        let objectsToShare = [message] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}
