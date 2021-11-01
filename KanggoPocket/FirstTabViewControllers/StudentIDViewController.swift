//
//  StudentIDViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 8. 5..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class StudentIDViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sInfoLabel: UILabel!
    @IBOutlet weak var barcodeView: UIImageView!
    
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Close button click action
    @IBAction func onCloseBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Delete button click action
    @IBAction func onDeleteBtnClick(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("sid_delete", comment: "sid_delete"), message: NSLocalizedString("sid_delete_msg", comment: "sid_delete_msg"), preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default) { (action) in
            let ud = UserDefaults(suiteName: "group.KanggoPocket")!
            ud.set("", forKey: UserDefaultsKeys().STRING_STUDENT_ID_CODE)
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func initData() {
        let userDefault = UserDefaults(suiteName: "group.KanggoPocket")!
        let name = userDefault.string(forKey: UserDefaultsKeys().STRING_NAME)!
        let grade = String(userDefault.integer(forKey: UserDefaultsKeys().INT_GRADE))
        let classNum = String(userDefault.integer(forKey: UserDefaultsKeys().INT_CLASS))
        let stdNum = String(userDefault.integer(forKey: UserDefaultsKeys().INT_NUMBER))
        let sinfo = "\(grade)학년 \(classNum)반 \(stdNum)번"
        
        nameLabel.text = name
        sInfoLabel.text = sinfo
        
        let manager = DataManager()
        let code = manager.getStudentIDCode()
        let barcode = manager.generateBarcode(code: code)
        
        barcodeView.image = barcode
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
