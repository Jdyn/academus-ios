//
//  ControllerHelpers.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/19/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupScrollingNavBar() {
        let statusBar = UIView()
        statusBar.backgroundColor = .navigationsDarkGrey
        navigationController?.view.addSubview(statusBar)
        statusBar.anchors(top: navigationController?.view.topAnchor, bottom: navigationController?.view.safeAreaLayoutGuide.topAnchor, width: UIScreen.main.bounds.size.width, height: 0)
    }
    
    func setupAddButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: selector)
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
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
            
        view.addGestureRecognizer(tap)
    }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
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
    
    @objc func alertCancel() {}
}

extension UILabel {
    
    func setUpLabel(text: String, font: UIFont, fontColor: UIColor) -> UILabel {
        
        let label = UILabel()
        
        label.text = text
        label.font = font
        label.textColor = fontColor
        
        return label
    }
}

extension UIButton {
    
    func setUpButton(bgColor: UIColor? = .none, title: String, font: UIFont, fontColor: UIColor, state: UIControlState? = .normal) -> UIButton{
        
        let button = UIButton()
        
        button.backgroundColor = bgColor
        button.setTitle(title, for: state!)
        button.titleLabel?.font = font
        button.setTitleColor(fontColor, for: state!)
        
        return button
    }
}


extension UITextField {
    
    func setupTextField(bgColor: UIColor? = UIColor.tableViewDarkGrey, bottomBorder: Bool, ghostText: String? = "", isLeftImage: Bool? = false, leftImage: UIImage? = nil, isSecure: Bool? = false) -> UITextField {
        
        let field = UITextField()
        
        field.font = UIFont.standard
        field.textColor = UIColor.navigationsWhite
        
        if bottomBorder {
            field.layer.backgroundColor = bgColor?.cgColor
            field.layer.shadowOffset = CGSize(width: 0, height: 1)
            field.layer.shadowOpacity = 1
            field.layer.shadowRadius = 0
            field.layer.shadowColor = UIColor.navigationsGreen.cgColor
        }
        
        if ghostText != "" {
            field.attributedPlaceholder = NSAttributedString(string: ghostText!, attributes: [
                NSAttributedStringKey.foregroundColor: UIColor.ghostText,
                NSAttributedStringKey.font: UIFont.standard!
                ])
        }
        
        if isLeftImage == true {
            let image = UIImageView(image: leftImage)
            image.tintColor = .navigationsGreen
            field.leftViewMode = .always
            field.leftView = image
        }
        
        if isSecure == true {
            field.isSecureTextEntry = true
        }
        
        return field
    }
}

extension UIStackView {
    func setupStack(axis: UILayoutConstraintAxis? = .horizontal, distro: UIStackViewDistribution? = .fill, spacing: CGFloat? = 0) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.axis = axis!
        stackView.distribution = distro!
        stackView.spacing = spacing!
        
        return stackView
    }
}

extension UITableViewController {
    func tableViewEmptyLabel(message: String? = "", show: Bool) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)).setUpLabel(text: message!, font: UIFont.standard!, fontColor: .navigationsLightGrey )
        label.textAlignment = .center
        label.numberOfLines = 0
        if show {
            self.tableView.backgroundView = label
        } else {
            self.tableView.backgroundView = nil
        }
    }
}

extension UIView{
    
    func addSubviews(views: [UIView]) {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
    
    func setupImageView(color: UIColor, image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.tintColor = color
        imageView.image = image
        return imageView
    }
    
    func setupBackground(bgColor: UIColor) -> UIView{
        let background = UIView()
        background.backgroundColor = bgColor
        return background
    }
    
    func setUpShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
        let color = color.cgColor
        self.layer.shadowColor = color
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func anchors(top: NSLayoutYAxisAnchor? = nil, topPad: CGFloat? = 0,
                     bottom: NSLayoutYAxisAnchor? = nil, bottomPad: CGFloat? = 0,
                     left: NSLayoutXAxisAnchor? = nil, leftPad: CGFloat? = 0,
                     right: NSLayoutXAxisAnchor? = nil, rightPad: CGFloat? = 0,
                     centerX: NSLayoutXAxisAnchor? = nil, CenterXPad: CGFloat? = 0,
                     centerY: NSLayoutYAxisAnchor? = nil, CenterYPad: CGFloat? = 0,
                     width: CGFloat? = 0, height: CGFloat? = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top { self.topAnchor.constraint(equalTo: top, constant: topPad!).isActive  = true }
        if let bot = bottom { self.bottomAnchor.constraint(equalTo: bot, constant: bottomPad!).isActive  = true }
        if let left = left { self.leftAnchor.constraint(equalTo: left, constant: leftPad!).isActive  = true }
        if let right = right { self.rightAnchor.constraint(equalTo: right, constant: rightPad!).isActive  = true }
        if let centerX = centerX { self.centerXAnchor.constraint(equalTo: centerX, constant: CenterXPad!).isActive  = true }
        if let centerY = centerY { self.centerYAnchor.constraint(equalTo: centerY, constant: CenterYPad!).isActive  = true }
        if width! > CGFloat(0) { self.widthAnchor.constraint(equalToConstant: width!).isActive = true }
        if height! > CGFloat(0) { self.heightAnchor.constraint(equalToConstant: height!).isActive = true }
    }
    
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
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
