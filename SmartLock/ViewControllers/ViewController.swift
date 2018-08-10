//
//  ViewController.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2017/11/13.
//  Copyright © 2017年 会津慎弥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let viewModel = KeyControlViewModel()
    private let wifi = Wifi()
    
    let xibView = KeyControlView(frame: CGRect(x: 0, y: 0, width: UIScreenUtil.screenWidth(), height: UIScreenUtil.screenHeight()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(xibView)

        if !isWifiConnected(){
            connect()
        }
        bind()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isWifiConnected() -> Bool {
        let interfaces = CNCopySupportedInterfaces()
        let count = CFArrayGetCount(interfaces)
        if count > 0 {
            let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, 0)
            let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
            let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
            if unsafeInterfaceData != nil {
                let interfaceData = unsafeInterfaceData as Dictionary?
                let ssid = interfaceData!["SSID" as NSObject] as! String
                if ssid == wifi.ssid {
                    return true
                }
            }
        }
        
        return false
    }
    
    func connect(){
        let manager = NEHotspotConfigurationManager.shared
        let isWEP = false
        let hotspotConfiguration = NEHotspotConfiguration(ssid: wifi.ssid, passphrase: wifi.password, isWEP: isWEP)
        hotspotConfiguration.joinOnce = true
        hotspotConfiguration.lifeTimeInDays = 1
        
        manager.apply(hotspotConfiguration) { (error) in
            if let error = error {
                print(error)
                //Todo try connect or already alert
            } else {
                print("success")
            }
        }
    }
    
    func bind(){
        viewModel.repos.asObservable()
            .filter { x in
                return !x.isEmpty
            }
            .subscribe(onNext: { [unowned self] x in
                print("request!")
                }, onError: { error in
            }, onCompleted: { () in
            }, onDisposed: { () in
            })
            .disposed(by: disposeBag)
        
        xibView.openButton.rx.tap
            .subscribe(onNext: { self.viewModel.keyControl(status: "open") })
            .disposed(by: disposeBag)
        
        xibView.closeButton.rx.tap
            .subscribe(onNext: { self.viewModel.keyControl(status: "close") })
            .disposed(by: disposeBag)
    }
    
    
}
