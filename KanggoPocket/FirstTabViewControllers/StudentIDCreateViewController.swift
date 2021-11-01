//
//  StudentIDCreateViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 8. 5..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class StudentIDCreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if DataManager().checkStudentIDAvailable() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onAnalyzeBtnClick(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("sid_creator_alert", comment: "sid_creator_alert"), message: NSLocalizedString("sid_creator_alert_msg", comment: "sid_creator_alert_msg"), preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: NSLocalizedString("agree", comment: "agree"), style: .default) { (action) in
            self.performSegue(withIdentifier: "segAnalyze", sender: nil)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("disagree", comment: "disagree"), style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLaterBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
