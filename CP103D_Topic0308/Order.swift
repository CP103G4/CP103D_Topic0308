//
//  Order.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/8.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation

class order : NSObject , NSSecureCoding {
    static var supportsSecureCoding: Bool{
        return true
    }
    let id:Int?
    let date:Date?
    let status:Int?
    let price:Double?
    
    init(id:Int , date:Date , status:Int , price:Double ) {
        self.id = id
        self.date = date
        self.status = status
        self.price = price
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(date, forKey: "data")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(price, forKey: "price")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(of: NSNumber.self, forKey: "id") as? Int
        date = aDecoder.decodeObject(of: NSDate.self, forKey: "date") as? Date
        status = aDecoder.decodeObject(of: NSNumber.self, forKey: "status") as? Int
        price = aDecoder.decodeObject(of: NSNumber.self, forKey: "price") as? Double
    }
    
    
}
