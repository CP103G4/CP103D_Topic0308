//
//  loginVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/10.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class loginVC: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 取userDefaults的值出來
        let userDefaults = UserDefaults.standard
        if let jsonData = userDefaults.data(forKey: "Account") {
            //取得陣列的值
            if let account = try? JSONDecoder().decode(Account.self, from: jsonData) {
                userTextField.text = account.username
                passwordTextField.text = account.password
            }
        }
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        if userTextField.text != "" && passwordTextField.text != "" {
            let username = userTextField.text
            let password = passwordTextField.text
            let account = Account(username: username!, password: password!)
            //還需要比對帳密碼是否正確
            // Object Array to JSON，編碼器
            let encoder = JSONEncoder()
            //把陣列轉成json
            let jsonData = try! encoder.encode(account)
            //把json存到userdefault
            let userDefaults = UserDefaults.standard
            userDefaults.set(jsonData, forKey: "Account")
            userDefaults.synchronize()
            
        }
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
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        hideKeyboard()
    }
    
    @IBAction func touch(_ sender: Any) {
        hideKeyboard()
    }
    
    /** 隱藏鍵盤 */
    func hideKeyboard() {
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    
}
