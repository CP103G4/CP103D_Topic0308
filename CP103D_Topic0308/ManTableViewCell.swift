//
//  ManTableViewCell.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/26.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManTableViewCell: UITableViewCell {

    @IBOutlet weak var manCollectionviewOutlet: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
