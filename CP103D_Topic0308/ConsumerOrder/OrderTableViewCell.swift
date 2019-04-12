//
//  OrderTableViewCell.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/20.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderid: UILabel!
    @IBOutlet weak var orderdate: UILabel!
    @IBOutlet weak var orderstatus: UILabel!
    @IBOutlet weak var orderpayment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
