//
//  DevViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 1..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class DevViewController: UIViewController {

    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = getUserDefaults()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getUserDefaults () -> String {
        let name = userDefault.string(forKey: UserDefaultsKeys().STRING_NAME)
        let grade = userDefault.integer(forKey: UserDefaultsKeys().INT_GRADE)
        let classNum = userDefault.integer(forKey: UserDefaultsKeys().INT_CLASS)
        let stdNum = userDefault.integer(forKey: UserDefaultsKeys().INT_NUMBER)
        return name! + String(grade) + String(classNum) + String(stdNum)
    }

    @IBAction func onBtnCloseClick(_ sender: UIButton) {
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
