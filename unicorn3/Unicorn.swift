//
//  Unicorn.swfit.swift
//  unicorns2
//
//  Created by Rang, Winters on 2019/8/12.
//  Copyright © 2019 Rang, Winters. All rights reserved.
//

import Foundation

class Unicorn {
    var name: String?
    var logo_url: String?
    var permalink: String?
    var tag_page: String?
    var country: String?
    var last_funding_on: String?
    var total_equity_funding: Double?
    var founded_on: Int?
    var category: String?
    var rumored: Int?
    var post_money_val: Double?
    var valuation_change: Int?
    var date_of_valuation: String?
    
    static func getUnicorns(_ jsonDatas: [AnyObject])->  [Unicorn] {
        var unicorns = [Unicorn]()
        
        for jsonUnicorn in jsonDatas {
            let u = Unicorn()
            u.name = jsonUnicorn["name"] as? String
            u.country = jsonUnicorn["country"] as? String
            u.last_funding_on = jsonUnicorn[""] as? String
            u.total_equity_funding = jsonUnicorn["total_equity_funding"] as? Double
            u.founded_on = jsonUnicorn["founded_on"] as? Int
            u.category = jsonUnicorn["category"] as? String
            u.rumored = jsonUnicorn["rumored"] as? Int
            u.post_money_val = jsonUnicorn["post_money_val"] as? Double
            u.valuation_change = jsonUnicorn["valuation_change"] as? Int
            u.date_of_valuation = jsonUnicorn["date_of_valuation"] as? String
            unicorns.append(u)
        }
        
        return unicorns
        
    }
 
}
