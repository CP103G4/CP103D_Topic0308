//
//  CheckTableViewCell.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/29.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivGood: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbColor: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

