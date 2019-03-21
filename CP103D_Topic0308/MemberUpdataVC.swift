//
//  MemberUpdataVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/21.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class MemberUpdataVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    let url_server = URL(string: common_url + "UserServlet")
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func clickUpdata(_ sender: Any) {
        user.trueName = nameTextField.text == nil ? "" : nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = emailTextField.text == nil ? "" : emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var requestParam = [String: String]()
        requestParam["action"] = "update"
        requestParam["user"] = try! String(data: JSONEncoder().encode(self.user), encoding: .utf8)
        
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.showalert()
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
    
    func showalert(){
        let alertController = UIAlertController(
            title: "更新失敗",
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
    
    func showUser(){
        nameTextField.text = user.trueName
        emailTextField.text = user.email
    }
    

}
