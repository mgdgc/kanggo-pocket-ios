//
//  SchoolMapViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 22..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit

class SchoolMapViewController: UIViewController, UIScrollViewDelegate {
    
    public let KEY_SCHOOL_MAP = "school_map";
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var updateIndicator: UIActivityIndicatorView!
    
    private var mapImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateIndicator.hidesWhenStopped = true
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        mapImage = loadImage()
        if mapImage != nil {
            mapImageView.image = mapImage
        } else {
            parseSchoolMapData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = ThemeManager()
        navigationController?.navigationBar.barTintColor = manager.getBackground()
        navigationController?.navigationBar.tintColor = ColorManager.colorAccent
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : manager.getTextColor()]
        scrollView.backgroundColor = manager.getBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    
    @IBAction func onUpdateButtonClick(_ sender: Any) {
        parseSchoolMapData()
    }
    
    func parseSchoolMapData() {
        if (checkNetwork()) {
            updateIndicator.startAnimating()
            DispatchQueue(label: "xyz.ridsoft.kanggopocket.schoolmap").async {
                let parser = SchoolMapParser()
                if let imageUrl = parser.getImageUrl() {
                    print("image url: " + parser.getImageUrl()!)
                    self.mapImage = parser.getMapImage(urlString: imageUrl)
                    if self.mapImage != nil {
                        self.saveImage(image: self.mapImage!)
                    }
                }
                DispatchQueue.main.async {
                    print("school map load finished")
                    self.updateIndicator.stopAnimating()
                    
                    if self.mapImage != nil {
                        self.mapImageView.image = self.mapImage
                    } else {
                        self.makeFailedAlert()
                    }
                }
            }
        } else {
            makeNetworkErrorAlert()
        }
    }
    
    func saveImage(image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        UserDefaults.standard.set(imageData, forKey: KEY_SCHOOL_MAP)
        UserDefaults.standard.synchronize()
    }
    
    func loadImage() -> UIImage? {
        if let data = UserDefaults.standard.object(forKey: KEY_SCHOOL_MAP) as? Data {
            if let image = UIImage(data: data) {
                return image
            }
        }
        print("UserDefault image is nil")
        return nil
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
    
    func makeFailedAlert() {
        let title = NSLocalizedString("alert_map_failed", comment: "alert_map_failed")
        let msg = NSLocalizedString("alert_map_failed_msg", comment: "alert_map_failed_msg")
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
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
