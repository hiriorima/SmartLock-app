//
//  Date+Extension.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2018/08/16.
//  Copyright © 2018年 会津慎弥. All rights reserved.
//

import Foundation

extension DateFormatter {
    // テンプレートの定義(例)
    enum Template: String {
        case date = "yMd"     // 2017/1/1
        case time = "Hms"     // 12:39:22
        case full = "yMdkHms" // 2017/1/1 12:39:22
        case onlyHour = "k"   // 17時
        case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case weekDay = "EEEE" // 日曜日
    }
    // 冗長な関数のためラップ
    func setTemplate(_ template: Template) {
        // optionsは拡張のためにあるが使用されていない引数
        // localeは省略できないがほとんどの場合currentを指定する
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}
