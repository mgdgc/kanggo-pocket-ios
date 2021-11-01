//
//  MoreInfoViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 2. 5..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit
import MessageUI

func initSettingData() -> [SettingModel] {
    var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    if version == nil { version = NSLocalizedString("no_data", comment: "no_data") }
    return [
//        SettingModel.init(title: NSLocalizedString("info_group_donation", comment: "info_group_donation")),
//        SettingModel.init(title: NSLocalizedString("info_donation", comment: "info_donation"), id: "donation"),
  
        SettingModel.init(title: "학생 정보"),
        SettingModel.init(title: "학생 정보", id: "info_student_account"),
        
        SettingModel.init(title: NSLocalizedString("info_group_setting", comment: "info_group_setting")),
        SettingModel.init(title: NSLocalizedString("info_setting", comment: "info_setting"), id: "open_setting"),
        
        SettingModel.init(title: NSLocalizedString("info_group_application", comment: "info_group_application")),
        SettingModel.init(title: NSLocalizedString("info_application_version", comment: "info_application_version"), value: version, id: "version"),
        SettingModel.init(title: NSLocalizedString("info_developer", comment: "info_developer"), value: NSLocalizedString("info_developer_value", comment: "info_developer_value"), id: "developer"),
        SettingModel.init(title: NSLocalizedString("info_license", comment: "info_license"), id: "license_info"),
        
        SettingModel.init(title: NSLocalizedString("info_group_communication", comment: "info_group_communication")),
        SettingModel.init(title: NSLocalizedString("info_facebook", comment: "info_facebook"), id: "facebook"),
        SettingModel.init(title: NSLocalizedString("info_email", comment: "info_email"), value: "soc06212@gmail.com", id: "email"),
        SettingModel.init(title: NSLocalizedString("info_telegram", comment: "info_telegram"), value: "@soc06212", id: "telegram"),
        SettingModel.init(title: NSLocalizedString("info_kakaotalk", comment: "info_kakaotalk"), value: "RiDsoft 플러스친구", id: "kakaotalk")
    ]
}

class MoreInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    let licenses = [
        "icons: https://material.io/icons/",
        "colors: https://material.io/tools/color/",
        NSLocalizedString("license_kanna", comment: "license_kanna"),
        NSLocalizedString("license_meal", comment: "license_meal"),
        "Alamofire: https://github.com/Alamofire/Alamofire",
        "RSBarcodes_Swift: https://github.com/yeahdongcn/RSBarcodes_Swift",
        "Firebase: https://firebase.google.com"
    ]
    
    let segEasterEgg = "segEasterEgg"
    let segDevOption = "segDevOption"
    
    @IBOutlet weak var settingTableView: UITableView!
    
    var settingData: [SettingModel] = initSettingData()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        view.backgroundColor = manager.getTableViewBackground()
        settingTableView.backgroundColor = manager.getTableViewBackground()
        settingTableView.separatorColor = manager.getSeparatorColor()
        settingTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let manager = ThemeManager()
        let data = settingData[indexPath.row]
        
        if data.isGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDivider") as! GroupCell
            let title = data.title == nil ? "" : data.title
            
            cell.groupTitleLabel.text = title
            
            cell.contentView.backgroundColor = manager.getTableViewBackground()
            cell.groupTitleLabel.textColor = manager.getTextColorSecondary()
            cell.backgroundColor = manager.getTableViewBackground()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleSettingCell") as! SimpleSettingCell
            
            let title = data.title == nil ? "" : data.title
            var value = data.value
            
            if value == nil {
                cell.valueLabel.isHidden = true
                value = ""
            }
            
            cell.titleLabel.text = title
            cell.valueLabel.text = value
            
            cell.backgroundColor = manager.getCardBackground()
            cell.contentView.backgroundColor = manager.getCardBackground()
            cell.titleLabel.textColor = manager.getTextColor()
            cell.valueLabel.textColor = manager.getTextColorSecondary()
            
            if data.clickable {
                cell.clickableIndicatorImg.isHidden = false
            }
            return cell
        }
        
    }
    
    func makeSimpleAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func makeLicenseAlert() {
        let title = NSLocalizedString("license_title", comment: "license_title")
        
        var msg = "\n"
        for s in licenses {
            msg += s + "\n\n"
        }
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //TODO: https://swifter.kr/2017/01/05/swift3기준-메일보내기-간단하게-추가방법/
    func makeEmailAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("alert_email_title", comment: "alert_email_title"), message: NSLocalizedString("alert_email_msg", comment: "alert_email_msg"), preferredStyle: .actionSheet)
        let directAction = UIAlertAction(title: NSLocalizedString("alert_email_direct", comment: "alert_email_direct"), style: .default, handler: {
            (action) -> Void in
            if MFMailComposeViewController.canSendMail() {
                let device = UIDevice.current
                let basicInfo = "기기 종류: " + device.model + "\niOS버전: " + device.systemVersion + "\n\n내용: (아래에 문의 내용을 입력해 주세요)\n\n\n\n"
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["soc06212@gmail.com"])
                mail.setSubject("[iOS 강고 포켓] 제목: ")
                mail.setMessageBody(basicInfo, isHTML: false)
                self.present(mail, animated: true)
            } else {
                self.makeSimpleAlert(title: "이메일 보내기 실패", msg: "Mail 앱으로 이메일을 보낼 수 없습니다.")
            }
        })
        let copyAction = UIAlertAction(title: NSLocalizedString("alert_email_copy", comment: "alert_email_copy"), style: .default, handler: {
            (action) -> Void in
            UIPasteboard.general.string = "soc06212@gmail.com"
            self.makeSimpleAlert(title: NSLocalizedString("alert_email_copied", comment: "alert_email_copied"), msg: NSLocalizedString("alert_email_copied_msg", comment: "alert_email_copied_msg"))
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil)
        alertController.addAction(directAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    var easterEggCount = 0
    var developerOptionCount = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let selectedData = settingData[(indexPath?.row)!]
        
        switch selectedData.id {
        case "license_info"?:
            makeLicenseAlert()
            break
        case "donation"?:
            self.performSegue(withIdentifier: "segDonation", sender: nil)
            break
        case "facebook"?:
            openURL(urlString: "https://www.facebook.com/ridsoftkr/")
            break
        case "telegram"?:
            openURL(urlString: "https://t.me/soc06212")
            break
        case "kakaotalk"?:
            openURL(urlString: "http://pf.kakao.com/_uaxkxaC")
            break
        case "email"?:
            makeEmailAlert()
            break
        case "developer"?:
            if (developerOptionCount == 10) {
                developerOptionCount = 0
                let alert = UIAlertController(title: "Devloper Option", message: "type passcode", preferredStyle: .alert)
                alert.addTextField { (pwTextField) in
                    pwTextField.placeholder = "c*****6***"
                }
                let confirm = UIAlertAction(title: "confirm", style: .default) { (confirm) in
                    if alert.textFields != nil {
                        let pw = alert.textFields?[0].text
                        if pw != nil && pw == "choi006447" {
                            self.performSegue(withIdentifier: self.segDevOption, sender: nil)
                        }
                    }
                }
                let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in
                    
                }
                alert.addAction(confirm)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            } else {
                developerOptionCount+=1
            }
            break
        case "version"?:
            easterEggCount+=1
            if easterEggCount > 5 {
                easterEggCount = 0
                performSegue(withIdentifier: segEasterEgg, sender: nil)
            }
            break
        case "open_setting"?:
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            break
        case "info_student_account"?:
            let userDefault = UserDefaults(suiteName: "group.KanggoPocket")!
            let name = userDefault.string(forKey: UserDefaultsKeys().STRING_NAME)! + "학생, "
            let grade = String(userDefault.integer(forKey: UserDefaultsKeys().INT_GRADE)) + "학년 "
            let classNum = String(userDefault.integer(forKey: UserDefaultsKeys().INT_CLASS)) + "반 "
            let stdNum = String(userDefault.integer(forKey: UserDefaultsKeys().INT_NUMBER)) + "번 "
            let msg = "\n\n학생 정보 수정은 \'투데이 탭\'의 상단 아이콘을 눌러 이용해주시기 바랍니다!"
            makeSimpleAlert(title: "학생 정보", msg: name + grade + classNum + stdNum + msg)
            break
        default:
            break
        }
        if !selectedData.isGroup {
            let cell = tableView.cellForRow(at: indexPath!) as! SimpleSettingCell
            cell.isSelected = false
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("취소")
        case .saved:
            print("임시저장")
        case .sent:
            print("전송완료")
        default:
            print("전송실패")
        }
        dismiss(animated: true, completion: nil)
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

class SettingModel {
    var title: String? = nil
    var value: String? = nil
    var isGroup: Bool = false
    var id: String? = nil
    var clickable: Bool = false
    init(title: String?, value: String?, id: String) {
        self.title = title
        self.value = value
        self.isGroup = false
        self.id = id
        self.clickable = false
    }
    init(title: String?, id: String, clickable: Bool) {
        self.title = title
        self.value = nil
        self.isGroup = false
        self.id = id
        self.clickable = false
    }
    init(title: String?, id: String) {
        self.title = title
        self.value = nil
        self.isGroup = false
        self.id = id
        self.clickable = true
    }
    init(title: String?, value: String?, isGroup: Bool?) {
        self.title = title
        self.value = value
        self.isGroup = isGroup == nil ? false : isGroup!
    }
    init(title: String?) {
        self.title = title
        self.isGroup = true
    }
    init(title: String?, value: String?) {
        self.title = title
        self.value = value
        self.isGroup = false
    }
}

class GroupCell : UITableViewCell {
    @IBOutlet weak var groupTitleLabel: UILabel!
    
}

class SimpleSettingCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var clickableIndicatorImg: UIImageView! {
        didSet {
            clickableIndicatorImg.isHidden = true
        }
    }
}
