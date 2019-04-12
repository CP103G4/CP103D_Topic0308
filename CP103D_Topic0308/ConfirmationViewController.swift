//
//  ConfirmationViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/4/1.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    var carts = [Cart]()

    override func viewDidLoad() {
        super.viewDidLoad()
        saveData(carts: carts)
        // Do any additional setup after loading the view.
    }
    func fileInDocuments(fileName: String) -> URL {
        let fileManager = FileManager()
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = urls.first!.appendingPathComponent(fileName)
        return fileUrl
    }
    func saveData(carts:[Cart]) {
        let dataUrl = fileInDocuments(fileName: "cartData")
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(carts)
        do {
            /* 如果將requiringSecureCoding設為true，Spot類別必須改遵從NSCoding的子型NSSecureCoding */
            let cartData = try NSKeyedArchiver.archivedData(withRootObject: jsonData, requiringSecureCoding: true)
            try cartData.write(to: dataUrl)
        } catch let error {
            print(error.localizedDescription)
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
