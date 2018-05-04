//
//  ManageAboutController.swift
//  Academus
//
//  Created by Jaden Moore on 3/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageAboutController: UITableViewController {

    var cells = [AboutCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"
        tableView.separatorStyle = .none
        self.extendedLayoutIncludesOpaqueBars = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        cells = [.alamofire, .locksmith, .swiftyJson, .showcase, .charts]
        cells.forEach { (type) in
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type.getCellType())
        }
        tableView.tableHeaderView = headerView()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellAtIndex = cells[indexPath.row]
        let cellType = cellAtIndex.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        return aboutCell(c: cellAtIndex, cell: cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cells[indexPath.row]
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to open this link?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            UIApplication.shared.open(URL(string: cell.getLink())!, options: [:], completionHandler: nil)
        }
        
        let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cells.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return cells[indexPath.row].getHeight() }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionFooterView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 33 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return sectionHeaderView() }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
}

extension ManageAboutController {
    
    private func aboutCell(c: AboutCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.standard!, fontColor: .navigationsGreen)
        let subtext = UILabel().setUpLabel(text: c.getSubtext(), font: UIFont.subheader!, fontColor: .navigationsWhite)
        subtext.numberOfLines = 0
        subtext.lineBreakMode = .byWordWrapping
        let subtextWidth = UIScreen.main.bounds.width - 24
        let divider = UIView().setupBackground(bgColor: .navigationsGreen)
        let icon = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "launch"))
        
        cell.addSubviews(views: [background, title, subtext, divider, icon])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, bottomPad: 0, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(right: background.rightAnchor, rightPad: -3, centerY: title.centerYAnchor, width: 22, height: 22)
        title.anchors(top: background.topAnchor, topPad: 3, left: background.leftAnchor, leftPad: 6)
        divider.anchors(top: title.bottomAnchor, topPad: 3, left: background.leftAnchor, leftPad: 6, right: background.rightAnchor, rightPad: -6, height: 1)
        subtext.anchors(top: divider.bottomAnchor, topPad: 3, left: background.leftAnchor, leftPad: 6, width: subtextWidth)
        return cell
    }
    
    private func headerView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 125))
        let background = UIView()
        background.backgroundColor = .tableViewMediumGrey
        let nameLabel = UILabel().setUpLabel(text: "Academus", font: UIFont.standard!, fontColor: .navigationsWhite)
        let versionLabel = UILabel().setUpLabel(text: "Version: 0.2.1", font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "logo_colored")
        
        background.roundCorners(corners: .bottom)
        
        view.addSubviews(views: [background, image, nameLabel, versionLabel])
        
        background.anchors(top: view.topAnchor, bottom: view.bottomAnchor, bottomPad: -9, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        image.anchors(top: background.topAnchor, topPad: 12, centerX: background.centerXAnchor, width: 42, height: 42)
        nameLabel.anchors(top: image.bottomAnchor, topPad: 12, centerX: background.centerXAnchor)
        versionLabel.anchors(top: nameLabel.bottomAnchor, topPad: 3, centerX: background.centerXAnchor)
        return view
    }
    
    private func sectionHeaderView() -> UIView {
        let item: AboutCellManager = .libraries
        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: item.getTitle(), font: UIFont.standard!, fontColor: .navigationsGreen)

        background.roundCorners(corners: .top)
        
        view.addSubviews(views: [background, title])

        background.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        title.anchors(top: background.topAnchor, topPad: 3, left: background.leftAnchor, leftPad: 6)
        return view
    }
    
    private func sectionFooterView() -> UIView {
        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        background.roundCorners(corners: .bottom)
        
        view.addSubviews(views: [background])
        
        background.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        return view
    }
}
