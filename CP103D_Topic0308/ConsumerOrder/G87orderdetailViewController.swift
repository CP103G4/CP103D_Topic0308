//
//  G87orderdetailViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/19.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class G87orderdetailViewController: UIViewController {

    var order: Order?
    
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var totalprice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let order = order {
            Status.text = statusDescription(stayusCode: order.status!
            )
            
            totalprice.text = " $ \(order.totalPrice!.description)"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
