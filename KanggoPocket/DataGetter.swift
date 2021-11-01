//
//  DataGetter.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 3..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//
import SystemConfiguration

class DataGetter {
    
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
    
}
