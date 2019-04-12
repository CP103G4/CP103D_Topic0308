//
//  Order.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/8.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation

class Order : NSObject, NSSecureCoding, Codable {
    static var supportsSecureCoding: Bool{
        return true
    }
    var id:Int?
    var status:Int?
    var totalPrice:String?

    var date:Date?
    var payment:Int?
    var address:String?
    var userId:Int?
    
    init (_ status : Int ,_ payment : Int,_ userId : Int,_ address : String ){
        self.status = status
        self.payment = payment
        self.userId = userId
        self.address = address
        
        //        self.totalPrice = totalprice
    }
    
    init(id:Int , status:Int , date:Date , payment:Int , address:String , userId:Int ) {
        self.id = id
        self.status = status
        self.date = date
        self.payment = payment
        self.address = address
        self.userId = userId
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(date, forKey: "data")
        aCoder.encode(payment, forKey: "payment")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(userId, forKey: "userId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(of: NSNumber.self, forKey: "id") as! Int
        status = aDecoder.decodeObject(of: NSNumber.self, forKey: "status") as! Int
        date = aDecoder.decodeObject(of: NSNumber.self, forKey: "date") as? Date
        payment = aDecoder.decodeObject(of: NSNumber.self, forKey: "payment") as! Int
        address = aDecoder.decodeObject(of: NSString.self, forKey: "address") as! String
        userId = aDecoder.decodeObject(of: NSNumber.self, forKey: "userId") as! Int
    }
    
    func statusDescription(stayusCode:Int) -> (String) {
        if stayusCode == 0 {
            return "未出貨"
        } else if stayusCode == 1 {
            return "已出貨"
        } else if stayusCode == 2 {
            return "已退貨"
        } else {
            return "已取消"
        }
    }
    
    func paymentDescription(paymentCode:Int) -> (String) {
        if paymentCode == 0 {
            return "貨到付款"
        } else if paymentCode == 1 {
            return "信用卡付款"
        } else {
            return "錯誤"
        }
    }
    
    var dateStr: String {
        if date != nil {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return format.string(from: date!)
        } else {
            return ""
        }
    }
    
    
}
