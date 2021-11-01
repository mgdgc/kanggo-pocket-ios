//
//  AllergyViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 3..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class AllergyViewController: UIViewController {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var warningView: UILabel!
    @IBOutlet weak var allergyListView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnClose.setTitle(NSLocalizedString("close", comment: "close"), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        warningView.textColor = manager.getTextColor()
        allergyListView.textColor = manager.getTextColor()
        view.backgroundColor = manager.getBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseClick(_ sender: UIButton) {
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
