//
//  ManagerGooddetailViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/30.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerGooddetailViewController: UIViewController {
    var goodDetail = Good.init(id: -1, name: "-1", descrip: "-1", price: -1, mainclass: "-1", subclass: "-1", shelf: "-1", evulation: -1, color1: "-1", color2: "-1", size1: "-1", size2: "-1", specialPrice: -1, quatity: -1)
    let url_server = URL(string: common_url + "GoodsServlet1")
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var color1Label: UILabel!
    @IBOutlet weak var color2Label: UILabel!
    @IBOutlet weak var size1Label: UILabel!
    @IBOutlet weak var size2Label: UILabel!
    @IBOutlet weak var quatityLabel: UILabel!
    @IBOutlet weak var shelfSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = goodDetail.id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = UIScreen.main.bounds.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { self.imageview.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
        navigationItem.title = goodDetail.name
        priceLabel.text = goodDetail.price.description
        color1Label.alpha = (goodDetail.color1 == "1") ? 1 : 0
        color2Label.alpha = (goodDetail.color2 == "1") ? 1 : 0
        size1Label.alpha = (goodDetail.size1 == "1") ? 1 : 0.1
        size2Label.alpha = (goodDetail.size2 == "1") ? 1 : 0.1
        quatityLabel.text = goodDetail.quatity.description
        shelfSwitch.isOn = Bool(goodDetail.shelf)!
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
