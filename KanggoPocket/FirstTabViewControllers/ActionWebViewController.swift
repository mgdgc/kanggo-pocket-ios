//
//  ActionWebViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 4. 22..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit
import WebKit

class ActionWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webKitView: WKWebView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webKitView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webKitView.uiDelegate = self
        webKitView.navigationDelegate = self
        view = webKitView
        
        setWebKitView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        webKitView.backgroundColor = manager.getBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setWebKitView() {
        if urlString == nil {
            return
        }
        guard let url = URL(string: urlString!) else {
            return
        }
        let request = URLRequest(url: url)
        webKitView.load(request)
    }
    
    @IBAction func openSafari(_ sender: Any) {
        if urlString != nil {
            openURL(urlString: urlString!)
        }
    }
    
    func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
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
