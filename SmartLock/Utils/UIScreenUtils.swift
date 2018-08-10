//
//  File.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2017/11/17.
//  Copyright © 2017年 会津慎弥. All rights reserved.
//

import UIKit

struct UIScreenUtil {
    static func bounds()->CGRect{
        return UIScreen.main.bounds;
    }
    static func screenWidth()->Int{
        return Int( UIScreen.main.bounds.size.width);
    }
    static func screenHeight()->Int{
        return Int(UIScreen.main.bounds.size.height);
    }
}
