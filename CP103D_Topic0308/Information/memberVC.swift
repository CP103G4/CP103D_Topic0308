//
//  memberVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/10.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class memberVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var user: User?
    let url_server = URL(string: common_url + "UserServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = loadUser()
        loadData()
        
    }
    
    
    @IBAction func logoutClick(_ sender: Any) {
        
        let correctAlert = UIAlertController(title: "你正準備登出會員", message: "你確定要登出會員?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "是的", style: .default) { (_) in
            clearUser()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! loginVC
            self.present(controller, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "沒有", style: .default) { (_) in
            return
        }
        
        correctAlert.addAction(okAction)
        correctAlert.addAction(cancelAction)
        present(correctAlert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showInfo()
    }
    
    @IBAction func clickcamera(_ sender: UIButton) {
        photo()
    }
    
    @IBAction func clickImage(_ sender: Any) {
        photo()
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
    
    /* 實作UIImagePickerControllerDelegate */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func showInfo(){
        var requestParam = [String: String]()
        requestParam["action"] = "findByUser"
        requestParam["user"] = try! String(data: JSONEncoder() .encode(user), encoding: .utf8)
        
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let user = try? JSONDecoder().decode(User.self, from: data!) {
                        self.user = user
                        DispatchQueue.main.async {
                            self.nameLabel.text = user.trueName
                            self.phoneLabel.text = user.phone
                            self.emailLabel.text = user.email
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "userupdata"{
            let user = self.user
            let updataVC = segue.destination as! MemberUpdataVC
            updataVC.user = user
        }
    }
    
    func loadData(){
        let userDefaults = UserDefaults.standard
        
        if let name = userDefaults.string(forKey: "name") {
            nameLabel.text = name
        }
        
        if let email = userDefaults.string(forKey: "email") {
            emailLabel.text = email
        }
    }
    
}
