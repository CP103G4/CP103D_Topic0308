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
    
    @IBOutlet weak var shoppingView: UIView!
    @IBOutlet weak var shoppingviewStepper: UIStepper!
    @IBOutlet weak var shoppingviewQuality: UILabel!
    @IBOutlet weak var shoppingviewDeepcolorBt: UIButton!
    @IBOutlet weak var shoppingviewLightBt: UIButton!
    @IBOutlet weak var shoppingviewSizeLBt: UIButton!
    @IBOutlet weak var shoppingviewSizeXLBt: UIButton!
    @IBOutlet weak var shoppingviewprice: UILabel!
    @IBOutlet weak var noGoodView: UIView!
    @IBOutlet weak var shoppingviewImageview: UIImageView!
    
    var totalPrice = 0.0
    var carts = [Cart]()
    let url_server = URL(string: common_url + "GoodsServlet1")

    override func viewDidLoad() {
//        let cart1 = Cart(id: 1, name: "發熱衣", descrip: "冬天最好的選擇", price: 200.0, mainclass: "Man", subclass: "0", shelf: "true", evulation: 4, color1: "0", color2: "1", size1: "0", size2: "1", specialPrice: 180.0, quatity: 1)
//        let cart2 = Cart(id: 2, name: "牛仔褲", descrip: "丹寧布永不退流行", price: 300.0, mainclass: "Woman", subclass: "1", shelf: "true", evulation: 5, color1: "1", color2: "0", size1: "1", size2: "0", specialPrice: 270.0, quatity: 2)
//        carts.append(cart1)
//        carts.append(cart2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        cartTableView.reloadData()
        if carts.count == 0 {
            noGoodView.isHidden = false
        }else{
            noGoodView.isHidden = true
        }
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
        cell.colorLabel.text = cart.color1 == "1" ? "深色" : "淺色"
        cell.sizeLabel.text = cart.size1 == "1" ? "L" : "XL"
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
                    // 左滑時顯示Edit按鈕
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            self.tabBarController?.tabBar.isHidden = true
            self.cartTableView.tag = indexPath.row
            self.navigationController?.navigationBar.alpha = 1
            self.shoppingView.isHidden = false
            self.shoppingView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                self.shoppingView.alpha = 1.0
                self.navigationController?.navigationBar.alpha = 0.6
            }) { (isCompleted) in
            }
            self.shoppingviewQuality.text = self.carts[indexPath.row].quatity.description
            self.shoppingviewStepper.value = Double(self.carts[indexPath.row].quatity)
            if self.carts[indexPath.row].color1 == "1"{
                self.shoppingviewDeepcolorBt.isSelected = true
                self.shoppingviewLightBt.isSelected = false
            }else{
                self.shoppingviewDeepcolorBt.isSelected = false
                self.shoppingviewLightBt.isSelected = true
            }
            if self.carts[indexPath.row].size1 == "1"{
                self.shoppingviewSizeLBt.isSelected = true
                self.shoppingviewSizeXLBt.isSelected = false
            }else{
                self.shoppingviewSizeLBt.isSelected = false
                self.shoppingviewSizeXLBt.isSelected = true
            }
            self.shoppingviewprice.text = Int(self.carts[indexPath.row].price).description
            let cell = tableView.cellForRow(at: indexPath) as! CartCell
            self.shoppingviewImageview.image = cell.productImage.image
            self.saveData(carts: self.carts)
                    })
        
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            let correctAlert = UIAlertController(title: "刪除商品", message: "確認是否刪除" + self.carts[indexPath.row].name, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.carts.remove(at: indexPath.row)
                self.saveData(carts: self.carts)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.setBadgevalue()
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "shoppingcarNavigation") {
                    self.present(controller, animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            correctAlert.addAction(okAction)
            correctAlert.addAction(cancel)
            self.present(correctAlert, animated: true, completion: nil)
            tableView.reloadData()
        })
        return [edit, delete]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let gooddetailViewController = UIStoryboard(name: "ConsumerHome", bundle:nil).instantiateViewController(withIdentifier: "gooddetailViewController") as? GooddetailViewController {
            gooddetailViewController.goodName = carts[indexPath.row].name
            gooddetailViewController.isFromshoppingcar = true
            navigationController?.pushViewController(gooddetailViewController, animated: true)
        }
    }
    
    @IBAction func hideShoppingviewAction(_ sender: Any) {
        hideShoppingview()
    }
    
    
    @IBAction func qualityStepperAction(_ sender: Any) {
        shoppingviewQuality.text = Int(shoppingviewStepper.value).description
    }
    @IBAction func deepcolorBtAction(_ sender: Any) {
        shoppingviewLightBt.isSelected = false
        shoppingviewDeepcolorBt.isSelected = !shoppingviewDeepcolorBt.isSelected
    }
    @IBAction func lightcolorBtAction(_ sender: Any) {
        shoppingviewDeepcolorBt.isSelected = false
        shoppingviewLightBt.isSelected = !shoppingviewLightBt.isSelected
    }
    @IBAction func sizeLBtAction(_ sender: Any) {
        shoppingviewSizeXLBt.isSelected = false
        shoppingviewSizeLBt.isSelected = !shoppingviewSizeLBt.isSelected
    }
    @IBAction func sizeXLBtAction(_ sender: Any) {
        shoppingviewSizeLBt.isSelected = false
        shoppingviewSizeXLBt.isSelected = !shoppingviewSizeXLBt.isSelected
    }
    @IBAction func updatecartAction(_ sender: Any) {
        carts[cartTableView.tag].quatity = Int(shoppingviewStepper.value)
        print(cartTableView.tag)
        carts[cartTableView.tag].color1 = shoppingviewDeepcolorBt.isSelected ? "1" : "0"
        carts[cartTableView.tag].size1 = shoppingviewSizeLBt.isSelected ? "1" : "0"
        saveData(carts: carts)
        self.loadData()
        self.cartTableView.reloadData()
        hideShoppingview()
        clearShoppingview()
    }
    func hideShoppingview() {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.navigationController?.navigationBar.alpha = 0.6
        shoppingView.alpha = 1
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.shoppingView.alpha = 0
            self.navigationController?.navigationBar.alpha = 1
        }) { (isCompleted) in
            self.shoppingView.isHidden = true
        }
    }
    func clearShoppingview() {
        shoppingviewDeepcolorBt.isSelected = false
        shoppingviewLightBt.isSelected = false
        shoppingviewSizeLBt.isSelected = false
        shoppingviewSizeXLBt.isSelected = false
        shoppingviewStepper.value = 1
        shoppingviewQuality.text = "1"
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
    
    func setBadgevalue() {
        if carts.count == 0 {
            self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
        }else{
            self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = carts.count.description
        }
    }
    
    @IBAction func goShopping(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TabBar")
        present(controller, animated: true, completion: nil)
    }
}
