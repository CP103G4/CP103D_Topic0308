//
//  Orderdetail.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/4/1.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation
class Orderdetail: Codable {
    var id: Int
    var number:Int
    var discount:Double?
    var price: Double
    var orderId: Int
    var goodsid: Int
    var color: String
    var size: String
    
    init( id:Int, number:Int, discount:Double, price:Double, orderId: Int, goodsid:Int, color: String , size:String) {
        self.id = id
        self.number = number
        self.discount = discount
        self.price = price
        self.orderId = orderId
        self.goodsid = goodsid
        self.color = color
        self.size = size
        
    }
    
}
