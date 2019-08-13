//
//  UnicornAPIURLs.swift
//  unicorn3
//
//  Created by Rang, Winters on 2019/8/13.
//  Copyright © 2019 Rang, Winters. All rights reserved.
//

import Foundation

class UnicornAPIURLs {
    
    static let instance = UnicornAPIURLs()
    
    private let server = "http://localhost:3000/unicorns"
    
    func getUnicorns() -> String {
        return server
    }
    
    func getUnicorn(name: String ) -> String {
        let url = server + "/" + name
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let result = encodedString ?? ""
        return result
    }
}
