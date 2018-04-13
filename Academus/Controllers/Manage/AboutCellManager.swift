////
////  AboutCellManager.swift
////  Academus
////
////  Created by Jaden Moore on 3/28/18.
////  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
////
//
//import UIKit
//
//enum AboutCellManager {
//    
//    case alamofire
//    case swiftyJson
//    case locksmith
//    
//    func getTitle() -> String{
//        switch self {
//        case .alamofire: return "Alamofire"
//        case .swiftyJson: return "SwiftyJSON"
//        case .locksmith: return "Locksmith"
//        }
//    }
//    
//    func getSubtext() -> String{
//        switch self {
//        case .alamofire: return "Alamofire is an HTTP networking library written in Swift."
//        case .swiftyJson: return "SwiftyJSON makes it easy to deal with JSON data in Swift."
//        case .locksmith: return "yes"//"A powerful, protocol-oriented library for working with the keychain in Swift."
//        }
//    }
//    
//    func getSection() -> Int {
//        switch self {
//        case .alamofire, .swiftyJson, .locksmith: return 0
//        }
//    }
//    
//    func rowCount() -> Int {
//        switch self {
//        case .alamofire, .swiftyJson, .locksmith: return 3
//        }
//    }
//    
//    func cellType() -> CellTypes{
//        switch self {
//        case .alamofire, .swiftyJson, .locksmith: return .aboutStandardCell
//        }
//    }
//}
//
//class ManageAboutCell: MainCell {
//    
//    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
//    let title = UILabel().setUpLabel(text: "", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
//    let subtext = UILabel().setUpLabel(text: "hello", font: UIFont.UISubtext!, fontColor: .navigationsWhite)
//    
//    override func setTitle(title: String) {
//        self.title.text! = title
//    }
//    
//    override func setSubtext(text: String) {
//        self.subtext.text! = text
//    }
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .tableViewDarkGrey
//        selectionStyle = .none
//        
//        addSubviews(views: [background, subtext, title])
//        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
//        title.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 12)
//        subtext.anchors(top: title.bottomAnchor, topPad: 6, left: background.rightAnchor, leftPad: 12)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

