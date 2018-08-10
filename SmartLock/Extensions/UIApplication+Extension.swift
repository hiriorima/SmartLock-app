//
//  UIApplication+Extension.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2018/08/10.
//  Copyright © 2018年 会津慎弥. All rights reserved.
//

import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}
