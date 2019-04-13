//
//  ShowQRcodeVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/4/13.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ShowQRcodeVC: UIViewController {
    
    
    @IBOutlet weak var ivShowQRcode: UIImageView!
    var order: Order!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        qrcode()
    }
    
    func qrcode(){
        let text = String(order!.id!)
        // 將文字轉成Data，編碼採ASCII
        let data = text.data(using: String.Encoding.ascii)
        // 建立CIFilter物件，準備產生QR code
        guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // 使用CIFilter產生QR code要給予key-"inputMessage", value-文字值
        ciFilter.setValue(data, forKey: "inputMessage")
        // 取得產生好的QR code圖片，不過圖片很小
        guard let ciImage_smallQR = ciFilter.outputImage else { return }
        
        // QR code圖片很小，需要放大
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
        // 將CIImage轉成UIImage顯示
        let uiImage = UIImage(ciImage: ciImage_largeQR)
        ivShowQRcode.image = uiImage
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
