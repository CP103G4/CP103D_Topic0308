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

    var goods = [Good]()
    let url_server = URL(string: common_url + "ShoppingCartServlet")

    override func viewDidLoad() {
        super.viewDidLoad()
        displayTotal()
        showAllOrders()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func displayTotal() {
        self.carttotalprice.text = "$" + String(format: "%.2f", calculateCartTotal())
    }
    
    func calculateCartTotal() -> Double{
        var total = 0.0
        if self.goods.count > 0 {
            for index in 0...self.goods.count - 1 {
                total += goods[index].price
            }
        }
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
        return goods.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        // Configure the cell...
        let good = goods[indexPath.row]
        cell.nameLabel.text = good.name.description
        cell.priceLabel.text = good.price.description
        
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
