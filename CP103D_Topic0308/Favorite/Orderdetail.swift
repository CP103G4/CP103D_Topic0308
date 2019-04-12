//
//  Orderdetail.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/4/1.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation
class Orderdetail: Codable {
    //    var id: Int
    var price: Int?
    var amount: Int?
    var color: String?
    var size: String?
    //    var discount: Double
    var Order_id: Int?
    var goods_goodsid: Int?
    
    init(Order_id: Int,goods_goodsid:Int,  color: String , size:String, amount: Int, price: Int) {
        //        self.id = id
        self.price = price
        self.amount = amount
        self.color = color
        self.size = size
        //        self.discount = discount
        self.Order_id = Order_id
        self.goods_goodsid = goods_goodsid
        
        
    }
    
    
    init (_ goods_goodsid : Int, _ color : String,_ size : String, _ amount:Int){
        self.goods_goodsid = goods_goodsid
        self.color = color
        self.size = size
        self.amount = amount
    }
}
