//
//  ShoppingcartViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ShoppingcartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var carttableview: UITableView!
    
    @IBOutlet weak var carttotalprice: UILabel!
    
    //    var order: Order?
    
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
        self.carttotalprice.text = "$" + String( calculateCartTotal())
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
                            if let control = self.carttableview.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.carttableview.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        // Configure the cell...
        let cart = carts[indexPath.row]
        cell.nameLabel.text = cart.goods_goodsid.description
        cell.priceLabel.text = "價錢： " + cart.totalprice.description
        cell.colarLabel.text = "顏色： " + cart.color.description
        cell.sizeLabel.text = "尺寸： " + cart.size.description
        cell.quantityLabel.text = "數量： " + cart.amount.description
        
        
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
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //            // 左滑時顯示Edit按鈕
        //            let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
        //                let spotUpdateVC = self.storyboard?.instantiateViewController(withIdentifier: "spotUpdateVC") as! SpotUpdateVC
        //                let spot = self.spots[indexPath.row]
        //                spotUpdateVC.spot = spot
        //                self.navigationController?.pushViewController(spotUpdateVC, animated: true)
        //            })
        //            edit.backgroundColor = UIColor.lightGray
        
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "shoppingCartDelete"
            requestParam["shoppingCart"] = self.carts[indexPath.row].id
            executeTask(self.url_server!, requestParam
                , completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            print("deleteoutput: \(String(data: data!, encoding: .utf8)!)")
                            
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.carts.remove(at: indexPath.row)
                                        DispatchQueue.main.async {
                                            self.displayTotal()
                                            
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
        return [delete]
    }
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
