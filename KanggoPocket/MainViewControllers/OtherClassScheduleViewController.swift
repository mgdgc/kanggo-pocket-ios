//
//  OtherClassScheduleViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 2. 9..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

protocol OtherClassScheduleDelegate {
    func OtherClassSchedule()
}

class OtherClassScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = Array<String>()
    let daysOfWeek = ["월요일", "화요일", "수요일", "목요일", "금요일"]
    var gradeNum = 1
    var classNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        tableView.backgroundColor = manager.getTableViewBackground()
        tableView.separatorColor = manager.getSeparatorColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData() {
        let key = String(gradeNum) + "-" + String(classNum) + "-"
        for i in 0..<5 {
            let schedule = UserDefaults(suiteName:"group.scheduleData")!.string(forKey: key + String(i))
            if schedule == nil {
                data.append(NSLocalizedString("no_data", comment: "no_data"))
            } else {
                data.append(schedule!)
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherScheduleCell") as! OtherScheduleCell
        cell.dayOfWeekLabel.text = daysOfWeek[indexPath.row]
        cell.scheduleLabel.text = data[indexPath.row]
        
        let manager = ThemeManager()
        cell.contentView.backgroundColor = manager.getCardBackground()
        cell.backgroundColor = manager.getCardBackground()
        cell.dayOfWeekLabel.textColor = manager.getTextColor()
        cell.scheduleLabel.textColor = manager.getTextColor()
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class OtherScheduleCell : UITableViewCell {
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
}



