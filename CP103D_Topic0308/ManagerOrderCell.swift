//
//  ManagerOrderCell.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/16.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerOrderCell: UITableViewCell {

    @IBOutlet weak var lbOrderId: UILabel!
    
    @IBOutlet weak var lbOrderDate: UILabel!
    
    @IBOutlet weak var lbOrderStatus: UILabel!
    
    @IBOutlet weak var lbOrderTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
