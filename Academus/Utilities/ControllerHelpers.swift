//
//  ControllerHelpers.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/19/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupAddButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: selector)
    }
        
    func setupCancelButtonInNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelModal))
    }
    
    @objc func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func alertMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadingAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertCancel() {
        
    }
    
    
    
}

extension UILabel {
    
    func setUpLabel(text: String, font: UIFont, fontColor: UIColor) {
        self.text = text
        self.font = font
        self.textColor = fontColor
    }
    
}

extension UIButton {
    
    func setUpButton(bgColor: UIColor?, text: String, titleFont: UIFont, titleColor: UIColor, titleState: UIControlState) {
        
        self.backgroundColor = bgColor
        self.setTitle(text, for: titleState)
        self.titleLabel?.font = titleFont
        self.setTitleColor(titleColor, for: titleState)
        
    }
    
}


extension UITextField {
    
    func setBorderBottom(backGroundColor: UIColor, borderColor: UIColor) {
        self.layer.backgroundColor = backGroundColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowColor = borderColor.cgColor
    }
    
    func setGhostText(message: String, color: UIColor, font: UIFont) {
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.font: font
            ])
    }
}

extension UIView{
    
    func anchors(top: NSLayoutYAxisAnchor? = nil, topPad: CGFloat? = 0,
                     bottom: NSLayoutYAxisAnchor? = nil, bottomPad: CGFloat? = 0,
                     left: NSLayoutXAxisAnchor? = nil, leftPad: CGFloat? = 0,
                     right: NSLayoutXAxisAnchor? = nil, rightPad: CGFloat? = 0,
                     centerX: NSLayoutXAxisAnchor? = nil, CenterXPad: CGFloat? = 0,
                     centerY: NSLayoutYAxisAnchor? = nil, CenterYPad: CGFloat? = 0,
                     width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top { self.topAnchor.constraint(equalTo: top, constant: topPad!).isActive  = true }
        if let bot = bottom { self.bottomAnchor.constraint(equalTo: bot, constant: bottomPad!).isActive  = true }
        if let left = left { self.leftAnchor.constraint(equalTo: left, constant: leftPad!).isActive  = true }
        if let right = right { self.rightAnchor.constraint(equalTo: right, constant: rightPad!).isActive  = true }
        if let centerX = centerX { self.centerXAnchor.constraint(equalTo: centerX, constant: CenterXPad!).isActive  = true }
        if let centerY = centerY { self.centerYAnchor.constraint(equalTo: centerY, constant: CenterYPad!).isActive  = true }
        if width > 0 { self.widthAnchor.constraint(equalToConstant: width).isActive = true }
        if height > 0 { self.heightAnchor.constraint(equalToConstant: height).isActive = true }
    }
}

func timeAgoStringFromDate(date: Date) -> String? {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    
    let now = Date()
    
    let calendar = NSCalendar.current
    let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
    let components = calendar.dateComponents(components1, from: date, to: now)
    
    if components.year ?? 0 > 0 {
        formatter.allowedUnits = .year
    } else if components.month ?? 0 > 0 {
        formatter.allowedUnits = .month
    } else if components.weekOfMonth ?? 0 > 0 {
        formatter.allowedUnits = .weekOfMonth
    } else if components.day ?? 0 > 0 {
        formatter.allowedUnits = .day
    } else if components.hour ?? 0 > 0 {
        formatter.allowedUnits = [.hour]
    } else if components.minute ?? 0 > 0 {
        formatter.allowedUnits = .minute
    } else {
        formatter.allowedUnits = .second
    }
    
    let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
    
    guard let timeString = formatter.string(for: components) else {
        return nil
    }
    return String(format: formatString, timeString)
}

extension UITableView {

    func registerCell(_ cellClass: UITableViewCell.Type) {
        let cellReuseIdentifier = cellClass.cellReuseIdentifier()
        register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

extension UITableViewCell {

    class func cellReuseIdentifier() -> String {
        return "\(self)"
    }
}

