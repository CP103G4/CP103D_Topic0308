//
//  CheckViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var payment: UILabel!
    
    @IBOutlet weak var user: UILabel!
    
    @IBOutlet weak var address: UITextField!
    //    @IBOutlet var pickerPickupPoint: UIPickerView!
    
    @IBOutlet var tableViewOrderDetails: UITableView!
    @IBOutlet var labelTotalPrice: UILabel!
    //    var orders = [Order]()
    var carts = [Cart]()
    var orderdrtail = [Orderdetail]()
    var users = [User]()
    
    let url_server1 = URL(string: common_url + "ShoppingCartServlet")
    //    var orders = [Order]()
    let url_server2 = URL(string: common_url + "OrderServlet")
    let url_server3 = URL(string: common_url + "OrderServlet")
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        showAllCarts()
        payment.text = "1"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    func displayTotal() {
        self.labelTotalPrice.text = String( calculateCartTotal())
    }
    
    func calculateCartTotal() -> Int{
        var total = 0
        for cart in carts {
            total += cart.totalprice
        }
        return total
    }
    
    
    @objc func showAllCarts(){
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
        
        
        
        if self.carts.count == 0 {
            showAlertMsg()
            
        }
        
        let address = self.address.text == nil ? "" : self.address.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let totalprice = self.labelTotalPrice.text == nil ? "" : self.labelTotalPrice.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //新增訂單
        let order = Order(totalprice , address)
        var requestParam = [String: String]()
        requestParam["action"] = "orderInsert"
        requestParam["order"] = try! String(data: JSONEncoder().encode(order), encoding: .utf8)
        //        // 有圖才上傳
        //        if self.image != nil {
        //            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        //        }
        executeTask(self.url_server2!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    self.showAlertMsgorder()
                                    self.performSegue(withIdentifier: "Thankyou", sender: self)
                                    
                                } else {
                                    //                                    self.label.text = "insert fail"
                                }
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        //        //新增訂單明細
        //        let name = self.cellname.text == nil ? "" : self.cellname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let color = self.cellcolor.text == nil ? "" : self.cellname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let size = self.cellsize.text == nil ? "" : self.cellname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let amount = self.cellamount.text == nil ? "" : self.cellname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let orderdetail = Orderdetail(name,color,size,amount)
        //
        //
        //        var requestParam1 = [String: String]()
        //        requestParam1["action"] = "orderdetailInsert"
        //        requestParam1["orderdetail"] = try! String(data: JSONEncoder().encode(orderdetail), encoding: .utf8)
        //        //        // 有圖才上傳
        //        //        if self.image != nil {
        //        //            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        //        //        }
        //        executeTask(self.url_server3!, requestParam) { (data, response, error) in
        //            if error == nil {
        //                if data != nil {
        //                    if let result = String(data: data!, encoding: .utf8) {
        //                        if let count = Int(result) {
        //                            DispatchQueue.main.async {
        //                                // 新增成功則回前頁
        //                                if count != 0 {
        //                                } else {
        //                                    //                                    self.label.text = "insert fail"
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //            } else {
        //                print(error!.localizedDescription)
        //            }
        //        }
        
        
    }
    
    
    func showAlertMsg() {
        
        let errorAlert = UIAlertController(title: "購物車是空的", message: "請到商品頁面購物", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
        
        
    }
    
    
    func showAlertMsgorder() {
        
        let orderAlert = UIAlertController(title: "訂購完成", message: "你的訂單金額: \(String(describing: labelTotalPrice!.text))", preferredStyle: .alert)
        //        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.performSegue(withIdentifier: "Thankyou", sender: self)
        }
        orderAlert.addAction(okAction)
        present(orderAlert, animated: true, completion: nil)
        
        
        
    }
    
    //    @objc func checkout(){
    //        var requestParam = [String: String]()
    //        requestParam["action"] = "orderInsert"
    //        requestParam["order"] = try! String(data: JSONEncoder().encode(order), encoding: .utf8)
    //        //        // 有圖才上傳
    //        //        if self.image != nil {
    //        //            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
    //        //        }
    //        executeTask(self.url_server2!, requestParam) { (data, response, error) in
    //            if error == nil {
    //                if data != nil {
    //                    if let result = String(data: data!, encoding: .utf8) {
    //                        if let count = Int(result) {
    //                            DispatchQueue.main.async {
    //                                // 新增成功則回前頁
    //                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
    //                                } else {
    //                                    //                                    self.label.text = "insert fail"
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            } else {
    //                print(error!.localizedDescription)
    //            }
    //        }
    //
    //    }
    
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
