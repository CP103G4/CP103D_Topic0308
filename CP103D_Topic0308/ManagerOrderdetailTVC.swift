//
//  ManagerOrderdetailTVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/4/11.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerOrderdetailTVC: UITableViewController {
    
    var order: Order!
    var goods = [Good]()
    let url_server = URL(string: common_url + "OrderdetailServlet")
    let url_server_pic = URL(string: common_url + "GoodsServlet1")
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllOrdetails()
    }
    
    func showAllOrdetails() {
        let orderId = order.id
        var requestParam = [String: Any]()
        requestParam["action"] = "findById"
        requestParam["id"] = orderId
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(format)
            if error == nil {
                if data != nil {
                    print("detailinput: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([Good].self, from: data!) {
                        print(result)
                        self.goods = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return goods.count
        case 1: return 1
        default:
            return goods.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "totalPriceCell", for: indexPath) as! TotalPriceCell
            
             totalCell.layer.cornerRadius = 20
            
            var totalPrice = 0.0
            for good in goods{
                totalPrice += (good.price * Double(good.quatity))
            }
            totalCell.lbTotalPrice.text = Int(totalPrice).description
            return totalCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "goodsCell", for: indexPath) as! ManagerOrderdetailCell
            
             cell.layer.cornerRadius = 20
            
            // 尚未取得圖片，另外開啟task請求
            var requestParam = [String: Any]()
            requestParam["param"] = "getImage"
            requestParam["id"] = goods[indexPath.row].id
            // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
            requestParam["imageSize"] = cell.frame.width / 4
            var image: UIImage?
            executeTask(url_server_pic!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        image = UIImage(data: data!)
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                    }
                    DispatchQueue.main.async {cell.ivPhoto.image = image}
                } else {
                    print(error!.localizedDescription)
                }
            }
            
            let good = goods[indexPath.row]
            cell.lbName.text = good.name
            cell.lbNumber.text = good.quatity.description
            cell.lbPrice.text = String(good.price * Double(good.quatity))
            cell.lbColor.text = good.colorDescription(colorCode: good.color1)
            cell.lbSize.text = good.sizeDescription(sizeCode: good.size1)
            
            return cell
        }
    }
}
