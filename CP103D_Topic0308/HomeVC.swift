//
//  HomeVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/15.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import Starscream
import UserNotifications

class HomeVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mainclassSegment: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var socket: WebSocket!

    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = loadUser()
        let username = userInfo?.userName
        let url_WebSocketserver = URL(string: wscommon_url + "websocketAll/" + username!)
        socket = WebSocket(url: url_WebSocketserver!)
        socket.delegate = self
        socket.connect()
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainclassSegment.selectedSegmentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
    }
    
    @IBAction func mainclassSegmentAction(_ sender: Any) {
        switch mainclassSegment.selectedSegmentIndex {
        case 0:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            break
        case 1:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width, y: 0), animated: true)
            break
        case 2:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width * 2, y: 0), animated: true)
            break
        default:
            break
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
extension HomeVC: WebSocketDelegate{
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription ?? "")")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        if let result = try? JSONDecoder().decode([String: String].self, from: text.data(using: .utf8)!) {
            let textmessage = "\(result["userName"]!): \(result["message"]!)"
            print(textmessage)
            //這邊要彈出通知視窗
            
            onClickCreateNotificationBtn(result["goodName"]!)
        }
        print("got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("\(self.tag) got some data: \(data.count)")
    }

    func next(){
        let storyboard = UIStoryboard(name: "ConsumerHome", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "comsumerHome")
        present(controller, animated: true, completion: nil)
    }
    
    func onClickCreateNotificationBtn(_ goodname:String) {
        let content = UNMutableNotificationContent()
        content.title = "新貨上架通知"
        content.subtitle = "商品名稱" + goodname
        content.body = goodname
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
//            print("成功建立通知...")
        })
    }
}

