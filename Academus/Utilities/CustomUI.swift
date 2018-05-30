//
//  CustomUI.swift
//  Academus
//
//  Created by Jaden Moore on 3/26/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ShareButton: UIButton {
    var inviteCode: String?
    var urlString: String?
    var email: String?
}

class settingSwitch: UISwitch {
    var cellType: SettingsCellManager?
}

class UIColoredDatePicker: UIDatePicker {
    var changed = false
    override func addSubview(_ view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor.navigationsWhite, forKey: "textColor")
        }
        super.addSubview(view)
    }
}
