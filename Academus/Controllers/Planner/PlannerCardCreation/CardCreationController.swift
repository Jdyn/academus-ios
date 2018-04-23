//
//  CardCreationController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CardCreationController: UITableViewController, UITextViewDelegate {
    
    var cards = [CardCreationManager]()
    var entries = [CardCreationManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create a Card"
        setupCancelButtonInNavBar()
        tableView.separatorStyle = .none
        extendedLayoutIncludesOpaqueBars = true
        
        cards = [.reminderCard, .notepadCard]
        entries = [.standardTitle, .datePicker, .standardTextbox, .dropdownMenu]
        
        cards.forEach { (type) in
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type.getType())
        }
        entries.forEach { (type) in
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type.getType())
        }
        entries = []
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = cards + entries
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        let cellAtIndex = cellsFiltered[indexPath.row]
        let cellType = cellAtIndex.getType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        if cellAtIndex.getSection() == 0 {
            return cardButton(c: cellAtIndex, cell: cell)
        } else {
            switch cellAtIndex {
            case .datePicker: return coloredDatePicker(c: cellAtIndex, cell: cell)
            case .standardTitle: return standardTitle(c: cellAtIndex, cell: cell)
            case .standardTextbox: return standardTextbox(c: cellAtIndex, cell: cell)
            default: return UITableViewCell()
            }
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            let selectedCell = tableView.cellForRow(at: indexPath)
            if tableView.indexPathForSelectedRow == indexPath {
                selectedCell?.accessoryType = .none
                tableView.deselectRow(at: indexPath, animated: false)
                removeEntries()
                return nil
            }
            return indexPath
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectedCell = tableView.cellForRow(at: indexPath)
            selectedCell?.accessoryType = .checkmark
            
            switch cards[indexPath.row] {
            case .reminderCard, .notepadCard: switchEntries(indexPath: indexPath)
            default: break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectedCell = tableView.cellForRow(at: indexPath)
            selectedCell?.accessoryType = .none
            removeEntries()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
//            let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
//            let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)
//            if section == 0 {
//                title.text = "Select a Card"
//
//            view.addSubviews(views: [background, title])
//
//            background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
//            title.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 9, width: 0, height: 0)
//        }
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if entries.isEmpty {
//            if section == 0 {
//                return 33
//            }
//        }
        return 9 // 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return(section == 0 ? cards.count : entries.count) }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cells = cards + entries
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        return cellsFiltered[indexPath.row].getHeight()
    }
    
    private func removeEntries() {
        if entries.count > 0 {
            tableView.beginUpdates()
            for x in 0...entries.count - 1 {
                let indexPath = IndexPath(row: x, section: 1)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            entries = []
            tableView.endUpdates()
        }
    }
    
    private func switchEntries(indexPath: IndexPath) {
        var animation: UITableViewRowAnimation = .none
        switch cards[indexPath.row] {
        case .reminderCard:
            entries = [.standardTitle, .datePicker]
            animation = .automatic
        case .notepadCard:
            entries = [.standardTitle, .standardTextbox]
            animation = .automatic
        default: break
        }
        tableView.beginUpdates()
        for x in 0...entries.count - 1 {
            let indexPath = IndexPath(row: x, section: 1)
            tableView.insertRows(at: [indexPath], with: animation)
        }
        tableView.endUpdates()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .ghostText {
            textView.text = nil
            textView.textColor = .navigationsWhite
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add some text..."
            textView.textColor = .ghostText
        }
    }
}


extension CardCreationController {
    
    private func cardButton(c: CardCreationManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectedBackgroundView = selectedBackgroundView()
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let name = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        
        cell.addSubviews(views: [background, name])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        name.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor)
        
        return cell
    }
    
    private func coloredDatePicker(c: CardCreationManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let coloredDatePicker = UIColoredDatePicker()
        
        cell.addSubviews(views: [background, coloredDatePicker])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        coloredDatePicker.anchors(top: background.topAnchor, bottom: background.bottomAnchor, left: background.leftAnchor, right: background.rightAnchor)
        return cell
    }
    
    private func standardTitle(c: CardCreationManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none

        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UITextField().setupTextField(bgColor: .tableViewMediumGrey, bottomBorder: true, ghostText: c.getGhostText(), isSecure: false)
        setDoneOnKeyboard(textField: title)
        
        cell.addSubviews(views: [background, title])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        title.anchors(left: background.leftAnchor, leftPad: 6, right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor)
        return cell
    }
    
    private func standardTextbox(c: CardCreationManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let textbox = UITextView()
        textbox.backgroundColor = .tableViewMediumGrey
        textbox.text = c.getGhostText()
        textbox.isEditable = true
        textbox.font = UIFont.standard
        textbox.textColor = .ghostText
        setDoneOnKeyboard(textView: textbox)
        
//        let bottomBorder = CALayer()
//        bottomBorder.backgroundColor = UIColor.navigationsGreen.cgColor
//        bottomBorder.frame = CGRect(x: 6, y: cell.bounds.size.height - 6, width: cell.bounds.size.width - 24, height: 1)
//
//        let topBorder = CALayer()
//        topBorder.backgroundColor = UIColor.navigationsGreen.cgColor
//        topBorder.frame = CGRect(x: 6, y: 5, width: cell.bounds.size.width - 24, height: 1)
//
//        background.layer.addSublayer(topBorder)
//        background.layer.addSublayer(bottomBorder)
//
//        background.layer.masksToBounds = true
        
        textbox.delegate = self
        
        cell.addSubviews(views: [background, textbox])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        textbox.anchors(top: background.topAnchor, topPad: 6, bottom: background.bottomAnchor, bottomPad: -6, left: background.leftAnchor, leftPad: 6, right: background.rightAnchor, rightPad: -6)
        return cell
    }
    
//    private func sectionHeader(indexPath: IndexPath) -> UIView {
//        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
//        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
//        let title = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .navigationsGreen)
//
//        switch cards[section] {
//        case .privacySecurity: title.text = item.getTitle()
//        case .notifications: title.text = item.getTitle()
//        default: title.text = ""
//        }
//
//        view.addSubviews(views: [background, title])
//
//        background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
//        title.anchors(top: background.topAnchor, topPad: 3, left: background.leftAnchor, leftPad: 6, width: 0, height: 0)
//        return view
//    }
    
    private func selectedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .tableViewDarkGrey

        let selectedView = UIView().setupBackground(bgColor: UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 0.1))

        view.addSubview(selectedView)

        selectedView.anchors(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        return view
    }
}
