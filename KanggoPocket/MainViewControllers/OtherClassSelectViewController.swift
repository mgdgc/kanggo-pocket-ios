//
//  OtherClassSelectViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 2. 9..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class OtherClassSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate, OtherClassScheduleDelegate {

    @IBOutlet var tableView: UITableView!
    
    let schedulePref = UserDefaults(suiteName: "group.scheduleData")
    var totalNum = [Int]()
    var data = [OtherClassSelectModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 0.341, blue: 0.133, alpha: 1.0)
        totalNum.append(schedulePref?.integer(forKey: "1st_grade_class_num") == nil ? 0 : (schedulePref?.integer(forKey: "1st_grade_class_num"))!)
        totalNum.append(schedulePref?.integer(forKey: "2nd_grade_class_num") == nil ? 0 : (schedulePref?.integer(forKey: "2nd_grade_class_num"))!)
        totalNum.append(schedulePref?.integer(forKey: "3rd_grade_class_num") == nil ? 0 : (schedulePref?.integer(forKey: "3rd_grade_class_num"))!)
        
        initData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func initData() {
        if totalNum[0] != 0 && totalNum[1] != 0 && totalNum[2] != 0 {
            for i in 0..<3 {
                let grade = String(i + 1) + NSLocalizedString("grade", comment: "grade")
                data.append(OtherClassSelectModel.init(true, grade, 0, 0))
                for j in 1...totalNum[i] {
                    data.append(OtherClassSelectModel.init(false, grade + " " + String(j) + NSLocalizedString("class", comment: "class"), i + 1, j))
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        tableView.backgroundColor = manager.getTableViewBackground()
        tableView.separatorColor = manager.getSeparatorColor()
        
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OtherClassScheduleViewController {
            vc.gradeNum = (sender as! ClassCell).gradeNum
            vc.classNum = (sender as! ClassCell).classNum
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + totalNum[0] + totalNum[1] + totalNum[2]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let manager = ThemeManager()
        let model = data[indexPath.row]
        
        if model.isGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeCell") as! GradeCell
            cell.gradeLabel.text = model.title
            cell.backgroundColor = manager.getTableViewBackground()
            cell.contentView.backgroundColor = manager.getTableViewBackground()
            cell.gradeLabel.textColor = manager.getTextColorSecondary()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell") as! ClassCell
            cell.classLabel.text = model.title
            cell.gradeNum = model.gradeNum
            cell.classNum = model.classNum
            cell.backgroundColor = manager.getCardBackground()
            cell.contentView.backgroundColor = manager.getCardBackground()
            cell.classLabel.textColor = manager.getTextColor()
            return cell
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        //let VC = UINavigationController(rootViewController: viewControllerToCommit)
        //show(VC, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        let OtherClassVC = storyboard?.instantiateViewController(withIdentifier: "OtherClassScheduleViewController") as! OtherClassScheduleViewController
        //OtherClassVC.delegate = self
        OtherClassVC.gradeNum = getScheduleInfo(index: indexPath.row)[0]
        OtherClassVC.classNum = getScheduleInfo(index: indexPath.row)[1]
        OtherClassVC.preferredContentSize = CGSize(width: 0, height: 360)
        previewingContext.sourceRect = cell.frame
        return OtherClassVC
    }
    
    func getScheduleInfo(index: Int) -> [Int] {
        return [data[index].gradeNum, data[index].classNum]
    }
    
    func OtherClassSchedule() {
        
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

struct OtherClassSelectModel {
    var isGroup = false
    var title = ""
    var gradeNum = 1
    var classNum = 1
    init(_ isGroup: Bool, _ title: String, _ gradeNum: Int, _ classNum: Int) {
        self.isGroup = isGroup
        self.title = title
        self.gradeNum = gradeNum
        self.classNum = classNum
    }
}

class GradeCell : UITableViewCell {
    @IBOutlet weak var gradeLabel: UILabel!
}

class ClassCell : UITableViewCell {
    @IBOutlet weak var classLabel: UILabel!
    var gradeNum = 1
    var classNum = 1
}






