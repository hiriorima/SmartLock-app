//
//  Wifi.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2018/08/10.
//  Copyright © 2018年 会津慎弥. All rights reserved.
//

import NetworkExtension
import SystemConfiguration.CaptiveNetwork

struct Wifi {
    let ssid = ""
    let password = ""
    
    func isConnected() -> Bool {
        let interfaces = CNCopySupportedInterfaces()
        let count = CFArrayGetCount(interfaces)
        if count > 0 {
            let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, 0)
            let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
            let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
            if unsafeInterfaceData != nil {
                let interfaceData = unsafeInterfaceData as Dictionary?
                let ssid = interfaceData!["SSID" as NSObject] as! String
                if ssid == Wifi().ssid {
                    return true
                }
            }
        }
        
        return false
    }
    
    func connect() -> Bool {
        let manager = NEHotspotConfigurationManager.shared
        let isWEP = false
        let hotspotConfiguration = NEHotspotConfiguration(ssid: Wifi().ssid, passphrase: Wifi().password, isWEP: isWEP)
        hotspotConfiguration.joinOnce = true
        hotspotConfiguration.lifeTimeInDays = 1
        
        var isConnect = false
        
        manager.apply(hotspotConfiguration) { (error) in
            if let error = error {
                if error.localizedDescription as String != "already associated." {
                    isConnect = true
                }
            } else {
                isConnect = true
            }
        }
        return isConnect
    }
}
