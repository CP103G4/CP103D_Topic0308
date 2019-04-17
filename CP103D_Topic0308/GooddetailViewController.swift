//
//  GooddetailViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/27.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import CoreData

class GooddetailViewController: UIViewController {
    
    
    var goodDetail = Good.init(id: -1, name: "-1", descrip: "-1", price: -1, mainclass: "-1", subclass: "-1", shelf: "-1", evulation: -1, color1: "-1", color2: "-1", size1: "-1", size2: "-1", specialPrice: -1, quatity: -1)
    let url_server = URL(string: common_url + "GoodsServlet1")
    var goodId = 0
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var color1Label: UILabel!
    @IBOutlet weak var color2Label: UILabel!
    @IBOutlet weak var size1Label: UILabel!
    @IBOutlet weak var size2Label: UILabel!
    @IBOutlet weak var gooddescriptTextview: UITextView!
    
    @IBOutlet weak var shoppingView: UIView!
    @IBOutlet weak var shoppingviewImageview: UIImageView!
    @IBOutlet weak var shoppingviewPrice: UILabel!
    @IBOutlet weak var shoppingviewQuality: UILabel!
    @IBOutlet weak var shoppingviewStepper: UIStepper!
    @IBOutlet weak var shoppingviewDeepcolorBt: UIButton!
    @IBOutlet weak var shoppingviewLightBt: UIButton!
    @IBOutlet weak var shoppingviewSizeLBt: UIButton!
    @IBOutlet weak var shoppingviewSizeXLBt: UIButton!
    
    
    var goodName = "-1"
    var isFromshoppingcar = false
    
    var carts = [Cart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if goodName != "-1" {
            navigationItem.title = goodName
            showGoodDetail()
            if !isFromshoppingcar{
                let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                                 action: #selector(backToPrevious))
                self.navigationItem.leftBarButtonItem = leftBarBtn
            }
        }else{
            
            // Do any additional setup after loading the view.
            navigationItem.title = goodDetail.name
            priceLabel.text = goodDetail.price.description
            color1Label.alpha = (goodDetail.color1 == "1") ? 1 : 0
            color2Label.alpha = (goodDetail.color2 == "1") ? 1 : 0
            size1Label.alpha = (goodDetail.size1 == "1") ? 1 : 0.1
            size2Label.alpha = (goodDetail.size2 == "1") ? 1 : 0.1
            gooddescriptTextview.text = goodDetail.descrip
            shoppingviewPrice.text = goodDetail.price.description
            getImage()
        }
    }
    
