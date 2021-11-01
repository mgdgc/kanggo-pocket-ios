//
//  TodayViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 9..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class TodaysViewController: UITableViewController {

    let titles = ["시간표", "급식", "교실배치도", "생활 일과표", "학교 소개"]
    
    var data = Array<TodayFeedModel>()
    
    @IBOutlet var todaysTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        var cell: UITableViewCell?
        if position <= 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
            handleFeed(cell: cell! as! FeedCell, position: position)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
            handleSimpleFeed(cell: cell! as! SimpleCell, position: position)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        if (indexPath?.row)! >= 2 {
//            let cell = tableView.cellForRow(at: indexPath!) as! SimpleCell
            switch indexPath?.row {
            case 2?:
                performSegue(withIdentifier: "segSchoolMap", sender: nil)
                break
            default:
                break
            }
        } else {
            let cell = tableView.cellForRow(at: indexPath!) as! FeedCell
            cell.isSelected = false
        }
    }
    
    func handleFeed(cell: FeedCell, position: Int) {
        let attachment = FeedAttachment()
        attachment.image = UIImage(named: data[position].icon!)
        let attachmentString = NSAttributedString(attachment: attachment)
        let contentString = NSMutableAttributedString(string: "")
        contentString.append(attachmentString)
        contentString.append(NSMutableAttributedString(string: "  " + data[position].title!))
        cell.title.attributedText = contentString
        
        if position == 0 {
            cell.title.textColor = UIColor(named: "color_teal")!
        } else if position == 1 {
            cell.title.textColor = UIColor(named: "color_orange")!
        }
        
        cell.content.text = data[position].content
    }
    
    func handleSimpleFeed(cell: SimpleCell, position: Int) {
        let attachment = FeedAttachment()
        attachment.image = UIImage(named: data[position].icon!)
        let attachmentString = NSAttributedString(attachment: attachment)
        let contentString = NSMutableAttributedString(string: "")
        contentString.append(attachmentString)
        contentString.append(NSMutableAttributedString(string: "  " + data[position].title!))
        cell.title.attributedText = contentString
    }
    
    func initData() {
        data = [TodayFeedModel(title: "시간표", content: getScheduleData(), icon: "ic_assignment_teal"),
        
        TodayFeedModel(title: "급식", content: "사골우거지국^5.6.13.\n곤드레밥/양념장^5.6.13.\n훈제오리구이*머스타드S1.5.13.\n부추양파무침^5.6.13.\n포기김치9.13.\n인절미오쟁이팥떡5.13.\n", icon: "ic_local_dining_orange"),
        
        TodayFeedModel(title: "교실배치도", content: "", icon: "ic_map"),
        
        TodayFeedModel(title: "생활 일과표", content: "", icon: "ic_list"),
        
        TodayFeedModel(title: "학교 소개", content: "", icon: "ic_chrome_reader_mode")]
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
    
    func getDayOfWeek() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = calendar.dateComponents([.weekday], from: now)
        return comps.weekday!
    }

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
    var title : String?
    var content : String?
    var icon : String?
    init(title: String, content: String, icon: String) {
        self.title = title
        self.content = content
        self.icon = icon
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
