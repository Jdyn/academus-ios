//
//  SettingsBundleHelper.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/16/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//
import Foundation

struct SettingsBundleKeys {
    static let buildPreference = "buildPreference"
    static let versionPreference = "versionPreference"
    static let appLockPreference = "appLockPreference"
    static let assignmentPostedPreference = "assignmentPostedPreference"
    static let courseGradePostedPreference = "courseGradePostedPreference"
    static let miscPreference = "miscPreference"
}

class SettingsBundleHelper {
    class func setVersionAndBuildNumber() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_preference")
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(build, forKey: "build_preference")
    }
}
