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
    var date:Date //日期
    var evulation: Int //評價
    init(id: Int, name: String, descrip: String, price: Double, mainclass: String, subclass: String, shelf: String, date: Date, evulation: Int) {
        self.id = id
        self.name = name
        self.descrip = descrip
        self.price = price
        self.mainclass = mainclass
        self.subclass = subclass
        self.shelf = shelf
        self.date = date
        self.evulation = evulation
    }
}
