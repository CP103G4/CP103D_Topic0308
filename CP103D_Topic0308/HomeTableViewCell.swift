//
//  HomeTableViewCell.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/19.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell{
    
    @IBOutlet weak var collectionviewOutlet: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
