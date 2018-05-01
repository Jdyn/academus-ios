//
//  TodayViewController.swift
//  AcademusWidget
//
//  Created by Pasha Bouzarjomehri on 4/30/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationCenter

typealias CompletionHandler = (_ Success: Bool) -> ()

class TodayViewController: UIViewController, NCWidgetProviding {
    var shared = UserDefaults(suiteName: "group.academus")
    var courses = [Course]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        CFPreferencesAppSynchronize(kCFPreferencesAnyApplication)
        
        getCourses { (success) in
            if success {
                let label = UILabel().setUpLabel(text: "\(self.courses[0].grade?.percent)", font: UIFont.standard!, fontColor: .navigationsGreen)
                self.view.addSubview(label)
                label.anchors(centerX: self.view.centerXAnchor, centerY: self.view.centerYAnchor)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getCourses(completion: @escaping CompletionHandler) {
        print(shared)
        print(shared?.string(forKey: "authToken"))
        print(shared?.string(forKey: "BASE_URL"))
        
        guard let authToken = shared?.string(forKey: "authToken"),
            let BASE_URL = shared?.string(forKey: "BASE_URL") else { completion(false); return }
        
        Alamofire.request(URL(string: "\(BASE_URL)/api/courses?token=\(authToken)")!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else { completion(false); return }
            if response.result.error == nil {
                do {
                    let json = JSON(data)
                    let jsonResult = try json["result"].rawData()
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let course = try decoder.decode([Course].self, from: jsonResult)
                    if json["success"] == true {
                        self.courses = course
                        completion(true)
                    }
                } catch let error{
                    debugPrint(error)
                    completion(false)
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
        completion(false)
    }
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

extension UIFont {
    
    static let standard = UIFont(name: "AvenirNext-medium", size: 18)
    static let subheader = UIFont(name: "AvenirNext-medium", size: 16)
    static let italic = UIFont(name: "AvenirNext-MediumItalic", size: 18)
    static let subitalic = UIFont(name: "AvenirNext-MediumItalic", size: 16)
    static let header = UIFont(name: "AvenirNext-demibold", size: 20)
    static let largeHeader = UIFont(name: "AvenirNext-demibold", size: 26)
    static let subtext = UIFont(name: "AvenirNext-medium", size: 14)
    static let small = UIFont(name: "AvenirNext-medium", size: 12)
    static let demiStandard = UIFont(name: "AvenirNext-demibold", size: 16)
    static let nextStandard = UIFont(name: "AvenirNext", size: 18)
    
}

extension UIColor {
    
    static let navigationsLightGrey = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
    static let navigationsMediumGrey = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1)
    static let navigationsDarkGrey = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    
    static let navigationsRed = UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1)
    static let navigationsWhite = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    static let navigationsGreen = UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)
    static let navigationsBlue = UIColor(red: 30/255, green: 136/255, blue: 229/255, alpha: 1)
    static let navigationsOrange = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
    static let navigationsPink = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
    static let navigationsDarkGreen = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
    
    static let tableViewGrey = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
    static let tableViewLightGrey = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
    static let tableViewMediumGrey = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)// were 45/45/45
    static let tableViewDarkGrey = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1) // were 40/40/40
    static let tableViewSeperator = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
    
    static let ghostText = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.3)
    
    static func blend(colors: [UIColor]) -> UIColor {
        let numberOfColors = CGFloat(colors.count)
        var (red, green, blue, alpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        let componentsSum = colors.reduce((red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat())) { temp, color in
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return (temp.red+red, temp.green + green, temp.blue + blue, temp.alpha+alpha)
        }
        return UIColor(red: componentsSum.red / numberOfColors,
                       green: componentsSum.green / numberOfColors,
                       blue: componentsSum.blue / numberOfColors,
                       alpha: componentsSum.alpha / numberOfColors)
    }
}

extension UIView {
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
}
