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

class loginVC: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var loginManager: FBSDKLoginManager?
    let url_server = URL(string: common_url + "UserServlet")
    var user: User?
    
    
    override func viewDidLoad() {
        loginManager = FBSDKLoginManager()
        loginManager?.loginBehavior = FBSDKLoginBehavior.web
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
        if let controller = storyboard?.instantiateViewController(withIdentifier: "TabBar") {
        present(controller, animated: true, completion: nil)
        }
        //performSegue(withIdentifier: "toMainPage", sender: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 取userDefaults的值出來
        user = loadUser()
        userTextField.text = user?.userName
        passwordTextField.text = user?.password

    }
    
    
    @IBAction func clickClear(_ sender: Any) {
        clear()
    }
    
    @IBAction func clickshopping(_ sender: Any) {
        clearUser()
    }
    
    
    func clear() {
        userTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @IBAction func clickFBLogin(_ sender: Any) {
        if FBSDKAccessToken.current() == nil {
            loginManager?.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
                if error == nil {
                    if result != nil && !result!.isCancelled {
                        print("Logged in!")
                        self.next()
                    }
                }
            })
        }
    }
    
    
    @IBAction func clickFBLogout(_ sender: Any) {
        loginManager?.logOut()
    }
    
    
}
