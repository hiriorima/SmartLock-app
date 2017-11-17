//
//  KeyControlViewModel.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2017/11/17.
//  Copyright © 2017年 会津慎弥. All rights reserved.
//

import UIKit
import RxSwift
import APIKit

class KeyControlViewModel: NSObject {

    private(set) var repos = Variable<[KeyStatusRepository]>([])
    
    private(set) var error = Variable<Error?>(nil)
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func keyControl(status: String){
        let request = ControlKeyRequest(status: status)
        Session.rx_sendRequest(request: request)
            .subscribe {
                [weak self] event in
                switch event {
                case .next(let repos):
                    self?.repos.value = [repos]
                case .error(let error): break
                self?.error.value = error
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
}
