//
//  ScanQRCodeVC.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // 預覽時管理擷取影像的物件
    var captureSession: AVCaptureSession!
    // 預覽畫面
    var previewLayer: AVCaptureVideoPreviewLayer!
    // 偵測到QR code時需要加框
    var qrFrameView: UIView!
    // 當user決定加好友時呼叫
    var completionHandler:((String) -> Void)?
    ///
    let url_server = URL(string: common_url + "OrderServlet")
    var order : Order!
    ////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPreviewAndScanQR()
    }
    
    func startPreviewAndScanQR() {
        // 管理影像擷取期間的輸入與輸出
        captureSession = AVCaptureSession()
        // 負責擷取影像的預設裝置
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        // 建立輸入物件
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        if (captureSession.canAddInput(input)) {
            // 設定擷取期間的輸入
            captureSession.addInput(input)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            // 設定擷取期間的輸出
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // 欲處理的類型為QR code
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        // 建立擷取期間所需顯示的預覽圖層
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        createQRFrame()
        preview(true)
    }
    
    // 建立QR code掃描框
    func createQRFrame() {
        qrFrameView = UIView()
        qrFrameView.layer.borderColor = UIColor.yellow.cgColor
        qrFrameView.layer.borderWidth = 3
        view.addSubview(qrFrameView)
        view.bringSubviewToFront(qrFrameView)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 將取得的資訊轉成條碼資訊
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            guard let qrString = metadataObject.stringValue else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            scanSuccess(qrCode: qrString)
            if let barCodeObject = previewLayer.transformedMetadataObject(for: metadataObject) {
                // 成功解析就將QR code圖片框起來
                qrFrameView.frame = barCodeObject.bounds
            }
        } else {
            // 無法轉成條碼資訊就將圖框隱藏
            qrFrameView.frame = CGRect.zero
        }
    }
    
    func scanSuccess(qrCode: String) {
        print(qrCode)
        // 停止預覽
        preview(false)
        makeFriend(name: qrCode)
    }
    
    func makeFriend(name: String) {
        let alert = UIAlertController(title: "確定編輯訂單編號（id）： \(name)?", message: nil, preferredStyle: .alert)
        print("id:",(name))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            // 同意加朋友需將朋友傳給前頁
            var requestParam = [String: String]()
            let encoder = JSONEncoder()
            let format = DateFormatter()
            
            
            self.order = Order(Int(name)!, 1)
            
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            encoder.dateEncodingStrategy = .formatted(format)
            requestParam["action"] = "orderUpdate"
            requestParam["order"] = try! String(data: encoder.encode(self.order
            ), encoding: .utf8)
            
            executeTask(self.url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    print("inputcount:",count)
                                    // 新增成功則回前頁
                                    if count != 0 {
                                        print("update sucess")
                                    } else {
                                        //                                    self.lbOrderId.text = "update fail"
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            //            self.completionHandler?(name)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.preview(true)
        }))
        present(alert, animated: true)
    }
    
    func failed() {
        let alert = UIAlertController(title: "Scanning not supported", message: "Please use a device with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
    // 是否開啟預覽畫面
    func preview(_ yes: Bool) {
        if yes {
            // 讓QR code掃描框消失 (避免前一次QR code掃描框留在畫面上)
            qrFrameView.frame = CGRect.zero
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        } else {
            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
        }
        preview(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .all
        }
        preview(false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
//    func qrcode(){
//        let text = String(order!.id!)
//        // 將文字轉成Data，編碼採ASCII
//        let data = text.data(using: String.Encoding.ascii)
//        // 建立CIFilter物件，準備產生QR code
//        guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
//        // 使用CIFilter產生QR code要給予key-"inputMessage", value-文字值
//        ciFilter.setValue(data, forKey: "inputMessage")
//        // 取得產生好的QR code圖片，不過圖片很小
//        guard let ciImage_smallQR = ciFilter.outputImage else { return }
//
//        // QR code圖片很小，需要放大
//        let transform = CGAffineTransform(scaleX: 3, y: 3)
//        let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
//        // 將CIImage轉成UIImage顯示
//        let uiImage = UIImage(ciImage: ciImage_largeQR)
//        qrcodeimage.image = uiImage
//    }
    
    
}
