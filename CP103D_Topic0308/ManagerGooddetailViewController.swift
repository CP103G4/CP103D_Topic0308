//
//  ManagerGooddetailViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/30.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import Starscream

class ManagerGooddetailViewController: UIViewController, WebSocketDelegate {
    
    var goodDetail : Good?
    let url_server = URL(string: common_url + "GoodsServlet1")
    let username = "manager"

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var color1Label: UILabel!
    @IBOutlet weak var color2Label: UILabel!
    @IBOutlet weak var size1Label: UILabel!
    @IBOutlet weak var size2Label: UILabel!
    @IBOutlet weak var shelfSwitch: UISwitch!
    var socket: WebSocket!
    let tag = "AllChatVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = goodDetail?.id
        // 圖片寬度為tableViewCell寬，ImageView的寬度也建議在storyboard加上比例設定的constraint
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
                DispatchQueue.main.async { self.imageview.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
        navigationItem.title = goodDetail?.name
        priceLabel.text = goodDetail!.price.description
        color1Label.alpha = (goodDetail!.color1 == "1") ? 1 : 0
        color2Label.alpha = (goodDetail!.color2 == "1") ? 1 : 0
        size1Label.alpha = (goodDetail!.size1 == "1") ? 1 : 0.1
        size2Label.alpha = (goodDetail!.size2 == "1") ? 1 : 0.1
        shelfSwitch.isOn = Bool(goodDetail!.shelf)!
        
        let url_WebSocketserver = URL(string: wscommon_url + "websocketAll/" + username)
        socket = WebSocket(url: url_WebSocketserver!)
        socket.delegate = self
        socket.connect()
    }
    
    @IBAction func updateClick(_ sender: Any) {
        if let managerUploadTableViewController = UIStoryboard(name: "ManagerUpload", bundle: nil).instantiateViewController(withIdentifier: "managerUploadTableViewController") as? ManagerUploadTableViewController{
            managerUploadTableViewController.goodDetail = goodDetail
            managerUploadTableViewController.isGoodUpdate = true
            managerUploadTableViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(managerUploadTableViewController, animated: true)
        }
    }
    
    @IBAction func shelfSwitchAction(_ sender: UISwitch) {
        if sender.isOn == true {
            goodDetail!.shelf = "true"
        }else{
            goodDetail!.shelf = "false"
        }
        goodDetail?.date = nil
        var requestParam = [String: String]()
        requestParam["param"] = "update"
        requestParam["goodinsert"] = try! String(data: JSONEncoder().encode(goodDetail), encoding: .utf8)
        requestParam["imageBase64"] = imageview.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                print(count.description)
                                if count != 0 {
                                    switch requestParam["param"]{
                                    case "update":
                                        self.showCorrectAlert("修改商品：\(self.goodDetail!.name)")
                                        self.pushtoConsumerHome()
                                    default: break
                                    }
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
    
    func showCorrectAlert(_ correctMessage: String){
        let correctAlert = UIAlertController(title: correctMessage, message: correctMessage + "成功！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Great!", style: .default) { (_) in
        }
        correctAlert.addAction(okAction)
        present(correctAlert, animated: true, completion: nil)
    }
    
    func showErrorAlert(){
        let errorAlert = UIAlertController(title: "上傳失敗", message: "請檢查是否輸入錯誤內容", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
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

     // MARK: - Navigation
     /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ManagerUpdateGoodTableViewController
        controller.goodDetail = sender as! Good
     }
     */
}
