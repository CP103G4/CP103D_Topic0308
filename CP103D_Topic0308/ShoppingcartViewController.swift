//
//  ShoppingcartViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ShoppingcartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartTotalPrice: UILabel!
    
    var carts = [Cart]()
    
    let url_server = URL(string: common_url + "GoodsServlet1")
    
    override func viewDidLoad() {
        let cart1 = Cart(id: 1, name: "發熱衣", descrip: "冬天最好的選擇", price: 200.0, mainclass: "Man", subclass: "0", shelf: "true", evulation: 4, color1: "1", color2: "1", size1: "1", size2: "1", specialPrice: 180.0, quatity: 1)
        let cart2 = Cart(id: 2, name: "牛仔褲", descrip: "丹寧布永不退流行", price: 300.0, mainclass: "Woman", subclass: "1", shelf: "true", evulation: 5, color1: "0", color2: "0", size1: "0", size2: "0", specialPrice: 270.0, quatity: 2)
        carts.append(cart1)
        carts.append(cart2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        showAllGood()
        loadData()
        cartTableView.reloadData()
        displayTotal()
        saveData(carts: carts)
    }
    
    
    func displayTotal() {
        self.cartTotalPrice.text = "$" + calculateCartTotal()
    }
    
    func calculateCartTotal() -> String{
        var total = 0.0
        for cart in carts {
            total += cart.price
        }
        return total.description
    }
    
    func fileInDocuments(fileName: String) -> URL {
        let fileManager = FileManager()
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = urls.first!.appendingPathComponent(fileName)
        return fileUrl
    }
    
    func saveData(carts:[Cart]) {
        let dataUrl = fileInDocuments(fileName: "cartData")
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(carts)
        do {
            /* 如果將requiringSecureCoding設為true，Spot類別必須改遵從NSCoding的子型NSSecureCoding */
            let cartData = try NSKeyedArchiver.archivedData(withRootObject: jsonData, requiringSecureCoding: true)
            try cartData.write(to: dataUrl)
        } catch let error {
            print(error.localizedDescription)
        }
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
                    //                    imageView.image = spot!.image
                    //                    lbName.text = spot!.name
                    //                    lbAddress.text = spot!.address
                    //                    lbPhone.text = spot!.phone
                    //                    let text = "File URL = \(dataUrl)"
                    //                    lbFile.text = text
                } else {
                    //                    lbFile.text = "no data found error"
                }
            }
        }
    }
    
    @IBAction func spNumberChange(_ sender: CartCell) {
        
    }
    
    
    
    //    @objc func showAllGood(){
    //        let requestParam = ["action" : "getAll"]
    //        executeTask(url_server!, requestParam) { (data, response, error) in
    //
    //            let decoder = JSONDecoder()
    //            // JSON含有日期時間，解析必須指定日期時間格式
    //            let format = DateFormatter()
    //            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //            decoder.dateDecodingStrategy = .formatted(format)
    //
    //            if error == nil {
    //                if data != nil {
    //                    print("input: \(String(data: data!, encoding: .utf8)!)")
    //
    //                    if let result = try? decoder.decode([Cart].self, from: data!) {
    //                        self.carts = result
    //                        self.saveData(carts: self.carts)
    //
    //                        DispatchQueue.main.async {
    //                            self.displayTotal()
    //                            if let control = self.cartTableView.refreshControl {
    //                                if control.isRefreshing {
    //                                    // 停止下拉更新動作
    //                                    control.endRefreshing()
    //                                }
    //                            }
    //                            self.cartTableView.reloadData()
    //                        }
    //                    }
    //                }
    //            } else {
    //                print(error!.localizedDescription)
    //            }
    //        }
    //
    //    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return carts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        // Configure the cell...
        let cart = carts[indexPath.row]
        cell.nameLabel.text = cart.name
        cell.priceLabel.text = "價錢： " + cart.price.description
        cell.colarLabel.text = "顏色： " + cart.color1
        cell.sizeLabel.text = "尺寸： " + cart.size1
        cell.quantityLabel.text = "數量： " + cart.quatity.description
        
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
    
    // 左滑修改與刪除資料
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        //            // 左滑時顯示Edit按鈕
    //        //            let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
    //        //                let spotUpdateVC = self.storyboard?.instantiateViewController(withIdentifier: "spotUpdateVC") as! SpotUpdateVC
    //        //                let spot = self.spots[indexPath.row]
    //        //                spotUpdateVC.spot = spot
    //        //                self.navigationController?.pushViewController(spotUpdateVC, animated: true)
    //        //            })
    //        //            edit.backgroundColor = UIColor.lightGray
    //
    //        // 左滑時顯示Delete按鈕
    //        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
    //            // 尚未刪除server資料
    //            var requestParam = [String: Any]()
    //            requestParam["action"] = "shoppingCartDelete"
    //            requestParam["shoppingCart"] = self.carts[indexPath.row].id
    //            executeTask(self.url_server!, requestParam
    //                , completionHandler: { (data, response, error) in
    //                    if error == nil {
    //                        if data != nil {
    //                            print("deleteoutput: \(String(data: data!, encoding: .utf8)!)")
    //
    //                            if let result = String(data: data!, encoding: .utf8) {
    //                                if let count = Int(result) {
    //                                    // 確定server端刪除資料後，才將client端資料刪除
    //                                    if count != 0 {
    //                                        self.carts.remove(at: indexPath.row)
    //                                        DispatchQueue.main.async {
    //                                            self.displayTotal()
    //
    //                                            tableView.deleteRows(at: [indexPath], with: .fade)
    //                                        }
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    } else {
    //                        print(error!.localizedDescription)
    //                    }
    //            })
    //        })
    //        return [delete]
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func checkout(_ sender: UIButton) {
        if carts.count == 0 {
            let alert = UIAlertController.init(title: "沒有商品", message: "請將商品加入購物車", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.performSegue(withIdentifier: "Checkout", sender: sender)
        }
    }
}
