//
//  Cart.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation

class Cart: NSObject , NSSecureCoding , Codable {
    static var supportsSecureCoding: Bool {
        return true
    }
    var id: Int
    var name: String
    var descrip: String?
    var price: Double
    var mainclass: String
    var subclass: String
    var shelf: String //上架
    var date:Date? //日期
    var evulation: Int //評價
    var color1: String
    var color2: String
    var size1: String
    var size2: String
    var specialPrice: Double
    var quatity: Int
    
    init(id: Int, name: String, descrip: String, price: Double, mainclass: String, subclass: String, shelf: String, evulation: Int, color1: String, color2: String, size1:String, size2:String, specialPrice: Double, quatity: Int) {
        self.id = id
        self.name = name
        self.descrip = descrip
        self.price = price
        self.mainclass = mainclass
        self.subclass = subclass
        self.shelf = shelf
        self.evulation = evulation
        self.color1 = color1
        self.color2 = color2
        self.size1 = size1
        self.size2 = size2
        self.specialPrice = specialPrice
        self.quatity = quatity
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(descrip, forKey: "descrip")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(mainclass, forKey: "mainclass")
        aCoder.encode(subclass, forKey: "subclass")
        aCoder.encode(shelf, forKey: "shelf")
        aCoder.encode(evulation, forKey: "evulation")
        aCoder.encode(color1, forKey: "color1")
        aCoder.encode(color2, forKey: "color2")
        aCoder.encode(size1, forKey: "size1")
        aCoder.encode(size2, forKey: "size2")
        aCoder.encode(specialPrice, forKey: "specialPrice")
        aCoder.encode(quatity, forKey: "quatity")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(of: NSNumber.self, forKey: "id") as? Int ?? -1
        name = aDecoder.decodeObject(of: NSString.self, forKey: "name") as String? ?? ""
        descrip = aDecoder.decodeObject(of: NSString.self, forKey: "descrip") as String? ?? ""
        price = aDecoder.decodeObject(of: NSNumber.self, forKey: "price") as? Double ?? 0.0
        mainclass = aDecoder.decodeObject(of: NSString.self, forKey: "mainclass") as String? ?? ""
        subclass = aDecoder.decodeObject(of: NSString.self, forKey: "subclass") as String? ?? ""
        shelf = aDecoder.decodeObject(of: NSString.self, forKey: "shelf") as String? ?? ""
        evulation = aDecoder.decodeObject(of: NSNumber.self, forKey: "evulation") as? Int ?? -1
        color1 = aDecoder.decodeObject(of: NSString.self, forKey: "color1") as String? ?? ""
        color2 = aDecoder.decodeObject(of: NSString.self, forKey: "color2") as String? ?? ""
        size1 = aDecoder.decodeObject(of: NSString.self, forKey: "size1") as String? ?? ""
        size2 = aDecoder.decodeObject(of: NSString.self, forKey: "size2") as String? ?? ""
        specialPrice = aDecoder.decodeObject(of: NSNumber.self, forKey: "specialPrice") as? Double ?? 0.0
        quatity = aDecoder.decodeObject(of: NSNumber.self, forKey: "quatity") as? Int ?? -1
    }
}
