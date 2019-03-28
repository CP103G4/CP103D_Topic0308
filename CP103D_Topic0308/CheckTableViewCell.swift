//
//  CheckTableViewCell.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/29.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var amount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

