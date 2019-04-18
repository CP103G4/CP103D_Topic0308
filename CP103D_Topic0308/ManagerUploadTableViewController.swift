//
//  ManagerUploadTableViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/29.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import ImageIO
import Starscream

class ManagerUploadTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, WebSocketDelegate {
    
    let url_server = URL(string: common_url + "GoodsServlet1")
    @IBOutlet weak var goodnameTextfield: UITextField!
    @IBOutlet weak var goodImageview: UIImageView!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var subclassSegment: UISegmentedControl!
    @IBOutlet weak var goodpriceTextfield: UITextField!

    @IBOutlet weak var shelfSwitch: UISwitch!   //上架
    @IBOutlet weak var gooddescriptTextview: UITextView!
    
    @IBOutlet weak var saveItem: UIBarButtonItem!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    
    var image: UIImage?
    var socket: WebSocket!
    let tag = "AllChatVC"
    let username = "manager"
    var isGoodUpdate = false    
    var goodDetail : Good?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gooddescriptTextview.text == "" {
            gooddescriptTextview.text = "請輸入商品介紹"
            gooddescriptTextview.textColor = UIColor.lightGray
        }
        if isGoodUpdate {
            saveItem.title = "儲存"
            navigationItem.title = "修改商品資訊"
            deleteButtonOutlet.isHidden = false
            deleteButtonOutlet.isEnabled = true
            
        }else{
            deleteButtonOutlet.isHidden = true
            deleteButtonOutlet.isEnabled = false
            uploadButtonOutlet.isHidden = false
            uploadButtonOutlet.isEnabled = true
        }
        
        let url_WebSocketserver = URL(string: wscommon_url + "websocketAll/" + username)
        socket = WebSocket(url: url_WebSocketserver!)
        socket.delegate = self
        socket.connect()
        hideKeyboardByGesture()
        if isGoodUpdate {
            loadGoodDetail()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.layer.zPosition = 0
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if gooddescriptTextview.text == "請輸入商品介紹"{
            gooddescriptTextview.text = nil
            gooddescriptTextview.textColor = UIColor.black
        }else{
            gooddescriptTextview.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if gooddescriptTextview.text.isEmpty {
            gooddescriptTextview.text = "請輸入商品介紹"
            gooddescriptTextview.textColor = UIColor.lightGray
        }
    }
    
    func loadGoodDetail() {
        goodnameTextfield.text = goodDetail!.name

        sexSegment.selectedSegmentIndex = goodDetail!.mainclass == "Woman" ? 0 : 1
        subclassSegment.selectedSegmentIndex = Int(goodDetail!.subclass)!
        goodpriceTextfield.text = Int(goodDetail!.price).description

        shelfSwitch.isOn = Bool(goodDetail!.shelf)!
        gooddescriptTextview.text = goodDetail!.descrip
        
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = goodDetail!.id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = UIScreen.main.bounds.width * 0.8
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
        let color1 = "1"//color1Switch.isOn.description == "true" ? "1" : (color1Switch.isOn.description == "false" ? "0" : "1") //true = 1
        let color2 = "1"//color2Switch.isOn.description == "true" ? "1" : (color2Switch.isOn.description == "false" ? "0" : "1")
        let sizeL = "1"//sizeLswitch.isOn.description == "true" ? "1" : (sizeLswitch.isOn.description == "false" ? "0" : "1")
        let sizeXL = "1"//sizeXLswitch.isOn.description == "true" ? "1" : (sizeXLswitch.isOn.description == "false" ? "0" : "1")
        let sex = sexSegment.selectedSegmentIndex.description == "0" ? "Woman" : (sexSegment.selectedSegmentIndex.description == "1" ? "Man" : "Woman")
        let subclass = subclassSegment.selectedSegmentIndex.description
        let goodprice = goodpriceTextfield.text == "" ? "-1" : goodpriceTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let shelf = shelfSwitch.isOn.description
        let gooddescript = gooddescriptTextview.text
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
        var goodId = -1
        
        if goodDetail == nil {
            goodId = -1
        }else{
            goodId = goodDetail!.id
        }
        goodDetail = Good(id: goodId, name: goodname!, descrip: gooddescript!, price: Double(goodprice!)!, mainclass: sex, subclass: subclass, shelf: shelf, evulation: -1, color1: color1, color2: color2, size1: sizeL, size2: sizeXL, specialPrice: -1, quatity: -1)
        
        var requestParam = [String: String]()
        if !isGoodUpdate {
            requestParam["param"] = "insert"
            requestParam["goodinsert"] = try! String(data: JSONEncoder().encode(goodDetail), encoding: .utf8)
        }else{
            requestParam["param"] = "update"
            requestParam["goodinsert"] = try! String(data: JSONEncoder().encode(goodDetail), encoding: .utf8)
        }
        // 有圖才上傳
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }else{
            requestParam["imageBase64"] = goodImageview.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                print(count.description)
                                if count != 0 {
                                    switch requestParam["param"]{
                                    case "insert":
                                        self.showCorrectAlert("上傳商品：\(self.goodDetail!.name)")
                                    case "update":
                                        self.showCorrectAlert("修改商品：\(self.goodDetail!.name)")
                                    default: break
                                    }
                                    self.pushtoConsumerHome()
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
    func pushtoConsumerHome() {
        //推播訊息
        if shelfSwitch.isOn == true {
            do {
                var dictionary = [String: String]()
                dictionary["userName"] = username
                dictionary["message"] = goodDetail!.name + "上架啦～～～"
                dictionary["goodName"] = goodDetail!.name
                let jsonData = try JSONEncoder().encode(dictionary)
                let text = String(data: jsonData, encoding: .utf8)
                socket.write(string: text!)
                print("傳送推播訊息\(dictionary["message"]!)")
                //                socket.disconnect()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func deleteGood(_ sender: Any) {
        var requestParam = [String: String]()
        requestParam["param"] = "delete"
        requestParam["goodId"] = goodDetail!.id.description
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                print(count.description)
                                if count != 0 {
                                    self.showCorrectAlert("刪除商品：\(self.goodDetail!.name)")
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
    
    func showCorrectAlert(_ correctMessage: String){
        let correctAlert = UIAlertController(title: correctMessage, message: correctMessage + "成功！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Great!", style: .default) { (_) in
            self.next()            
        }
        correctAlert.addAction(okAction)
        present(correctAlert, animated: true, completion: nil)
    }
    
    func next(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "managertabbar")
        present(controller, animated: true, completion: nil)
    }
    
    func photo(){
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "相機", style: .default, handler: { (_) in
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            /* 照片來源為相機 */
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        controller.addAction(camera)
        
        let pickphoto = UIAlertAction(title: "從相簿選取照片", style: .default) { (_) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
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
        imagePickerController.delegate = self
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
            
            image = scaledImage
            goodImageview.image = scaledImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription ?? "")")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let result = try? JSONDecoder().decode([String: String].self, from: text.data(using: .utf8)!) {
            print("\(result["userName"]!): \(result["message"]!)")
            //這邊要彈出通知視窗
        }
        print("\(self.tag) got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("\(self.tag) got some data: \(data.count)")
    }
    
    func hideKeyboardByGesture() {
        //透過手勢隱藏鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard() {//透過手勢隱藏鍵盤
        self.view.endEditing(true)
    }

    
    @IBAction func hidekeyboard(_ sender: Any) {
        //按下return收鍵盤
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
