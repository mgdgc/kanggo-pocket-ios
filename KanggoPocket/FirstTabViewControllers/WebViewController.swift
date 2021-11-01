//
//  WebViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 5. 18..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate, UIPickerViewDelegate, UIPickerViewDataSource, WebParserDelegate {
    
    func onTaskFinished(data: [WebObject]?) {
        
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateIndicator: UIActivityIndicatorView!
    
    var data: [WebObject] = []
    var siteMap: [SiteMapObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 62
        updateIndicator.hidesWhenStopped = true
        
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: view)
        }
        
        navigationItem.title = "공지사항"
    navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 0.341, blue: 0.133, alpha: 1.0)
        
        parseData(id: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        tableView.backgroundColor = manager.getTableViewBackground()
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        let data = self.data[position]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell") as! WebCell
        
        cell.titleView.text = data.title
        
        let detail = data.date + " | " + data.writer + " | 조회 " + data.viewCount
        cell.detailView.text = detail
        
        return cell
    }
    
    // 게시판 변경 버튼 클릭 시
    // PickerDialog: https://stackoverflow.com/questions/33233894/want-to-show-uipickerview-in-uialertcontroller-or-uipopovercontroller-swift#
    @IBAction func onCategoryChangeBtnClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: NSLocalizedString("category_change_dialog", comment: "category_change_dialog"), message: NSLocalizedString("category_change_dialog_msg", comment: "category_change_dialog_msg"), preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        let pickerFrame = CGRect(x: 17, y: 52, width: 270, height: 100)
        let picker = UIPickerView(frame: pickerFrame)
        
        picker.delegate = self
        picker.dataSource = self
        
        alert.view.addSubview(picker)
        present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return siteMap.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return siteMap.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return siteMap[component].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 만약 사용자가 카테고리 구분선을 선택했을 경우
        if (siteMap[component].id == "0") {
            let alert = DataManager().makeSimpleAlert(title: NSLocalizedString("category_change_dialog", comment: "category_change_dialog"), message: NSLocalizedString("alert_non_category_selected", comment: "alert_non_category_selected"))
            present(alert, animated: true, completion: nil)
        } else {
            parseData(id: siteMap[component].id)
            navigationItem.title = siteMap[component].title
        }
    }
    
    
    // Peek & Pop support
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        previewingContext.sourceRect = cell.frame
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WebDetailViewController") as? WebDetailViewController else {
            return nil
        }
        vc.documentId = data[indexPath.row].id
        vc.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        showDetailViewController(viewControllerToCommit, sender: self)
    }
    
    // parse data
    func parseData(id: String) {
        let parser = WebParser()
        parser.parseDocument(url: "http://kanggo.net/boardCnts/list.do?boardID=19202&m=0301&s=ganggo")
    }
    
    // set site maps to the self.siteMap
    func onSiteMapLoadFinished(siteMap: [SiteMapObject]) {
        self.siteMap = siteMap
    }
    
    // append data to self.data after the parsing process
    func onTaskFinished(data: [WebObject]) {
        for d in data {
            self.data.append(d)
        }
        tableView.reloadData()
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

class WebCell : UITableViewCell {
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var detailView: UILabel!
}




