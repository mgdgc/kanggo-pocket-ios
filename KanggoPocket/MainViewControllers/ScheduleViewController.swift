//
//  ScheduleViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2017. 12. 6..
//  Copyright © 2017년 RiDsoft. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let weeks = ["월요일", "화요일", "수요일", "목요일", "금요일"]
    var data = getScheduleData()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateIndicator.hidesWhenStopped = true
        updateIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        tableView.backgroundColor = manager.getTableViewBackground()
        
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        
        self.data = getScheduleData()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weeks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        
        cell.labelWeek.text = weeks[indexPath.row]
        cell.labelSchedule.text = data[indexPath.row]
        
        let manager = ThemeManager()
        cell.contentView.backgroundColor = manager.getTableViewBackground()
        cell.cardView.backgroundColor = manager.getCardBackground()
        cell.labelWeek.textColor = manager.getTextColor()
        cell.labelSchedule.textColor = manager.getTextColor()

        return cell
    }
    
    @IBAction func updateBtnClick(_ sender: UIBarButtonItem) {
        
        if checkNetwork() {
            doParse()
        } else {
            makeNetworkErrorAlert()
        }
    }
    
    func checkNetwork() -> Bool {
        return DataManager().checkNetwork()
    }
    
    func makeAlert() {
        let title = NSLocalizedString("schedule_update_alert", comment: "schedule_update_alert")
        let msg = NSLocalizedString("schedule_update_alert_msg", comment: "schedule_update_alert_msg")
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: {
            (action) -> Void in
            self.doParse()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: {
            (action) -> Void in
            //            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func doParse() {
        updateIndicator.startAnimating()
        DispatchQueue(label: "xyz.xyz.ridsoft.KanggoPocket.scheduleParse").async {
            let parser = ScheduleParser()
//            let data = parser.doParse()
            let data = parser.parseSchedule()
            if data != nil {
                parser.clearScheduleData()
                parser.saveData(classNum: parser.classNum, data: data!)
            } else {
                self.makeErrorAlert()
            }
            
            DispatchQueue.main.async {
                self.updateIndicator.stopAnimating()
                self.data = getScheduleData()
                self.tableView.reloadData()
                let title = NSLocalizedString("schedule_update_finished", comment: "schedule_update_finished")
                let msg = NSLocalizedString("schedule_update_finished_msg", comment: "schedule_update_finished_msg")
                let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: nil)
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func makeNetworkErrorAlert() {
        let title = NSLocalizedString("network_not_connected", comment: "network_not_connected")
        let msg = NSLocalizedString("network_not_connected_msg", comment: "network_not_connected_msg")
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func makeErrorAlert() {
        let title = NSLocalizedString("schedule_update_error", comment: "schedule_update_error")
        let msg = NSLocalizedString("schedule_update_error_msg", comment: "schedule_update_error_msg")
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: {
            (action) -> Void in
            //            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

func getScheduleData() -> [String] {
    var data = Array<String>()
    let key = String(UserDefaults(suiteName: "group.KanggoPocket")!.integer(forKey: UserDefaultsKeys().INT_GRADE)) + "-"
        + String(UserDefaults(suiteName: "group.KanggoPocket")!.integer(forKey: UserDefaultsKeys().INT_CLASS)) + "-"
    for i in 0..<5 {
        let schedule = UserDefaults(suiteName:"group.scheduleData")!.string(forKey: key + String(i))
        if schedule == nil {
            data.append(NSLocalizedString("no_data", comment: "no_data"))
        } else {
            data.append(schedule!)
        }
    }
    return data
}

class ScheduleCell : UITableViewCell {
    @IBOutlet weak var labelWeek: UILabel!
    @IBOutlet weak var labelSchedule: UILabel!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 10
            cardView.layer.masksToBounds = false
            cardView.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
            cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cardView.layer.shadowOpacity = 0.16
        }
    }
}
