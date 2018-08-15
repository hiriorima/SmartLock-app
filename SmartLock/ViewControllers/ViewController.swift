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
import NCMB

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let viewModel = KeyControlViewModel()
    private let wifi = Wifi()
    
    let xibView = KeyControlView(frame: CGRect(x: 0, y: 0, width: UIScreenUtil.screenWidth(), height: UIScreenUtil.screenHeight()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(xibView)
        
        if !wifi.isConnected(){
            self.wifiConnect()
        }
        getNewKeyStatus()
        bind()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNewKeyStatus(){
        let query = NCMBQuery(className: "status")
        query?.limit = 1
        query?.order(byDescending: "createDate")
        query?.findObjectsInBackground({ comments, error in
            let result = comments![0] as! NCMBObject
            let f = DateFormatter()
            f.setTemplate(.full)
            self.xibView.timeTextFIeld.text = f.string(for: result.createDate)
            self.xibView.controledTextField.text = result.object(forKey: "used") as? String
        })
    }
    
    func wifiConnect() {
        let result = wifi.connect()
        if result {
            self.showErrorAlert()
        }
    }
    
    func showErrorAlert(){
        UIAlertController(title: "Error", message: "もう一度接続を試みますか？", preferredStyle: .alert)
            .addAction(title: "はい") { action in
                self.wifiConnect()
            }
            .addAction(title: "キャンセル", style: .cancel)
            .show()
    }
    
    func bind(){
        viewModel.repos.asObservable()
            .filter { x in
                return !x.isEmpty
            }
            .subscribe(onNext: { result in
                if result[0].status == "open" {
                    self.xibView.setCurrentLockStatus(isLock: false)
                } else if result[0].status == "close" {
                    self.xibView.setCurrentLockStatus(isLock: true)
                }
            }, onError: { error in
                UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    .addAction(title: "OK", style: .cancel)
                    .show()
            }, onCompleted: { () in
                self.getNewKeyStatus()
            }, onDisposed: { () in
            })
            .disposed(by: disposeBag)
        
        viewModel.error.asObservable()
            .subscribe(onNext: { error in
                if error != nil {
                    UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
                        .addAction(title: "OK", style: .cancel)
                        .show()
                }
            })
        
        xibView.openButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.keyControl(status: "open")
            })
            .disposed(by: disposeBag)
        
        xibView.closeButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.keyControl(status: "close")
            })
            .disposed(by: disposeBag)
    }
}
