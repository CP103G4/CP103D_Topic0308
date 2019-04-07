//
//  G87orderdetailViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/19.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class G87orderdetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var order: Order?
    var orderdetail = [Orderdetail]()
    let url_server = URL(string: common_url + "OrderdetailServlet")
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var totalprice: UILabel!
    
    @IBOutlet weak var orderdetailtableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableViewAddRefreshControl()
        
        // Do any additional setup after loading the view.
        if let order = order {
            showAllOrders()

            Status.text = statusDescription(stayusCode: order.status
            )
            
            totalprice.text = " $ \(order.address)"
        }
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
    
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllOrders), for: .valueChanged)
        self.orderdetailtableview.refreshControl = refreshControl
    }
    
    @objc func showAllOrders(){
//        let requestParam = ["action" : "getAll"]
        var requestParam = [String: Any]()
        requestParam["action"] = "findById"
        requestParam["Order_id"] = order?.id
        print(order?.id)
        requestParam["orderdetail"] = try! String(data: JSONEncoder() .encode(orderdetail), encoding: .utf8)
        executeTask(url_server!, requestParam) { (data, response, error) in
            
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(format)
            
            if error == nil {
                if data != nil {
                    print("detailinput: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? decoder.decode([Orderdetail].self, from: data!) {
                        print(result)

                        self.orderdetail = result
                        print(result)
                        DispatchQueue.main.async {
                            
                            if let control = self.orderdetailtableview.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.orderdetailtableview.reloadData()
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
        return orderdetail.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderdetailCell", for: indexPath) as! OrderdetailTableViewCell
        
        // Configure the cell...
        let good = orderdetail[indexPath.row]
        cell.name.text = good.goods_goodsid.description
        cell.price.text = good.price.description
        cell.colar.text = good.color.description
        cell.size.text = good.size.description
        
        
        return cell
    }
    
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //
    //        if let row = orderdetailtableview.indexPathForSelectedRow?.row, let controller = segue.destination as? G87orderdetailViewController {
    //
    //            controller.good = goods[row]
    //        }
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
