//
//  TestPageViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 9..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class TestPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var data = Array<String>()
    
    let userDefault = UserDefaults(suiteName: "group.KanggoPocket")!
    var name: String = ""
    var grade: Int = 0
    var classNum: Int = 0
    var stdNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.delegate = self
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTestParseClick(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.searchField) {
            self.searchField.resignFirstResponder()
            
            label.text = data[Int(textField.text!)!]
            
        }
        return true
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
