//
//  SignupTVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/4/16.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class SignupTVC: UITableViewController {
    
    let url_server = URL(string: common_url + "UserServlet")
    
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var scSex: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //收鍵盤
    @IBAction func returnNameKB(_ sender: Any) {
    }
    @IBAction func returnUsernameKB(_ sender: Any) {
    }
    @IBAction func returnPasswordKB(_ sender: Any) {
    }
    @IBAction func returnEmailKB(_ sender: Any) {
    }
    @IBAction func returnPhoneKB(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelClick(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registerClick(_ sender: Any) {
        let username = tfUsername.text == nil ? "" : tfUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text == nil ? "" : tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = tfName.text == nil ? "" : tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = tfPhone.text == nil ? "" : tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfEmail.text == nil ? "" : tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if username!.isEmpty || password!.isEmpty || name!.isEmpty || phone!.isEmpty || email!.isEmpty {
            showEmptyAlert()
            return
        }
        
        
        let user = User(userName: username!, password: password!, trueName: name!, phone: phone!, email: email!, sex: scSex.selectedSegmentIndex)
        var requestParam = [String: String]()
        requestParam["action"] = "insert"
        requestParam["user"] = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
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
    
    func showEmptyAlert(){
        let emptyAlert = UIAlertController(title: "註冊失敗!", message: "請確定輸入的資料是正確的", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        emptyAlert.addAction(okAction)
        present(emptyAlert, animated: true, completion: nil)
        
    }
    
    func showErrorAlert(){
        let errorAlert = UIAlertController(title: "註冊失敗!", message: "請確定輸入的資料是正確的", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
        
    }
    
    func showCorrectAlert(){
        let correctAlert = UIAlertController(title: "註冊成功!", message: "你現在可以登入並好好享受購物購物的樂趣", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "太棒了!", style: .default) { (_) in
            
            let user = User(self.tfUsername.text!, self.tfPassword.text!)
            if saveUser(user) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "loginNav")
            self.present(controller, animated: true, completion: nil)
            } else {
                return
            }
        }
        correctAlert.addAction(okAction)
        present(correctAlert, animated: true, completion: nil)
    }
    

}
