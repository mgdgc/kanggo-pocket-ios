//
//  DataManager.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 3..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//
import SystemConfiguration
import UIKit
import RSBarcodes_Swift
import AVFoundation

class DataManager {
    
    // How to use SCNetworkReachability in Swift
    // https://stackoverflow.com/questions/25623272/how-to-use-scnetworkreachability-in-swift
    func checkNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: sockaddr_in()))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)}
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    public func checkStudentIDAvailable() -> Bool {
        let ud = UserDefaults(suiteName: "group.KanggoPocket")!
        let code = ud.string(forKey: UserDefaultsKeys().STRING_STUDENT_ID_CODE)
        return !(code == nil || code == "" || code == "0")
    }
    
    public func getStudentIDCode() -> String {
        let ud = UserDefaults(suiteName: "group.KanggoPocket")!
        let code = ud.string(forKey: UserDefaultsKeys().STRING_STUDENT_ID_CODE)
        return code == nil ? "" : code!
    }
    
    public func generateBarcode(code: String) -> UIImage? {
//        let data = code.data(using: String.Encoding.ascii)
//
//        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
//            print("filter is nil")
//            return nil
//        }
//
//        filter.setValue(data, forKey: "inputMessage")
//
//        let transformed = CGAffineTransform(scaleX: 3, y: 3)
//        guard let output = filter.outputImage?.transformed(by: transformed) else {
//            print("output is nil")
//            return nil
//        }
//
//        return UIImage(ciImage: output)
        
//        let barcode = RSCode39Generator.generateCode(code, filterName: "inputMessage")
        let barcode = RSUnifiedCodeGenerator.shared.generateCode(code, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
        
        return barcode
    }
    
    // 재사용 가능 코드
    public func makeAlert(title: String, message: String, cancelable: Bool, action: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: action)
        alert.addAction(action)
        if cancelable {
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
        }
        return alert
    }
    
    public func makeSimpleAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
}
