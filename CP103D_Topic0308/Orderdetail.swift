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
    var price: Double
    var amount: Int
    var color: String
    var size: String
    //    var discount: Double
    var Order_id: Int
    var goods_goodsid: Int
    
    init(id: Int ,goods_goodsid:Int,  color: String , size:String, amount: Int, Order_id: Int, price: Double) {
        self.id = id
        self.price = price
        self.amount = amount
        self.color = color
        self.size = size
        //        self.discount = discount
        self.Order_id = Order_id
        self.goods_goodsid = goods_goodsid
        
        
    }
}