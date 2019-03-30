//
//  Good.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/22.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation
class Good: Codable {
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
}
