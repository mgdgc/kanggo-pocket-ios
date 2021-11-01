//
//  TodayViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 9..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class TodaysViewController: UITableViewController {
    
    // segue identifiers
    private let segAppAnounce = "segAppAnounce"
    private let segSchoolMap = "segSchoolMap"
    private let segWebViewer = "segWebViewer"
    private let segMakeStudentID = "segMakeSID"
    private let segStudentID = "segStudentID"
    
    
    var data = Array<TodayFeedModel>()
    
    @IBOutlet var todaysTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        
        
        firstSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        tableView.backgroundColor = manager.getTableViewBackground()
        
        initData()
        self.tableView.reloadData()
    }
    
    func initData() {
        data = [
            TodayFeedModel(title: "시간표", content: getScheduleData(), icon: "ic_assignment_teal", id: "id_schedule"),
            TodayFeedModel(title: "급식", content: getMealData(), icon: "ic_local_dining_orange", id: "id_meal"),
            TodayFeedModel(isSeparator: true),
            TodayFeedModel(title: "앱 공지사항", content: "", icon: "ic_announcement", id: "id_announce"),
            TodayFeedModel(title: "교실배치도", content: "", icon: "ic_map", id: "id_map"),
//            TodayFeedModel(title: "강고 웹 뷰어", content: "", icon: "ic_public", id: "id_web_viewer")
//            TodayFeedModel(title: "생활 일과표", content: "", icon: "ic_list"),
//            TodayFeedModel(title: "학교 소개", content: "", icon: "ic_chrome_reader_mode")
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let manager = ThemeManager()
        
        let position = indexPath.row
        var cell: UITableViewCell?
        
        if position <= 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
            handleFeed(cell: cell! as! FeedCell, position: position)
        } else {
            if data[position].isSeparator {
                cell = tableView.dequeueReusableCell(withIdentifier: "CellSeperator", for: indexPath)
                let separator = cell as! SeparatorCell
                separator.labelView.textColor = manager.getTextColorSecondary()
                separator.backgroundColor = manager.getTableViewBackground()
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
                let simple = cell as! SimpleCell
                handleSimpleFeed(cell: cell! as! SimpleCell, position: position)
            }
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        if indexPath.row >= 2 {
            let id = data[indexPath.row].id
            switch (id) {
            case "id_schedule":
                let cell = tableView.cellForRow(at: indexPath) as! SeparatorCell
                cell.isSelected = false
                break
                
            case "id_meal":
                let cell = tableView.cellForRow(at: indexPath) as! SeparatorCell
                cell.isSelected = false
                break
                
            case "id_announce":
                performSegue(withIdentifier: segAppAnounce, sender: nil)
                break
                
            case "id_map":
                performSegue(withIdentifier: segSchoolMap, sender: nil)
                break
                
            case "id_web_viewer":
                performSegue(withIdentifier: segWebViewer, sender: nil)
                break
                
            default:
                break
            }
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! FeedCell
            cell.isSelected = false
        }
    }
    
    func handleFeed(cell: FeedCell, position: Int) {
        let manager = ThemeManager()
        cell.backgroundColor = manager.getCardBackground()
        
        let attachment = FeedAttachment()
        attachment.image = UIImage(named: data[position].icon!)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let contentString = NSMutableAttributedString(string: "")
        
        contentString.append(attachmentString)
        contentString.append(NSMutableAttributedString(string: "  " + data[position].title!))
        
        cell.title.attributedText = contentString
        cell.backgroundColor = manager.getTableViewBackground()
        cell.contentView.backgroundColor = manager.getTableViewBackground()
        cell.cardView.backgroundColor = manager.getCardBackground()
        cell.content.textColor = manager.getTextColor()
        
        if position == 0 {
            if #available(iOS 11.0, *) {
                cell.title.textColor = UIColor(named: "color_teal")!
            } else {
                // Fallback on earlier versions
                cell.title.textColor = UIColor(red: 1.000, green: 0.341, blue: 0.133, alpha: 1.0)
            }
        } else if position == 1 {
            if #available(iOS 11.0, *) {
                cell.title.textColor = UIColor(named: "color_orange")!
            } else {
                // Fallback on earlier versions
                cell.title.textColor = UIColor(red: 0.0, green: 0.588, blue: 0.533, alpha: 1.0)
            }
        }
        
        cell.content.text = data[position].content
    }
    
    func handleSimpleFeed(cell: SimpleCell, position: Int) {
        cell.title.text = data[position].title
        cell.title.textColor = ThemeManager().getTextColorSecondary()
        cell.contentView.backgroundColor = ThemeManager().getTableViewBackground()
    }
    
    func getScheduleData() -> String {
        var weekCode = 0
        if getDayOfWeek() >= 2 && getDayOfWeek() < 7 {
            weekCode = getDayOfWeek() - 2
        }
        let key = String(UserDefaults(suiteName: "group.KanggoPocket")!.integer(forKey: UserDefaultsKeys().INT_GRADE)) + "-"
            + String(UserDefaults(suiteName: "group.KanggoPocket")!.integer(forKey: UserDefaultsKeys().INT_CLASS)) + "-"
            + String(weekCode)
        let defaults = UserDefaults(suiteName: "group.scheduleData")!
        var schedule = defaults.string(forKey: key)
        if schedule == nil {
            schedule = NSLocalizedString("no_data", comment: "no_data")
        }
        return schedule!
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
    
    func getDayOfWeek() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = calendar.dateComponents([.weekday], from: now)
        return comps.weekday!
    }

    @IBAction func onStudentIDClick(_ sender: UIBarButtonItem) {
        if DataManager().checkStudentIDAvailable() {
            performSegue(withIdentifier: segStudentID, sender: nil)
        } else {
            performSegue(withIdentifier: segMakeStudentID, sender: nil)
        }
    }
    
    func firstSetting() {
        if isFirst() {
            performSegue(withIdentifier: "segFirstSetting", sender: self)
        }
    }
    
    func isFirst() -> Bool {
        let ud = UserDefaults.standard
        guard let isFirst = ud.object(forKey: UserDefaultsKeys().BOOL_IS_FIRST) else {
            return true
        }
        return isFirst as! Bool
    }
}

class SeparatorCell : UITableViewCell {
    @IBOutlet weak var labelView: UILabel!
}

class FeedCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 10
            cardView.layer.masksToBounds = false
                        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
                        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
                        cardView.layer.shadowOpacity = 0.16
        }
    }
    
}

class SimpleCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
}

class TodayFeedModel {
    var isSeparator = false
    var title : String?
    var content : String?
    var icon : String?
    var id: String?
    init(title: String, content: String, icon: String, id: String) {
        self.title = title
        self.content = content
        self.icon = icon
        self.isSeparator = false
        self.id = id
    }
    init(isSeparator: Bool) {
        self.isSeparator = isSeparator
        self.title = nil
        self.content = nil
        self.icon = nil
        self.id = nil
    }
}

// 참조: https://medium.com/@y8k/가변-문자열-끝에-이미지-붙이기-126a48b6aa52
class FeedAttachment : NSTextAttachment {
    var topSpace: Float = -3.5
    convenience init (image: UIImage, topSpace : Float = 0.0) {
        self.init()
        self.image = image
        self.topSpace = 0.0
    }
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let imageSize = image!.size
        return CGRect(x: 0.0, y: CGFloat(topSpace), width: imageSize.width, height: imageSize.height)
    }
}
