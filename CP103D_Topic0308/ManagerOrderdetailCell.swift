//
//  ManagerOrderdetailCell.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/4/11.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerOrderdetailCell: UITableViewCell {
    
    
    
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbColor: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
