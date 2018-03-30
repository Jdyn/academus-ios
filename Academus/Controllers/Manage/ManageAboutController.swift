//
//  ManageAboutController.swift
//  Academus
//
//  Created by Jaden Moore on 3/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageAboutController: UITableViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"
        tableView.separatorStyle = .none
        tableView.tableHeaderView = header()
    }
    
    func header() -> UIView {
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: background.bounds.height))
        
        let image = UIImageView()
        image.tintColor = .navigationsLightGrey
        image.image = #imageLiteral(resourceName: "logo_colored")
        let nameLabel = UILabel().setUpLabel(text: "Academus", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
        let versionLabel = UILabel().setUpLabel(text: "Version: 0.0.0", font: UIFont.UISubtext!, fontColor: .navigationsLightGrey)
        
        header.addSubviews(views: [background, image, nameLabel, versionLabel])
        
        background.anchors(top: header.topAnchor, topPad: 0, bottom: versionLabel.bottomAnchor, bottomPad: 6, left: header.leftAnchor, leftPad: 6, right: header.rightAnchor, rightPad: -6, width: 0, height: 0)
        image.anchors(top: background.topAnchor, topPad: 16, centerX: background.centerXAnchor, width: 48, height: 48)
        nameLabel.anchors(top: image.bottomAnchor, topPad: 16, centerX: background.centerXAnchor)
        versionLabel.anchors(top: nameLabel.bottomAnchor, topPad: 6, centerX: background.centerXAnchor)
        return header
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
