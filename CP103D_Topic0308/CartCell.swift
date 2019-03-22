//
//  CartCell.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/22.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    @IBOutlet var productImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var quantityLabel: UILabel!
    
    @IBOutlet var colarLabel: UILabel!
    
    @IBOutlet var sizeLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
