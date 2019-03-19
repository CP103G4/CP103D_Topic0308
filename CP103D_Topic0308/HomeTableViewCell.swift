//
//  HomeTableViewCell.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/19.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeTVCellCollectionViewCell", for: indexPath)
        return cell
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
