//
//  ManagerOrderTVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/8.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerOrderTVC: UITableViewController {
    
    var orders = [Order]()
    let url_server = URL(string: common_url + "OrderServlet")
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let asset = NSDataAsset(name: "ordersjson") {
//            if let orders = try? JSONDecoder().decode([Order].self, from: asset.data) {
//                self.orders = orders
//            }
//        }
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewAddRefreshControl()
        showAllOrders()
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllOrders), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func showAllOrders(){
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(format)
            
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? decoder.decode([Order].self, from: data!) {
                        self.orders = result
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
    
    @IBAction func searchClick(_ sender: Any) {
    }
    
    
    @IBAction func editClick(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let editOrderTVC = self.storyboard?.instantiateViewController(withIdentifier: "editOrderTVC") as! ManagerOrderEditTVC
            let order = self.orders[indexPath.row]
            editOrderTVC.order = order
            self.navigationController?.pushViewController(editOrderTVC, animated: true)
        })
        edit.backgroundColor = UIColor.lightGray
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "orderDelete"
            requestParam["orderId"] = self.orders[indexPath.row].id
            executeTask(self.url_server!, requestParam
                , completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.orders.remove(at: indexPath.row)
                                        DispatchQueue.main.async {
                                            tableView.deleteRows(at: [indexPath], with: .fade)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
            })
        })
        return [delete, edit]
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! ManagerOrderCell
        let order = orders[indexPath.row]
        
        cell.lbOrderId.text = order.id?.description
        cell.lbOrderDate.text = order.dateStr
        cell.lbOrderStatus.text = order.statusDescription(stayusCode: order.status!
        )
        cell.lbOrderTotalPrice.text = order.totalPrice?.description
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        orders.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    //    // Override to support conditional editing of the table view.
    //    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return true
    //    }
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "EditOrderTVC"{
//            let destinationTVC = segue.destination as! EditOrderTVC
//            destinationTVC.completionHandler = { (order) in self.orders.append(order)}
//        }
//    }
    
    
}
