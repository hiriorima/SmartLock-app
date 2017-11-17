//
//  keyStatusRepository.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2017/11/17.
//  Copyright © 2017年 会津慎弥. All rights reserved.
//

import Himotoki

struct KeyStatusRepository: Himotoki.Decodable {
    let status: String
    
    static func decode(_ e: Extractor) throws -> KeyStatusRepository {
        return try KeyStatusRepository(
            status: e <| "status"
        )
    }
}
