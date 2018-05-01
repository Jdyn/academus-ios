//
//  CourseInfoController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

class CourseInfoController: UITableViewController {

    var course: Course?
    var cells = [CourseInfoCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Course Information"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)

        self.extendedLayoutIncludesOpaqueBars = true
        
        cells = [.courseName, .customName, .period, .classroomNumber, .teacherName, .email, .sendEmail, .total, .average, .highest, .lowest]
        for cell in cells {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let manager = cellsFiltered[indexPath.row]
        let cellType = manager.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        switch manager {
        case .sendEmail: return sendEmailCell(manager: manager, cell: cell)
        default: return infoCell(manager: manager, cell: cell)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)
        
        let sections: [CourseInfoCellManager] = [.courseInfo, .teacherInfo, .statsInfo]
        let item = sections[section]
        title.text = item.getTitle()
        
        background.roundCorners(corners: .top)

        let icon = UIImageView()
        icon.image = item.getImage()
        icon.tintColor = .navigationsGreen
        
        view.addSubviews(views: [background, icon, title])
        
        background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 8, right: view.rightAnchor, rightPad: -8)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 9, centerY: background.centerYAnchor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 2 else { return setupSection(type: .footer) }
        
        let view = UIView()
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let label = UILabel().setUpLabel(text: "These statistics are an estimate — the more students in this class that use Academus, the more accurate they will be.", font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        label.numberOfLines = 0
        background.roundCorners(corners: .bottom)
        view.addSubviews(views: [background, label])
        
        background.anchors(top: view.topAnchor, left: view.leftAnchor, leftPad: 8, right: view.rightAnchor, rightPad: -8, height: 9)
        label.anchors(top: background.bottomAnchor, topPad: 6, left: background.leftAnchor, leftPad: 13, right: background.rightAnchor, rightPad: -13)
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 3 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 50 }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 44 }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return (section == 2) ? 150 : 18 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (section == 1) ? 3 : 4 }
}

extension CourseInfoController {
    private func infoCell(manager: CourseInfoCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: manager.getTitle(), font: UIFont.subheader!, fontColor: .navigationsWhite)
        let subtext = UILabel()
        subtext.textAlignment = .right
        
        if manager.getSubtext(course: course)?.isEmpty == false {
            subtext.text = manager.getSubtext(course: course)
            subtext.font = UIFont.subheader!
            subtext.textColor = .navigationsLightGrey
        } else {
            subtext.text = manager.getAltSubtext()
            subtext.font = UIFont.subitalic!
            subtext.textColor = .tableViewLightGrey
        }
        subtext.adjustsFontSizeToFitWidth = true
        cell.addSubviews(views: [background, title, subtext])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        title.anchors(top: background.topAnchor, topPad: 9, left: background.leftAnchor, leftPad: 12, centerY: background.centerYAnchor)
        subtext.anchors(top: background.topAnchor, topPad: 9, left: title.rightAnchor, leftPad: 12, right: background.rightAnchor, rightPad: -12, centerY: title.centerYAnchor)

        return cell
    }
    
    private func sendEmailCell(manager: CourseInfoCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let image = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "email"))
        let button = ShareButton()
        button.backgroundColor = .tableViewMediumGrey
        button.setTitle("Send an Email", for: .normal)
        button.layer.borderWidth = 1
        button.setTitleColor(.navigationsGreen, for: .normal)
        button.titleLabel?.font = UIFont.standard
        button.layer.borderColor = UIColor.navigationsGreen.cgColor
        button.addSubview(image)
        button.email = manager.getSubtext(course: course)
        button.addTarget(self, action: #selector(emailPressed), for: .touchUpInside)
        cell.addSubviews(views: [background, button])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        button.anchors(top: background.topAnchor, topPad: 12, bottom: background.bottomAnchor, bottomPad: 0, left: background.leftAnchor, leftPad: 28, right: background.rightAnchor, rightPad: -28)
        image.anchors(left: button.leftAnchor, leftPad: 9, centerY: button.centerYAnchor, width: 24, height: 24)
        return cell
    }
    
    @objc func emailPressed(_ sender: ShareButton) {
        if sender.email != nil {
            let alert = UIAlertController(title: "Open Mail", message: "Are you sure you want to open up mail?", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
                guard let email = sender.email else { return }
                if let url = NSURL(string: "mailto:\(email)") {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(actionNo)
            alert.addAction(actionYes)
            present(alert, animated: true, completion: nil)
            
        } else {
            self.alertMessage(title: "Who?", message: "No email available...")
        }
    }
}
