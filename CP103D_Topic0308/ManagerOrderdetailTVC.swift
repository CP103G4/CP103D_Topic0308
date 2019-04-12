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
            var totalPrice = 0.0
            for good in goods{
                totalPrice += (good.price * Double(good.quatity))
            }
            totalCell.lbTotalPrice.text = totalPrice.description
            return totalCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "goodsCell", for: indexPath) as! ManagerOrderdetailCell
            let good = goods[indexPath.row]
            cell.lbName.text = good.name
            cell.lbNumber.text = good.quatity.description
            cell.lbPrice.text = String(good.price * Double(good.quatity))
            cell.lbColor.text = good.colorDescription(colorCode: good.color1)
            cell.lbSize.text = good.sizeDescription(sizeCode: good.size1)
            
            return cell
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}