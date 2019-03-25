//
//  DetailVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/25.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var spot: Spot!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = spot.image
        title = spot.name
        nameLabel.text = spot.name
        adressLabel.text = spot.address
        timeLabel.text = spot.time
        
    }
    

    

}
