//
//  AboutUserInfoViewController.swift
//  KanggoPocket
//
//  Created by 최명근 on 2017. 10. 6..
//  Copyright © 2017년 RiDsoft. All rights reserved.
//

import UIKit
import WebKit

class AboutUserInfoViewController: UIViewController {
    
    @IBOutlet weak var userInfoWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://alpha57.tistory.com/16")
        let urlRequest = URLRequest(url: url!)
        userInfoWebView.load(urlRequest)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
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
