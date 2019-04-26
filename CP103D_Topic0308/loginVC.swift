//
//  loginVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/10.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit




class loginVC: UIViewController,FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var loginManager: FBSDKLoginManager?
    let url_server = URL(string: common_url + "UserServlet")
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "使用者登入"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email"]
        loginManager = FBSDKLoginManager()
        loginManager?.loginBehavior = FBSDKLoginBehavior.web
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 取userDefaults的值出來
        user = loadUser()
        userTextField.text = user?.userName
        passwordTextField.text = user?.password
//        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //return收鍵盤
    @IBAction func closeKeyBoard(_ sender: Any) {
    }
    
    
    @IBAction func closekeyboard(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func clickLogin(_ sender: UIButton) {
        let username = userTextField.text == nil ? "" : userTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text == nil ? "" : passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        // 建立一個提示框
        if username!.isEmpty || password!.isEmpty {
            let alertController = UIAlertController(
                title: "帳號密碼不可以為空白",
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
        
        let user = User(username!, password!)
        var requestParam = [String: String]()
        requestParam["action"] = "comparison"
        requestParam["user"] = try! String(data: JSONEncoder() .encode(user), encoding: .utf8)
        
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([String: Bool].self, from: data!) {
                        // server驗證帳密成功會回傳true
                        if result["success"]! {
                            let saved = saveUser(user)
                            print("saved = \(saved)")
                            // 開啟下一頁
                            DispatchQueue.main.async {
                                self.next()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showalert()
                            }
                        }
                        print(result)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func showalert(){
        let alertController = UIAlertController(
            title: "帳號或密碼錯誤",
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
    
    func next() {
//        let storyboard = UIStoryboard(name: "ConsumerHome", bundle: nil)
        user = loadUser()
        if user?.userName == "1234"{
            clearUser()
            if let controller = storyboard?.instantiateViewController(withIdentifier: "managertabbar") {
                present(controller, animated: true, completion: nil)
            }
            //管理者帳號:1234
        } else {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TabBar") {
                present(controller, animated: true, completion: nil)
            }
        }
        //performSegue(withIdentifier: "toMainPage", sender: nil)
    }
    
    
    
    @IBAction func clickClear(_ sender: Any) {
        clear()
    }
    
    
    func clear() {
        userTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    
//    @IBAction func clickFBLogin(_ sender: Any) {
//        if FBSDKAccessToken.current() == nil {
//            loginManager?.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
//                if error == nil {
//                    if result != nil && !result!.isCancelled {
//                        self.next()
//                    }
//                }
//            })
//        }
//    }
//
//
//    @IBAction func clickFBLogout(_ sender: Any) {
//        loginManager?.logOut()
//    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if FBSDKAccessToken.current() == nil {
            loginManager?.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
                if error == nil {
                    if result != nil && !result!.isCancelled {
                        
                        self.saveProfile()
                        self.next()
                    }
                }
            })
        } else {
             saveProfile()
             next()
        }
    }
    

    
    func saveProfile(){
        // 可以指定照片尺寸，參看https://developers.facebook.com/docs/graph-api/reference/user/picture/
        let param = ["fields":"id, name, email, picture.width(600).height(600)"]
        // let param = ["fields":"name, email, picture.type(large)"]
        let myGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: param)
        var userName = ""
        var email = ""
        
        myGraphRequest?.start(completionHandler: { (connection, result, error) in
            if error == nil {
                if result != nil {
                    print("result: \(result!)")
                    if let resultDic = result as? [String : Any]{
                        userName = resultDic["name"] as! String
                        email = resultDic["email"] as! String
                        
                        if let picture = resultDic["picture"] as? NSDictionary{
                            let data = picture["data"] as! NSDictionary
                            let pictureUrl = data["url"] as! String
                            let imgData = NSData(contentsOf: URL(string: pictureUrl)!)
                            DispatchQueue.main.async {
                                let userImage = imgData! as Data
                                self.saveImage(userImage)
                            }
                        }
                    }

                    let user1 = User(email, email)
                    let user2 = User(userName: email, password: email, trueName: userName, phone: "", email: email, sex: -1)
                    self.user = user2
            
                    let saved = saveUser(user1)
                    print("saved = \(saved)")
                    
                    var requestParam = [String: String]()
                    requestParam["action"] = "insert"
                    requestParam["user"] = try! String(data: JSONEncoder().encode(self.user), encoding: .utf8)
                    executeTask(self.url_server!, requestParam) { (data, response, error) in
                        if error == nil {
                            if data != nil {
                                if let result = String(data: data!, encoding: .utf8) {
                                    if let count = Int(result) {
                                        DispatchQueue.main.async {
                                            if count != 0 {
                                            
                                            } else {

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
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("登出")
    }
    
    func saveImage(_ image: Data) -> () {
            let userDefaults = UserDefaults.standard
            userDefaults.set(image, forKey: "image")
            userDefaults.synchronize()
            print("有無存取" + "\(userDefaults.synchronize())")
        
    }


    
}
