//
//  signupVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/8.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class signupVC: UIViewController , UINavigationControllerDelegate {
    
    let url_server = URL(string: common_url + "UserServlet")
    
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfUserName: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var scSex: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerClick(_ sender: Any) {
        let username = tfUserName.text == nil ? "" : tfUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text == nil ? "" : tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = tfName.text == nil ? "" : tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = tfPhone.text == nil ? "" : tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfEmail.text == nil ? "" : tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if username!.isEmpty || password!.isEmpty || name!.isEmpty || phone!.isEmpty || email!.isEmpty {
            showEmptyAlert()
            return
        }
        
        let cellphone = Int(phone!)
        let user = User(userName: username!, password: password!, trueName: name!, phone: cellphone!, email: email!, sex: scSex.selectedSegmentIndex)
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
    
    @IBAction func doneItem(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showEmptyAlert(){
        let emptyAlert = UIAlertController(title: "Register Fail!", message: "Please check your informatiom is correct format.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        emptyAlert.addAction(okAction)
        present(emptyAlert, animated: true, completion: nil)
        
    }
    
    func showErrorAlert(){
        let errorAlert = UIAlertController(title: "Register Fail!", message: "Please check your informatiom is correct format.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
        
    }
    
    func showCorrectAlert(){
        let correctAlert = UIAlertController(title: "Register Success!", message: "Now you can login and enjoy shopping.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Great!", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        correctAlert.addAction(okAction)
        present(correctAlert, animated: true, completion: nil)
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
