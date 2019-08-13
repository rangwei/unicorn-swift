//
//  FundingRound.swift
//  unicorn3
//
//  Created by Rang, Winters on 2019/8/13.
//  Copyright © 2019 Rang, Winters. All rights reserved.
//

import Foundation

class FundingRound{
    var short_name: String?
    var valuation: String?
    var date: String?
    
    static func getFundings(_ dictionary: [String: Any]) -> [FundingRound] {
        
        var fundings = [FundingRound]()
        
        if let array = dictionary["funding_rounds"] as? [Any] {
            for a in array {
                if let jsonFunding = a as? [String: Any] {
                    let funding = FundingRound()
                    
                    funding.short_name = jsonFunding["short_name"] as? String
                        
                    funding.valuation = jsonFunding["valuation"] as? String
                    
                    funding.date = jsonFunding["date"] as? String
                    
                    fundings.append(funding)
                }
                
            }
        }
        
        return fundings
    }
}
