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
}

extension UITextField {
    
    func setBorderBottom(backGroundColor:UIColor, borderColor: UIColor) {
        self.layer.backgroundColor = backGroundColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowColor = borderColor.cgColor
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
