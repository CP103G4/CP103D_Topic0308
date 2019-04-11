//
//  ShoppingcartViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ShoppingcartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartTotalPrice: UILabel!
    var totalPrice = 0.0
    var carts = [Cart]()
    let url_server = URL(string: common_url + "GoodsServlet1")

    override func viewDidLoad() {
//        let cart1 = Cart(id: 1, name: "發熱衣", descrip: "冬天最好的選擇", price: 200.0, mainclass: "Man", subclass: "0", shelf: "true", evulation: 4, color1: "0", color2: "1", size1: "0", size2: "1", specialPrice: 180.0, quatity: 1)
//        let cart2 = Cart(id: 2, name: "牛仔褲", descrip: "丹寧布永不退流行", price: 300.0, mainclass: "Woman", subclass: "1", shelf: "true", evulation: 5, color1: "1", color2: "0", size1: "1", size2: "0", specialPrice: 270.0, quatity: 2)
//        carts.append(cart1)
//        carts.append(cart2)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        loadData()
        cartTableView.reloadData()
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
                } else {
                    //                    lbFile.text = "no data found error"
                }
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
        cell.numberStepper.value = Double(cart.quatity)
        cell.nameLabel.text = cart.name
        cell.priceLabel.text = String(cart.price * Double(cart.quatity))
        cell.colorLabel.text = cart.color1
        cell.sizeLabel.text = cart.size1
        cell.quantityLabel.text = cart.quatity.description
        
        
        let item = carts[indexPath.row] // assuming `dataSource` is the data source array
        cell.numberStepper.value = Double(item.quatity)
        cell.quantityLabel.text = "\(item.quatity)"
        var totalprice = 0.0
        for cartTmp in self.carts{
            totalprice += (cartTmp.price * Double(cartTmp.quatity))
        }
        cartTotalPrice.text = totalprice.description
        cell.observation = cell.numberStepper.observe( \.value, options: [.new, .old]) { (stepper, change) in
            cell.quantityLabel.text = "\(Int(change.newValue!))"
            cell.priceLabel.text = String(change.newValue! * cart.price)
            totalprice = Double(self.cartTotalPrice.text!)!
            totalprice = totalprice + (change.newValue! - change.oldValue!) * cart.price
            print(change.newValue!.description)
            print(change.oldValue!.description)
            self.cartTotalPrice.text = totalprice.description
            self.carts[indexPath.row].quatity = Int(cell.quantityLabel.text!)!
        }
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = carts[indexPath.row].id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { cell.productImage.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! CartCell).observation = nil
    }
    
    func stepperButton(sender: CartCell) {
        if let indexPath = cartTableView.indexPath(for: sender){
            print(indexPath)
            let cart = carts[indexPath.row]
            cart.quatity = Int(sender.numberStepper.value)
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
    
    //     左滑修改與刪除資料
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
            self.carts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        })
        return [delete]
    }
    func showCorrectAlert(){
        let correctAlert = UIAlertController(title: "上傳成功", message: "上傳成功", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Great!", style: .default) { (_) in
//            self.next()
        }
        correctAlert.addAction(okAction)
        present(correctAlert, animated: true, completion: nil)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        saveData(carts: carts)
    }

}
