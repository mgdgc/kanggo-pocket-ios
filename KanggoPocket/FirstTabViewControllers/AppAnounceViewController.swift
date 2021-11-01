//
//  AppAnounceViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 3. 21..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

protocol AnnounceDelegate: class {
    func onActionButtonClick(_ sender: AnnouneCell)
}

class AppAnounceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AnnounceDelegate {
    
    @IBOutlet weak var announceTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var data = Array<AnnounceModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        announceTableView.delegate = self
        announceTableView.dataSource = self
        
        activityIndicator.hidesWhenStopped = true
        
        if ThemeManager().isDarkMode() {
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        } else {
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        }
        
        navigationController?.navigationBar.tintColor = ColorManager.colorOrange
        
        if checkNetwork() {
            initData()
        } else {
            makeNetworkErrorAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        view.backgroundColor = manager.getTableViewBackground()
        announceTableView.backgroundColor = manager.getTableViewBackground()
        announceTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func initData() {
        activityIndicator.startAnimating()
        DispatchQueue(label: "xyz.xyz.ridsoft.KanggoPocket.AppAnnounceParse").async {
            let parser = AppAnnounceParser.init()
            let parsedData = parser.getData()
            print("--------------------------------------")
            print("parseData.count: " + String(parsedData.count))
            for data in parsedData {
                if data.id == "kp_ios" || data.id == "all" {
                    let action = data.action!.components(separatedBy: "|")
                    var actionText: String? = nil
                    var actionLink: String? = nil
                    if action.count == 2 {
                        actionText = data.action!.components(separatedBy: "|")[0]
                        actionLink = data.action!.components(separatedBy: "|")[1]
                    }
                    self.data.append(AnnounceModel.init(data.date, data.title, data.content, actionText, actionLink))
                    self.data.reverse()
                }
            }
            DispatchQueue.main.async {
                self.announceTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounceCell", for: indexPath) as! AnnouneCell
        
        cell.delegate = self
        
        cell.titleView.text = data[position].title
        cell.messageView.text = data[position].message
        
        let manager = ThemeManager()
        cell.backgroundColor = manager.getTableViewBackground()
        cell.contentView.backgroundColor = manager.getTableViewBackground()
        cell.cardView.backgroundColor = manager.getCardBackground()
        cell.dateView.textColor = manager.getTextColorSecondary()
        cell.titleView.textColor = manager.getTextColor()
        cell.messageView.textColor = manager.getTextColor()
        cell.actionButton.tintColor = ColorManager.colorOrange
        
        if data[position].actionText != nil && data[position].actionURL != nil {
            cell.actionButton.titleLabel?.text = data[position].actionText!
        }
        if data[position].date == "" || data[position].date == "정보 없음" {
            cell.dateView.isHidden = true
        } else {
            cell.dateView.text = data[position].date
        }
        if data[position].actionText == nil || data[position].actionURL == nil {
            cell.actionButton.isHidden = true
        } else {
            cell.actionButton.setTitle(data[position].actionText, for: .normal)
        }
        
        return cell
    }
    
    var actionLink = ""
    func onActionButtonClick(_ sender: AnnouneCell) {
        guard let indexPath = announceTableView.indexPath(for: sender) else { return }
        let actionLink = data[indexPath.row].actionURL
        if actionLink != nil {
            self.actionLink = actionLink!
        }
        performSegue(withIdentifier: "segActionLink", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segActionLink" {
            guard let vc = segue.destination as? ActionWebViewController else {
                return
            }
            vc.urlString = actionLink
        }
    }
    
    @IBAction func onRefreshClick(_ sender: Any) {
        data.removeAll()
        initData()
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

class AnnouneCell: UITableViewCell {
    weak var delegate: AnnounceDelegate?
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 10
            cardView.layer.masksToBounds = false
            cardView.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
            cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
            cardView.layer.shadowOpacity = 0.16
        }
    }
    @IBAction func onActionButtonClick(_ sender: UIButton) {
        delegate?.onActionButtonClick(self)
    }
}

class AnnounceModel {
    var date: String
    var title: String
    var message: String
    var actionText: String?
    var actionURL: String?
    init(_ date: String, _ title: String, _ msg: String, _ actionText: String?, _ actionURL: String?) {
        self.title = title
        self.message = msg
        self.actionText = actionText
        self.actionURL = actionURL
        self.date = date
    }
    init(_ date: String, _ title: String, _ msg: String) {
        self.date = date
        self.title = title
        self.message = msg
        self.actionText = nil
        self.actionURL = nil
    }
}



