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
        bind()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
