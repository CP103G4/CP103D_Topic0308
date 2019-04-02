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
    var goods_goodsid: Int
    var color: String
    var size: String
    var amount: Int
    var totalprice : Int
    var price : Int
    
    
    init(id: Int,goods_goodsid: Int,color: String,size: String,amount: Int,price: Int, User_id: Int,totalprice : Int){
        self.id = id
        self.User_id = User_id
        self.goods_goodsid = goods_goodsid
        self.color = color
        self.size = size
        self.amount = amount
        self.price = price
        self.totalprice = totalprice
    }
    
    
    
    
    func purchase(product: Cart, quantity: Int, total: Double, size: String, color: String) -> Bool{
        
        let success = false
        
        
        
        return success
    }
}
