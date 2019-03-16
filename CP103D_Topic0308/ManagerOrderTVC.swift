//
//  ManagerOrderTVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/8.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerOrderTVC: UITableViewController {
    
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let asset = NSDataAsset(name: "ordersjson") {
            if let orders = try? JSONDecoder().decode([Order].self, from: asset.data) {
                self.orders = orders
            }
        }
    }
    
    
    @IBAction func searchClick(_ sender: Any) {
    }
    
    
    @IBAction func editClick(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let editOrderTVC = self.storyboard?.instantiateViewController(withIdentifier: "editOrderTVC") as! EditOrderTVC
            let order = self.orders[indexPath.row]
            editOrderTVC.order = order
            self.navigationController?.pushViewController(editOrderTVC, animated: true)
        })
        edit.backgroundColor = UIColor.lightGray
        
        return [edit]
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! ManagerOrderCell
        let order = orders[indexPath.row]
        
        cell.lbOrderId.text = order.id?.description
        cell.lbOrderDate.text = order.date?.description
        cell.lbOrderStatus.text = statusDescription(stayusCode: order.status!
        )
        cell.lbOrderTotalPrice.text = order.totalPrice?.description
        
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
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        orders.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    //    // Override to support conditional editing of the table view.
    //    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return true
    //    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditOrderTVC"{
            let destinationTVC = segue.destination as! EditOrderTVC
            destinationTVC.completionHandler = { (order) in self.orders.append(order)}
        }
    }
    
    
}
