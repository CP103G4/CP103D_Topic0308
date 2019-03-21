//
//  Good.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation
class Good: Codable {
    
    let id: Int
    let name: String
    let descriptionGood: String?
    let prices: Double
    let mainclass: Int
    let subclass: Int
    let evaluation: Int?
    let date:Date?
    
    public init(_ id: Int, _ name: String, _ descriptionGood: String, _ prices: Double, _ mainclass: Int, _ subclass: Int, _ evaluation:Int, _ date:Date){
        self.id = id
        self.name = name
        self.descriptionGood = descriptionGood
        self.prices = prices
        self.mainclass = mainclass
        self.subclass = subclass
        self.evaluation = evaluation
        self.date = date
    }
}
