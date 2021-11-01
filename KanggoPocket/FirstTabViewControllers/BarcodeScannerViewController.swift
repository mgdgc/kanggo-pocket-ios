//
//  BarcodeScannerViewController.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 8. 5..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        captureSession = AVCaptureSession()
        
        var captureDevice: AVCaptureDevice?
        
        if #available(iOS 10.2, *) {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
            
            guard let device = deviceDiscoverySession.devices.first else {
                print("failed to get back camera")
                let alert = dataManager.makeSimpleAlert(title: NSLocalizedString("failed_to_get_camera", comment: "failed_to_get_camera"), message: NSLocalizedString("failed_to_get_camera_msg", comment: "failed_to_get_camera_msg"))
                present(alert, animated: true, completion: nil)
                return
            }
            captureDevice = device
        } else {
            // Fallback on earlier versions
            guard let device = AVCaptureDevice.default(for: .video) else {
                print("failed to get back camera")
                let alert = dataManager.makeSimpleAlert(title: NSLocalizedString("failed_to_get_camera", comment: "failed_to_get_camera"), message: NSLocalizedString("failed_to_get_camera_msg", comment: "failed_to_get_camera_msg"))
                
                present(alert, animated: true, completion: nil)
                return
            }
            captureDevice = device
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code39]
            
        } catch {
            print(error)
            let alert = dataManager.makeSimpleAlert(title: NSLocalizedString("failed_barcode_reading", comment: "failed_barcode_reading"), message: NSLocalizedString("failed_barcode_reading_msg", comment: "failed_barcode_reading_msg"))
            present(alert, animated: true, completion: nil)
        }
        
        // initializing video preview layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = cameraPreview.bounds
        cameraPreview.layer.addSublayer(videoPreviewLayer!)
        
        // start video capture
        captureSession?.startRunning()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            statusLabel.text = NSLocalizedString("no_barcode_detected", comment: "no_barcode_detected")
            print("no barcode detected")
            return
        }
        
        for i in 0..<metadataObjects.count {
            let metadataObject = metadataObjects[i] as! AVMetadataMachineReadableCodeObject
            if metadataObject.type != AVMetadataObject.ObjectType.code39 {
                statusLabel.text = NSLocalizedString("inappropriate_code", comment: "inappropriate_code")
                continue
            }
            
            if metadataObject.stringValue != nil {
                statusLabel.text = NSLocalizedString("barcode_found", comment: "barcode_found")
                print("Barcode string value: \(metadataObject.stringValue)")
                saveCodeInfo(value: metadataObject.stringValue!)
                return
            }
        }
        
        statusLabel.text = NSLocalizedString("no_barcode_detected", comment: "no_barcode_detected")
        print("no barcode detected")
        return
        
    }
    
    func saveCodeInfo(value: String) {
        let alert = dataManager.makeAlert(title: NSLocalizedString("barcode_successed", comment: "barcode_successed"), message: NSLocalizedString("barcode_successed_msg", comment: "barcode_successed_msg"), cancelable: false) { (action) in
            
            let userDefaults = UserDefaults(suiteName: "group.KanggoPocket")!
            userDefaults.set(value, forKey: UserDefaultsKeys().STRING_STUDENT_ID_CODE)
            userDefaults.synchronize()
            self.dismiss(animated: true, completion: nil)
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
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
