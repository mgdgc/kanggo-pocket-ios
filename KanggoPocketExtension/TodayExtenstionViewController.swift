//
//  TodayViewController.swift
//  KanggoPocketExtension
//
//  Created by Peter Choi on 2018. 1. 18..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var scheduleCard: UIView! {
        didSet {
            scheduleCard.layer.cornerRadius = 10
            scheduleCard.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var mealCard: UIView! {
        didSet {
        mealCard.layer.cornerRadius = 10
        mealCard.layer.masksToBounds = false
        }
    }
    
    @IBAction func openApp(sender: AnyObject) {
        let url = URL(string: "location:")
        if let appUrl = url {
            self.extensionContext?.open(appUrl, completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize

        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 250)
            performWidgetUpdate()
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        performWidgetUpdate()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func performWidgetUpdate() {
        scheduleLabel.text = getScheduleData()
        mealLabel.text = getMealData()
    }
    
    func getScheduleData() -> String {
        let userDefaults = UserDefaults.init(suiteName: "group.scheduleData")
        let userInfoDefault = UserDefaults(suiteName: "group.KanggoPocket")
        if userDefaults == nil || userInfoDefault == nil {
            return ""
        }
        let grade = String(userInfoDefault!.integer(forKey: "grade"))
        let classNum = String(userInfoDefault!.integer(forKey: "class_number"))
        var weekCode = 0
        if getDayOfWeek() >= 2 && getDayOfWeek() < 7 {
            weekCode = getDayOfWeek() - 2
        }
        let key = grade + "-" + classNum + "-" + String(weekCode)
        let schedule = userDefaults!.string(forKey: key)
        if schedule != nil {
            return schedule!
        } else {
            return "먼저 시간표 메뉴에서\n시간표를 업데이트 해주세요."
        }
    }
    
    func getDayOfWeek() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = calendar.dateComponents([.weekday], from: now)
        return comps.weekday!
    }
    
    func getMealData() -> String {
        print("\n\ndayOfWeek = " + String(getDayOfWeek()))
        let ud = UserDefaults(suiteName: "group.mealData")
        var dayOfWeek: Int {
            if getDayOfWeek() >= 2 && getDayOfWeek() < 7 {
                return getDayOfWeek() - 1
            } else {
                return 5
            }
        }
        var content = ud?.string(forKey: String(dayOfWeek) + "-2")
        if content == nil {
            content = "정보 없음"
        }
        return content!
    }
    
}
