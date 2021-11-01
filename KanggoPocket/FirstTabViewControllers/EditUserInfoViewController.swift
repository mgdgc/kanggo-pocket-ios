//
//  EditUserInfoViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 15..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var teacherAccSwitch: UISwitch!
    
    let pickerData = [[1, 2, 3],
                      [1, 2, 3, 4, 5, 6, 7, 8, 9],
                      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                       11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                       21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
                       31, 32, 33, 34, 35, 36, 37, 38, 39, 40]]
    
    let pickerString = [["1학년", "2학년", "3학년"],
                        ["1반", "2반", "3반", "4반", "5반", "6반", "7반", "8반", "9반"],
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                         "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                         "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
                         "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"]]
    
    let userDefault = UserDefaults(suiteName: "group.KanggoPocket")!
    var name: String = ""
    var grade: Int = 0
    var classNum: Int = 0
    var stdNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseBtnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerString[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        grade = pickerData[0][pickerView.selectedRow(inComponent: 0)]
        classNum = pickerData[1][pickerView.selectedRow(inComponent: 1)]
        stdNum = pickerData[2][pickerView.selectedRow(inComponent: 2)]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.nameField) {
            self.nameField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func TeacherAccSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            pickerView.isHidden = true
        } else {
            pickerView.isHidden = false
        }
    }
    
    @IBAction func btnCompleteClick(_ sender: UIButton) {
        name = nameField.text!
        if checkInfoValid() {
            checkInfoToUser()
        }
    }
    
    func checkInfoValid() -> Bool {
        if teacherAccSwitch.isOn {
            return checkTeacherInfoValid()
        }
        if name == "" {
            showAlert(title: NSLocalizedString("first_setting_alert_empty", comment: "first_setting_alert_empty"), msg: NSLocalizedString("first_setting_alert_empty_msg", comment: "first_setting_alert_empty_msg"), handler: nil)
            return false
        }
        if name.count < 2 || name.count > 4 {
            showAlert(title: NSLocalizedString("first_setting_alert_name", comment: "first_setting_alert_name"), msg: NSLocalizedString("first_setting_alert_name_msg", comment: "first_setting_alert_name_msg"), handler: nil)
            return false
        }
        if grade == 0 || classNum == 0 || stdNum == 0 {
            showAlert(title: NSLocalizedString("first_setting_alert_stdnum", comment: "first_setting_alert_stdnum"), msg: NSLocalizedString("first_setting_alert_stdnum_msg", comment: "first_setting_alert_stdnum_msg"), handler: nil)
            return false
        }
        return true
    }
    
    func checkTeacherInfoValid() -> Bool {
        if name == "" {
            showAlert(title: NSLocalizedString("first_setting_alert_empty", comment: "first_setting_alert_empty"), msg: NSLocalizedString("first_setting_alert_empty_msg", comment: "first_setting_alert_empty_msg"), handler: nil)
            return false
        }
        if (name.count) < 2 || (name.count) > 4 {
            showAlert(title: NSLocalizedString("first_setting_alert_name", comment: "first_setting_alert_name"), msg: NSLocalizedString("first_setting_alert_name_msg", comment: "first_setting_alert_name_msg"), handler: nil)
            return false
        }
        return true
    }
    
    func checkInfoToUser() {
        let title = NSLocalizedString("first_setting_alert_check", comment: "first_setting_alert_check")
        var msg = NSLocalizedString("first_setting_alert_check_msg", comment: "first_setting_alert_check_msg")
        if teacherAccSwitch.isOn {
            msg += name + NSLocalizedString("first_setting_teacher", comment: "first_setting_teacher")
        } else {
            msg += "\(String(describing: grade))학년 \(String(describing: classNum))반 \(String(describing: stdNum))번 \(String(describing: name)) 학생"
        }
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: { (action) -> Void in
            self.saveUserInfo(isTeacher: self.teacherAccSwitch.isOn)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: { (action) -> Void in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, msg: String, handler: ((UIAlertAction) -> Swift.Void)?) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: handler)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveUserInfo(isTeacher: Bool) {
        userDefault.set(isTeacher, forKey: UserDefaultsKeys().BOOL_TEACHER)
        userDefault.set(name, forKey: UserDefaultsKeys().STRING_NAME)
        // 선생님이면 학번을 0000으로 고정
        if isTeacher {
            grade = 0
            classNum = 0
            stdNum = 0
        }
        userDefault.set(grade, forKey: UserDefaultsKeys().INT_GRADE)
        userDefault.set(classNum, forKey: UserDefaultsKeys().INT_CLASS)
        userDefault.set(stdNum, forKey: UserDefaultsKeys().INT_NUMBER)
        
        let ud = UserDefaults.standard
        ud.set(false, forKey: UserDefaultsKeys().BOOL_IS_FIRST)
        
        userDefault.synchronize()
        ud.synchronize()
        
        self.dismiss(animated: true, completion: nil)
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
