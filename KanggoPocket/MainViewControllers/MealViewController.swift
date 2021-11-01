//
//  MealViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 2..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit
import os

class MealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewMealParserDelegate {
    
    @IBOutlet weak var updateIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weekSegment: UISegmentedControl!
    
    let titles = ["아침", "점심", "저녁"]
    var dates = [String?]()
    var breakfasts = [String?]()
    var lunches = [String?]()
    var dinners = [String?]()
    
    var data = Array<MealModel>()
    var selectedSegment = 0
    
    var newParser = NewMealParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        updateIndicator.hidesWhenStopped = true
        
        weekSegment.tintColor = ColorManager.colorAccent
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        tableView.backgroundColor = manager.getBackground()
        tableView.separatorColor = manager.getSeparatorColor()
        view.backgroundColor = manager.getBackground()
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateActionClick(_ sender: UIBarButtonItem) {
        if checkNetwork() {
            //startParse()
            
            let cityCode = "kwe.go.kr"
            let schoolCode = "K100000364"
            let date = ["2017", "12", "1"]
            
            let parser = MealParser()
            parser.getMealNew(cityCode: cityCode, schoolCode: schoolCode, schoolCategoryCode: parser.CAT_HIGH_SCHOOL, schoolKindCode: parser.KIND_HIGH_SCHOOL, mealCode: parser.MEAL_BREAKFAST, year: date[0], month: date[1], day: date[2])
            
        } else {
            makeNetworkErrorAlert()
        }
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        selectedSegment = weekSegment.selectedSegmentIndex
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let manager = ThemeManager()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealCell
        
        cell.title.text = titles[indexPath.row]
        cell.title.textColor = manager.getTextColor()
        cell.content.textColor = manager.getTextColor()
        cell.contentView.backgroundColor = manager.getBackground()
        cell.backgroundColor = manager.getBackground()
        
        var string = ""
        var contentText : String? {
            switch indexPath.row {
            case 0: return breakfasts[selectedSegment]
            case 1: return lunches[selectedSegment]
            case 2: return dinners[selectedSegment]
            default:
                return "정보 없음"
            }
        }
        
        if contentText == nil {
            string = "정보 없음"
        } else {
            string = contentText!
        }
        
        cell.content.text = string
        
        return cell
    }
    
    func initData() {
        let ud = UserDefaults(suiteName: "group.mealData")
        dates.removeAll()
        breakfasts.removeAll()
        lunches.removeAll()
        dinners.removeAll()
        for i in 1..<7 {
            dates.append(ud?.string(forKey: MealParser().getMealKeyScheme(dayOfWeek: i, mealOfDay: "0")))
            breakfasts.append(ud?.string(forKey: MealParser().getMealKeyScheme(dayOfWeek: i, mealOfDay: "1")))
            lunches.append(ud?.string(forKey: MealParser().getMealKeyScheme(dayOfWeek: i, mealOfDay: "2")))
            dinners.append(ud?.string(forKey: MealParser().getMealKeyScheme(dayOfWeek: i, mealOfDay: "3")))
        }
    }
    
    func onParseFinished(result: String) {
        print("\nFinal data: \(result)\n")
//        if newParser.convertData(data: result) {
//            print("\nconvert successful\n")
//        }
    }
    
    func onConvertFinished(meal: String) {
        print("\nmeal data: \(meal)\n")
    }
    
    func startParse() {
        let parser = MealParser()
        self.updateIndicator.startAnimating()
        
        DispatchQueue(label: "xyz.xyz.ridsoft.KanggoPocket.mealParse").async {
            
//            parser.saveMealData(data: self.doParse(parser: parser))
            self.doParse(parser: parser)
            self.initDataNew()
            
            DispatchQueue.main.async {
                self.updateIndicator.stopAnimating()
                self.initData()
                self.tableView.reloadData()
            }
        }
    }
    
    func initDataNew() {
        newParser.delegate = self
//        newParser.parseData(year: "2018", month: "5", day: "1", mealCode: newParser.lunch)
    }
    
    func doParse(parser: MealParser) -> [MealModel] {
        var result = Array<MealModel>()
        
        let cityCode = "kwe.go.kr"
        let schoolCode = "K100000364"
        //let date = getDate()
        let date = ["2017", "12", "1"]
        //TODO: 릴리즈 하기 전에 주석을 변경할 것.
        
        var breakfasts = [String?]()
        breakfasts = parser.getMeal(cityCode: cityCode, schoolCode: schoolCode, schoolCategoryCode: parser.CAT_HIGH_SCHOOL, schoolKindCode: parser.KIND_HIGH_SCHOOL, mealCode: parser.MEAL_BREAKFAST, year: date[0], month: date[1], day: date[2])
        
        var lunches = [String?]()
        lunches = parser.getMeal(cityCode: cityCode, schoolCode: schoolCode, schoolCategoryCode: parser.CAT_HIGH_SCHOOL, schoolKindCode: parser.KIND_HIGH_SCHOOL, mealCode: parser.MEAL_LUNCH, year: date[0], month: date[1], day: date[2])
        
        var dinners = [String?]()
        dinners = parser.getMeal(cityCode: cityCode, schoolCode: schoolCode, schoolCategoryCode: parser.CAT_HIGH_SCHOOL, schoolKindCode: parser.KIND_HIGH_SCHOOL, mealCode: parser.MEAL_DINNER, year: date[0], month: date[1], day: date[2])
        
        var dates = [String?]()
        dates = parser.getDate(cityCode: cityCode, schoolCode: schoolCode, schoolCategoryCode: parser.CAT_HIGH_SCHOOL, schoolKindCode: parser.KIND_HIGH_SCHOOL, year: date[0], month: date[1], day: date[2])
        
        for i in 0..<breakfasts.count {
            let model = MealModel(dayOfWeek: i, date: dates[i], breakfast: breakfasts[i], lunch: lunches[i], dinner: dinners[i])
            result.append(model)
        }
        
        return result
    }
    
    func getDate() -> [String] {
        var result = Array<String>()
        let today = Date.init()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy"
        result.append(formatter.string(from: today))
        formatter.dateFormat = "M"
        result.append(formatter.string(from: today))
        formatter.dateFormat = "d"
        result.append(formatter.string(from: today))
        return result
    }
    
    func checkNetwork() -> Bool {
        return DataManager().checkNetwork()
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

class MealCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
}





