//
//  ManagerUpdateGoodTableViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/4/2.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManagerUpdateGoodTableViewController: UITableViewController {
    var goodDetail = Good.init(id: -1, name: "-1", descrip: "-1", price: -1, mainclass: "-1", subclass: "-1", shelf: "-1", evulation: -1, color1: "-1", color2: "-1", size1: "-1", size2: "-1", specialPrice: -1, quatity: -1)
    
    let url_server = URL(string: common_url + "GoodsServlet1")
    
    @IBOutlet weak var goodnameTextfield: UITextField!
    @IBOutlet weak var goodImageview: UIImageView!
    @IBOutlet weak var color1Switch: UISwitch!
    @IBOutlet weak var color2Switch: UISwitch!
    @IBOutlet weak var sizeLswitch: UISwitch!
    @IBOutlet weak var sizeXLswitch: UISwitch!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var subclassSegment: UISegmentedControl!
    @IBOutlet weak var goodpriceTextfield: UITextField!
    @IBOutlet weak var specialPriceTextfield: UITextField!
    @IBOutlet weak var quatityTextfield: UITextField!   //庫存
    @IBOutlet weak var shelfSwitch: UISwitch!   //上架
    @IBOutlet weak var gooddescriptTextview: UITextView!
//    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goodnameTextfield.text = goodDetail.name
        color1Switch.isOn = goodDetail.color1 == "1" ? true : false//true = 1
        color2Switch.isOn = goodDetail.color2 == "1" ? true : false
        sizeLswitch.isOn = goodDetail.size1 == "1" ? true : false
        sizeXLswitch.isOn = goodDetail.size2 == "1" ? true : false
        sexSegment.selectedSegmentIndex = goodDetail.mainclass == "Woman" ? 0 : 1
        subclassSegment.selectedSegmentIndex = Int(goodDetail.subclass)!
        goodpriceTextfield.text = goodDetail.price.description
        specialPriceTextfield.text = goodDetail.specialPrice.description
        quatityTextfield.text = goodDetail.quatity.description
        shelfSwitch.isOn = Bool(goodDetail.shelf)!
        gooddescriptTextview.text = goodDetail.descrip
        
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = goodDetail.id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = UIScreen.main.bounds.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { self.goodImageview.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }

    }
    
    @IBAction func saveAction(_ sender: Any) {
        let goodname = goodnameTextfield.text == "" ? "" : goodnameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let color1 = color1Switch.isOn.description == "true" ? "1" : (color1Switch.isOn.description == "false" ? "0" : "1") //true = 1
        let color2 = color2Switch.isOn.description == "true" ? "1" : (color2Switch.isOn.description == "false" ? "0" : "1")
        let sizeL = sizeLswitch.isOn.description == "true" ? "1" : (sizeLswitch.isOn.description == "false" ? "0" : "1")
        let sizeXL = sizeXLswitch.isOn.description == "true" ? "1" : (sizeXLswitch.isOn.description == "false" ? "0" : "1")
        let sex = sexSegment.selectedSegmentIndex.description == "0" ? "Woman" : (sexSegment.selectedSegmentIndex.description == "1" ? "Man" : "Woman")
        let subclass = subclassSegment.selectedSegmentIndex.description
        let goodprice = goodpriceTextfield.text == "" ? "-1" : goodpriceTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let specialprice = specialPriceTextfield.text == "" ? "-1" : goodpriceTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let quatity = quatityTextfield.text == "" ? "-1" : quatityTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let shelf = shelfSwitch.isOn.description
        let gooddescript = goodpriceTextfield.text
        if goodname!.isEmpty {
            let alertController = UIAlertController(
                title: "商品名稱不可以為空白",
                message: nil,
                preferredStyle: .alert)
            
            // 建立[確認]按鈕
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
            
            return
        }
        let updateGooddetail = Good(id: goodDetail.id, name: goodname!, descrip: gooddescript!, price: Double(goodprice!)!, mainclass: sex, subclass: subclass, shelf: shelf, evulation: -1, color1: color1, color2: color2, size1: sizeL, size2: sizeXL, specialPrice: Double(specialprice!)!, quatity: Int(quatity!)!)
        var requestParam = [String: String]()
        requestParam["param"] = "update"
        
        requestParam["goodinsert"] = try! String(data: JSONEncoder().encode(updateGooddetail), encoding: .utf8)
        // 有圖才上傳
        if self.goodImageview.image != nil {
            requestParam["imageBase64"] = self.goodImageview.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }else{//named: "noImage.jpg"
            requestParam["imageBase64"] = UIImage(named: "noImage.jpg")?.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                print(count.description)
                                if count != 0 {
                                    self.showCorrectAlert()
                                } else {
                                    self.showErrorAlert()
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
    
    @IBAction func photoButton(_ sender: Any) {
        photo()
    }
    
    func showErrorAlert(){
        let errorAlert = UIAlertController(title: "上傳失敗", message: "請檢查是否輸入錯誤內容", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
        
    }
    
    func showCorrectAlert(){
        let correctAlert = UIAlertController(title: "上傳成功", message: "上傳成功", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Great!", style: .default) { (_) in
            self.next()
        }
        correctAlert.addAction(okAction)
        present(correctAlert, animated: true, completion: nil)
    }
    
    func next(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "managertabbar") {
        //            present(controller, animated: true, completion: nil)
        //        }
        let controller = storyboard.instantiateViewController(withIdentifier: "managertabbar")
        present(controller, animated: true, completion: nil)
    }
    
    func photo(){
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "相機", style: .default, handler: { (_) in
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            /* 照片來源為相機 */
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        controller.addAction(camera)
        
        let pickphoto = UIAlertAction(title: "從相簿選取照片", style: .default) { (_) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(imagePickerController, animated: true, completion: nil)
        }
        controller.addAction(pickphoto)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker(type: .camera)
    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let goodImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            ////////////////
            let maxlength = max(goodImage.size.width, goodImage.size.height)
            let newscale = maxlength / 512
            
            let size = CGSize(width: goodImage.size.width/newscale, height: goodImage.size.height/newscale)
            
            let hasAlpha = false
            let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
            
            UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
            goodImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            ////////////////
            
//            var image = scaledImage
            goodImageview.image = scaledImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteGoodClick(_ sender: Any) {
        var requestParam = [String: String]()
        requestParam["param"] = "delete"
        requestParam["goodId"] = goodDetail.id.description
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                print(count.description)
                                if count != 0 {
                                    self.showCorrectAlert()
                                } else {
                                    self.showErrorAlert()
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
