//
//  DonationViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 2. 8..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class DonationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let data: [DonationModel] = [
        DonationModel.init(NSLocalizedString("donate_coffee", comment: "donate_coffee"), "1.99"),
        DonationModel.init(NSLocalizedString("donate_latte", comment: "donate_latte"), "3.99"),
        DonationModel.init(NSLocalizedString("donate_frappuccino", comment: "donate_frappuccino"), "5.99")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 0.341, blue: 0.133, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    
    //https://useyourloaf.com/blog/variable-height-table-view-header/
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let footerView = tableView.tableFooterView else {
            return
        }
        let footerSize = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if footerView.frame.size.height != footerSize.height {
            footerView.frame.size.height = footerSize.height
        }
        tableView.tableFooterView = footerView
        tableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.MenuLabel.text = data[row].title
        cell.priceLabel.text = data[row].price
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

struct DonationModel {
    var title: String?
    var price: String?
    init(_ title: String, _ price: String) {
        self.title = title
        self.price = price
    }
}

class MenuCell : UITableViewCell {
    @IBOutlet weak var MenuLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}


