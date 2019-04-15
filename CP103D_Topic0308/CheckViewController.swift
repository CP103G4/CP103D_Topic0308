//
//  CheckViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scPayment: UISegmentedControl!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfAddress: UITextField!
    //    @IBOutlet var pickerPickupPoint: UIPickerView!
    
    @IBOutlet var tableViewOrderDetails: UITableView!
    @IBOutlet var labelTotalPrice: UILabel!
    
    var carts = [Cart]()
    var orderdrtails = [Orderdetail]()
    var user : User?
    
    let url_server1 = URL(string: common_url + "UserServlet")
    let url_server2 = URL(string: common_url + "OrderServlet")
    let url_server3 = URL(string: common_url + "OrderdetailServlet")
    let url_server_pic = URL(string: common_url + "GoodsServlet1")
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        displayTotal()
        user = loadUser()
        getUser()
        
    }
    
    func fileInDocuments(fileName: String) -> URL {
        let fileManager = FileManager()
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = urls.first!.appendingPathComponent(fileName)
        return fileUrl
    }
    
    func loadData() {
        let fileManager = FileManager()
        let decoder = JSONDecoder()
        let dataUrl = fileInDocuments(fileName: "cartData")
        if fileManager.fileExists(atPath: dataUrl.path) {
            if let data = try? Data(contentsOf: dataUrl) {
                if let jsonData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Data {
                    let result = try! decoder.decode([Cart].self, from: jsonData)
                    carts = result
                } else {
                    
                }
            }
        }
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
                        DispatchQueue.main.async {
                            self.lbName.text = user.trueName
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    func displayTotal() {
        self.labelTotalPrice.text = String(calculateCartTotal())
    }
    
    func calculateCartTotal() -> String{
        var total = 0.0
        for cart in carts {
            total += cart.price * Double(cart.quatity)
        }
        return Int(total).description
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckTableViewCell
        
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = carts[indexPath.row].id
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
                DispatchQueue.main.async {cell.ivGood.image = image}
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // Configure the cell...
        let cart = carts[indexPath.row]
        cell.lbName.text = cart.name
        cell.lbColor.text = cart.color1.description
        cell.lbSize.text = cart.size1.description
        cell.lbNumber.text = cart.quatity.description
        cell.lbPrice.text = String(cart.price * Double(cart.quatity))
        
        return cell
    }
    
    
    @IBAction func payNow(_ sender: Any) {
        let address = tfAddress.text == nil ? "" : tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.carts.count == 0 || address!.isEmpty {
            showAlertMsg()
            return
        } else {
            let status = 0
            let userId = user?.id
            let payment = scPayment.selectedSegmentIndex
            //        let totalprice = self.labelTotalPrice.text == nil ? "" : self.labelTotalPrice.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //新增訂單
            let order = Order(status, payment, userId!, address!)
            var requestParam = [String: String]()
            requestParam["action"] = "orderInsert"
            requestParam["order"] = try! String(data: JSONEncoder().encode(order), encoding: .utf8)
            
            executeTask(self.url_server2!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        print("orderinput: \(String(data: data!, encoding: .utf8)!)")
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    // 新增成功則回前頁
                                    if count != 0 {
                                        self.turnOrderdetail(orderId: count)
                                        //新增訂單明細
                                        self.insertOrderdetail()
                                        self.delete()
                                        self.showAlertMsgorder()
                                        
//                                        self.performSegue(withIdentifier: "Thankyou", sender: self)

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
            
        }
        
        switch scPayment.selectedSegmentIndex {
        case 0:
            self.performSegue(withIdentifier: "Thankyou", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "payforCard", sender: self)
            break
        default:
            break
        }
        
        
    }
    
    func showAlertMsg() {
        
        let errorAlert = UIAlertController(title: "資料不完整", message: "請確認資料都已填寫", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
        
        
    }
    
    
    func showAlertMsgorder() {
        
        let orderAlert = UIAlertController(title: "訂購完成", message: "你的訂單金額: \(String(describing: labelTotalPrice!.text))", preferredStyle: .alert)
        //        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
//            self.performSegue(withIdentifier: "Thankyou", sender: self)
        }
        orderAlert.addAction(okAction)
        present(orderAlert, animated: true, completion: nil)
        
    }
    
    func showSuccessAlert() {
        
        let orderAlert = UIAlertController(title: "感謝您的購買", message: "你的訂單金額: \(String(describing: labelTotalPrice!.text))", preferredStyle: .alert)
        //        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
//            self.performSegue(withIdentifier: "Thankyou", sender: self)
        }
        orderAlert.addAction(okAction)
        present(orderAlert, animated: true, completion: nil)
        
    }
    
    
    func delete() {
        //刪除畫面
        carts.removeAll()
        
    }
    
    func turnOrderdetail (orderId:Int) {
        for cart in carts {
            let orderdetail = Orderdetail(id: 0, number: cart.quatity, discount: 0, price: cart.price, orderId:orderId, goodsid: cart.id, color: cart.color1, size: cart.size1)
            orderdrtails.append(orderdetail)
        }
    }
    
    
    
    
    @objc func insertOrderdetail() {
        for i in 0...orderdrtails.count-1 {
            let orderdetail = orderdrtails[i]
            var requestParam = [String: String]()
            requestParam["action"] = "Insert"
            requestParam["orderdetail"] = try! String(data: JSONEncoder().encode(orderdetail), encoding: .utf8)
            executeTask(url_server3!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        print("input: \(String(data: data!, encoding: .utf8)!)")
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    if count != 0 {
                                        
                                    } else {
                                        
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
        }
        print("order detail insert success")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        orderdrtails.removeAll()
    }
    
    
    
}
