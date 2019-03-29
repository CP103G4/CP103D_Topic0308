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
    var carts = [Cart]()
    
    
    //    let url_server = URL(string: common_url + "ShoppingCartServlet")
    
    //    var orders = [Order]()
    let url_server = URL(string: common_url + "ShoppingCartServlet")
    
    
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
    
    func calculateCartTotal() -> Int{
        var total = 0
        for cart in carts {
            total += cart.totalprice
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
                    
                    if let result = try? decoder.decode([Cart].self, from: data!) {
                        self.carts = result
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
        return carts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CheckTableViewCell
        
        // Configure the cell...
        let cart = carts[indexPath.row]
        cell.name.text = cart.goods_goodsid.description
        cell.color.text = cart.color.description
        cell.size.text = cart.size.description
        cell.amount.text = cart.amount.description
        
        
        return cell
    }
    
}
