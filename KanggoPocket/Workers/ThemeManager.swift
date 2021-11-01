//
//  ThemeManager.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 8. 19..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager {
    
    func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: "DARK_MODE")
    }
    
    func getBackground() -> UIColor {
        if isDarkMode() {
            return ColorManager.colorDarkBackground
        } else {
            return ColorManager.colorNormalBackground
        }
    }
    
    func getTableViewBackground() -> UIColor {
        if isDarkMode() {
            return ColorManager.colorDarkTableViewBackground
        } else {
            return ColorManager.colorNormalTableViewBackground
        }
    }
    
    func getCardBackground() -> UIColor {
        if isDarkMode() {
            return ColorManager.colorDarkCardBackground
        } else {
            return ColorManager.colorNormalCardBackground
        }
    }
    
    func getTextColor() -> UIColor {
        if isDarkMode() {
            return ColorManager.colorDarkText
        } else {
            return ColorManager.colorNormalText
        }
    }
    
    func getTextColorSecondary() -> UIColor {
        if isDarkMode() {
            return ColorManager.colorDarkTextSecondary
        } else {
            return ColorManager.colorNormalTextSecondary
        }
    }
    
    func getSeparatorColor() -> UIColor {
        if isDarkMode() {
            return ColorManager.colorDarkSeparator
        } else {
            return ColorManager.colorNormalSeparator
        }
    }
    
}
