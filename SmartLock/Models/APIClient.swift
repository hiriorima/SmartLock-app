//
//  APIClient.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2017/11/17.
//  Copyright © 2017年 会津慎弥. All rights reserved.
//

import APIKit
import Himotoki

protocol KeyRequest: Request {
    
}

extension KeyRequest {
    var baseURL: URL {
        return URL(string: "https://192.168.1.11:8000")!
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}

extension KeyRequest where Response: Himotoki.Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}

struct ControlKeyRequest: KeyRequest {
    var status: String
    var method: HTTPMethod {
        return .post
    }
    var path: String {
        return "/api/keys"
    }
    typealias Response = KeyStatusRepository
    
    init(status: String) {
        self.status = status
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> ControlKeyRequest.Response {
        return try decodeValue(object)
    }
}
