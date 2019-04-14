//
//  ManagerOrderEditTVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/3/20.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerOrderEditTVC: UITableViewController, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var lbOrderId: UILabel!
    @IBOutlet weak var lbOrderAdress: UILabel!
    @IBOutlet weak var lbOrderPayment: UILabel!
    @IBOutlet weak var scStatus: UISegmentedControl!
    let url_server = URL(string: common_url + "OrderServlet")
    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbOrderId.text = order.id?.description
        lbOrderAdress.text = order.address
        lbOrderPayment.text = order.paymentDescription(paymentCode: order.payment!)
        scStatus.selectedSegmentIndex = order.status!
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func updateClick(_ sender: Any) {
        
        var requestParam = [String: String]()
        let encoder = JSONEncoder()
        let format = DateFormatter()
        order.status = scStatus.selectedSegmentIndex
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(format)
        requestParam["action"] = "orderUpdate"
        requestParam["order"] = try! String(data: encoder.encode(order), encoding: .utf8)
        
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.lbOrderId.text = "update fail"
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
}
