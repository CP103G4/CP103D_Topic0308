//
//  Order.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/8.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation

class Order : NSObject , NSSecureCoding , Codable {
    static var supportsSecureCoding: Bool{
        return true
    }
    let id:Int?
    let date:Int?
    let status:Int?
    let totalPrice:Int?
    
    init(id:Int , date:Int , status:Int , totalPrice:Int ) {
        self.id = id
        self.date = date
        self.status = status
        self.totalPrice = totalPrice
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(date, forKey: "data")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(totalPrice, forKey: "price")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(of: NSNumber.self, forKey: "id") as? Int
        date = aDecoder.decodeObject(of: NSNumber.self, forKey: "date") as? Int
        status = aDecoder.decodeObject(of: NSNumber.self, forKey: "status") as? Int
        totalPrice = aDecoder.decodeObject(of: NSNumber.self, forKey: "totalPrice") as? Int
    }
    
    
}
