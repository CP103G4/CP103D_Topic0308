//
//  Account.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/10.
//  Copyright © 2019 min-chia. All rights reserved.
//

import Foundation

class Account: Codable {
    var username: String
    var password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
