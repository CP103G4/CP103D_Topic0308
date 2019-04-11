//
//  G87orderViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/19.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class G87orderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var user : User?
    var orders = [Order]()
    let url_server1 = URL(string: common_url + "UserServlet")
    let url_server2 = URL(string: common_url + "OrderServlet")
    
    @IBOutlet weak var ordertableview: UITableView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        user = loadUser()
        getUser()
        tableViewAddRefreshControl()
    }
    
    func getUser(){
        var requestParam = [String: String]()
        requestParam["action"] = "findUserForOrder"
        requestParam["user"] = try! String(data: JSONEncoder() .encode(user), encoding: .utf8)
        
        executeTask(self.url_server1!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let user = try? JSONDecoder().decode(User.self, from: data!) {
                        self.user = user
                        self.showUserOrders()
                        DispatchQueue.main.async {
                            //                            self.lbName.text = user.trueName
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showUserOrders), for: .valueChanged)
        self.ordertableview.refreshControl = refreshControl
    }
    
    @objc func showUserOrders(){
        var requestParam = [String: Any]()
        requestParam["action"] = "findById"
        requestParam["id"] = user?.id
        executeTask(url_server2!, requestParam) { (data, response, error) in
            
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
                            if let control = self.ordertableview.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.ordertableview.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        
        // Configure the cell...
        let order = orders[indexPath.row]
        cell.orderid.text = order.id?.description
        cell.orderdate.text = order.dateStr
        cell.orderstatus.text = statusDescription(stayusCode: order.status!
        )
        cell.ordertotalprice.text = order.totalPrice?.description
        
        
        return cell
    }
    
    func statusDescription(stayusCode:Int) -> (String) {
        if stayusCode == 0 {
            return "未出貨"
        } else if stayusCode == 1 {
            return "已出貨"
        } else if stayusCode == 2 {
            return "已退貨"
        } else {
            return "已取消"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "orderDetail" {
            let indexPath = self.ordertableview.indexPath(for: sender as! UITableViewCell)
            let order = orders[indexPath!.row]
            let controller = segue.destination as! G87orderdetailViewController
            controller.order = order
        }
        
        
        //        if let row = ordertableview.indexPathForSelectedRow?.row, let controller = segue.destination as? G87orderdetailViewController {
        //
        //            controller.order = orders[row]
        //        }
    }
    
}
