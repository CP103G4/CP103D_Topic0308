//
//  Cart.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation

class Cart: Codable {
    var id: Int
    var User_id: Int
    var payment: Int
    var goods_goodsid: Int
    var color: String
    var size: String
    var amount: Int
    var status:Int
    var address: String
    var totalprice : Int
    
    init(id: Int, User_id: Int,payment: Int,goods_goodsid: Int,color: String,size: String,amount: Int,totalprice : Int,address: String,status:Int) {
        self.id = id
        self.User_id = User_id
        self.payment = payment
        self.goods_goodsid = goods_goodsid
        self.color = color
        self.size = size
        self.amount = amount
        self.status = status
        self.address = address
        self.totalprice = totalprice
    }
}