    func getImage() {
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = goodDetail.id
        // 圖片寬度為tableViewCell的寬度，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = UIScreen.main.bounds.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    self.imageview.image = image
                    self.shoppingviewImageview.image = image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @objc func backToPrevious(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TabBar")
        present(controller, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func showGoodDetail(){
        var requestParam = [String: String]()
        requestParam["param"] = "getGoodDetail"
        requestParam["goodName"] = goodName
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(format)
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    do{
                        self.goodDetail = try decoder.decode(Good.self, from: data!)
                        self.goodId = self.goodDetail.id
                        DispatchQueue.main.async {
                            self.priceLabel.text = self.goodDetail.price.description
                            self.color1Label.alpha = (self.goodDetail.color1 == "1") ? 1 : 0
                            self.color2Label.alpha = (self.self.goodDetail.color2 == "1") ? 1 : 0
                            self.size1Label.alpha = (self.self.goodDetail.size1 == "1") ? 1 : 0.1
                            self.size2Label.alpha = (self.goodDetail.size2 == "1") ? 1 : 0.1
                            self.gooddescriptTextview.text = self.goodDetail.descrip
                            
                            self.getImage()
                        }
                    }catch{
                        print(error)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    @IBAction func openFavoriteView(_ sender: Any) {
        saveDataFavorite()
        showalert()
    }
    
    @IBAction func openshoppingView(_ sender: Any) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        shoppingView.isHidden = false
        shoppingView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.shoppingView.alpha = 1.0
            self.navigationController?.navigationBar.alpha = 0.6
        }) { (isCompleted) in
        }
        shoppingviewQuality.text = Int(shoppingviewStepper.value).description
    }
    
    @IBAction func hideShoppingviewAction(_ sender: Any) {
        hideShoppingview()
        self.navigationItem.backBarButtonItem?.isEnabled = true
    }
    
    func hideShoppingview() {
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.alpha = 0.6
        shoppingView.alpha = 1
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.shoppingView.alpha = 0
            self.navigationController?.navigationBar.alpha = 1
        }) { (isCompleted) in
            self.shoppingView.isHidden = true
        }
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        shoppingviewQuality.text = Int(shoppingviewStepper.value).description
    }
    @IBAction func deepColorBt(_ sender: Any) {
        shoppingviewLightBt.isSelected = false
        shoppingviewDeepcolorBt.isSelected = !shoppingviewDeepcolorBt.isSelected
    }
    @IBAction func lightColorBt(_ sender: Any) {
        shoppingviewDeepcolorBt.isSelected = false
        shoppingviewLightBt.isSelected = !shoppingviewLightBt.isSelected
    }
    @IBAction func sizeLBt(_ sender: Any) {
        shoppingviewSizeXLBt.isSelected = false
        shoppingviewSizeLBt.isSelected = !shoppingviewSizeLBt.isSelected
    }
    @IBAction func sizeXLBt(_ sender: Any) {
        shoppingviewSizeLBt.isSelected = false
        shoppingviewSizeXLBt.isSelected = !shoppingviewSizeXLBt.isSelected
    }
    
    @IBAction func addtoShoppingcar(_ sender: Any) {
        if (shoppingviewDeepcolorBt.isSelected || shoppingviewLightBt.isSelected) && (shoppingviewSizeLBt.isSelected || shoppingviewSizeXLBt.isSelected) {
            let shoppitem = Cart(id: goodDetail.id, name: goodDetail.name, descrip: goodDetail.descrip!, price: goodDetail.price, mainclass: goodDetail.mainclass, subclass: goodDetail.subclass, shelf: goodDetail.shelf, evulation: goodDetail.evulation, color1: shoppingviewDeepcolorBt.isSelected == true ? "1" : "0", color2: shoppingviewLightBt.isSelected == true ? "沒有用到" : "沒有用到", size1: shoppingviewSizeLBt.isSelected == true ? "1" : "0", size2: shoppingviewSizeXLBt.isSelected == false ? "沒有用到" : "沒有用到", specialPrice: Double(Int(goodDetail.specialPrice)), quatity: Int(shoppingviewStepper.value))
            loadData()
            carts.append(shoppitem)
            saveData(carts: carts)
            hideShoppingview()
            clearShoppingview()
            setBadgevalue()
        }else if !(shoppingviewDeepcolorBt.isSelected || shoppingviewLightBt.isSelected){
            let alert = UIAlertController.init(title: "顏色", message: "請選擇顏色", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }else if !(shoppingviewSizeLBt.isSelected || shoppingviewSizeXLBt.isSelected){
            let alert = UIAlertController.init(title: "尺寸", message: "請選擇尺寸", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        if navigationItem.leftBarButtonItem?.title == "返回" {
            backToPrevious()
        }

    }
    func setBadgevalue() {
        if carts.count == 0 {
            self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
        }else{
            self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = carts.count.description
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
    
    func saveDataFavorite(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context) as! Favorite
        favorite.image = imageview.image?.jpegData(compressionQuality: 1.0)
        favorite.name = goodDetail.name
//        favorite.id = Int16(goodId)
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func showalert(){
        let alertController = UIAlertController(
            title: "已加入我的最愛",
            message: nil,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "確認",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                print()
        })
        alertController.addAction(okAction)
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
    }
}
