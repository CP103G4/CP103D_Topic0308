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
    var orderdrtail = [Orderdetail]()
    
    
    
    let url_server1 = URL(string: common_url + "ShoppingCartServlet")
    
    //    var orders = [Order]()
    let url_server2 = URL(string: common_url + "OrderServlet")
    
    
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
        executeTask(url_server1!, requestParam) { (data, response, error) in
            
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
    
    
    @IBAction func payNow(_ sender: Any) {
        
        var error = ""
        
        
        if self.carts.count == 0 {
            error = "Your cart is empty."
        }
        else if (self.cardNumber.text?.isEmpty)! {
            error = "Please enter your card number."
        }
        else if (self.cardExpiryMonth.text?.isEmpty)! {
            error = "Please enter the expiry month of your card."
        }
        else if (self.cardExpiryYear.text?.isEmpty)! {
            error = "Please enter the expiry year of your card."
        }
        else if (self.cardCvv.text?.isEmpty)!{
            error = "Please enter the CVV number of your card."
        }
        
        
        
        if error.isEmpty {
            
            showAlertMsg("Confirm Purchase", message: "Pay " + labelTotalPrice.text!, style: UIAlertController.Style.actionSheet)
            
        }
        else {
            showAlertMsg("Error", message: error, style: UIAlertController.Style.alert)
        }
        
    }
    
    var alertController: UIAlertController?
    
    func showAlertMsg(_ title: String, message: String, style: UIAlertController.Style) {
        
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if style == UIAlertController.Style.actionSheet {
            alertController?.addAction(UIAlertAction(title: "Pay", style: .default, handler: { _ in
                self.checkout()
                self.checkoutdetail()
            }))
            
            alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        } else {
            alertController?.addAction(UIAlertAction(title: "Okay", style: .default))
        }
        
        self.present(self.alertController!, animated: true, completion: nil)
        
    }
    
    
    
    @objc func checkout(){
        let requestParam = ["action" : "orderInsert"]
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
                            if let control = self.tableViewOrderDetails.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.tableViewOrderDetails.reloadData()
                            
                            self.performSegue(withIdentifier: "Thankyou", sender: self)
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    @objc func checkoutdetail(){
        let requestParam = ["action" : "orderdetailInsert"]
        executeTask(url_server2!, requestParam) { (data, response, error) in
            
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(format)
            
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? decoder.decode([Orderdetail].self, from: data!) {
                        self.orderdrtail = result
                        DispatchQueue.main.async {
                            if let control = self.tableViewOrderDetails.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.tableViewOrderDetails.reloadData()
                            
                            self.performSegue(withIdentifier: "Thankyou", sender: self)
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    
    
}
