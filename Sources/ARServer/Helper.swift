//
//  Helper.swift
//  ARServer
//
//  Created by Denis Bystruev on 12.12.2019.
//

import Foundation
import Kitura
import HeliumLogger
import LoggerAPI

func getPost(for request: RouterRequest, fields: [String]) -> [String: String]? {
    guard let values = request.body else { return nil }
    Log.debug("\(values)")
    
    guard case .urlEncoded(let body) = values else { return nil }
    
    var result = [String: String]()
    
    for field in fields {
        if let value = body[field]?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if 0 < value.count {
                result[field] = value.removeHTMLEncoding()
                continue
            }
        }
        
        return nil
    }
    
    return result
}

func send(error: String, code: HTTPStatusCode, to response: RouterResponse) {
    _ = try? response.status(code).send(error).end()
}

extension String {
    func removeHTMLEncoding() -> String {
        let result = replacingOccurrences(of: "+", with: " ")
        
        return result.removingPercentEncoding ?? result
    }
}
