//
//  CheckViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var cardNumber: UITextField!
    @IBOutlet var cardExpiryMonth: UITextField!
    @IBOutlet var cardExpiryYear: UITextField!
    @IBOutlet var cardCvv: UITextField!
    
    //    @IBOutlet var pickerPickupPoint: UIPickerView!
    
    @IBOutlet var tableViewOrderDetails: UITableView!
    
    @IBOutlet var labelTotalPrice: UILabel!
    var orders = [Order]()
    var goods = [Good]()
    
    
    //    let url_server = URL(string: common_url + "ShoppingCartServlet")
    
    //    var orders = [Order]()
    let url_server = URL(string: common_url + "GoodsServlet")
    
    
    override func viewWillAppear(_ animated: Bool) {
        showAllOrders()
        
        
        //            showAllOrders()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    func displayTotal() {
        self.labelTotalPrice.text = "$" + String( calculateCartTotal())
    }
    
    func calculateCartTotal() -> Double{
        var total = 0.0
        for good in goods {
            total += good.price
        }
        //        for index in 0...self.goods.count - 1 {
        //            total += goods[index].price
        //        }
        
        return total
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
                    
                    if let result = try? decoder.decode([Good].self, from: data!) {
                        self.goods = result
                        DispatchQueue.main.async {
                            self.displayTotal()
                            if let control = self.tableViewOrderDetails.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.tableViewOrderDetails.reloadData()
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
        return goods.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CheckTableViewCell
        
        // Configure the cell...
        let good = goods[indexPath.row]
        cell.name.text = good.name.description
        cell.color.text = good.mainclass.description
        cell.size.text = good.subclass.description
        cell.amount.text = good.price.description
        
        
        return cell
    }
    
}
