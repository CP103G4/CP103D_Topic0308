//
//  PayforcardViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/4/12.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class PayforcardViewController: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var displayText: UITextView!
    var tpdCard : TPDCard!
    var tpdForm : TPDForm!
    var requestParam : [String: String]!
    let url_server3 = URL(string: common_url + "OrderdetailServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "信用卡付款"
        // 1. Setup TPDForm With Your Customized CardView, Recommend(width:260, height:80)
        tpdForm = TPDForm.setup(withContainer: cardView)
        
        // 2. Setup TPDForm Text Color
        tpdForm.setErrorColor(colorWithRGB(rgbString: "D62D20", alpha: 1.0))
        tpdForm.setOkColor(colorWithRGB(rgbString: "008744", alpha: 1.0))
        tpdForm.setNormalColor(colorWithRGB(rgbString: "0F0F0F", alpha: 1.0))
        
        
        
        // 3. Setup TPDForm onFormUpdated Callback
        tpdForm.onFormUpdated { (status) in
            
            // Use callback Get Status.
            
            weak var weakSelf = self
            
            weakSelf?.payButton.isEnabled = status.isCanGetPrime()
            weakSelf?.payButton.alpha     = (status.isCanGetPrime()) ? 1.0 : 0.25
            
        }
        
        // Button Disable (Default)
        payButton.isEnabled = false
        payButton.alpha     = 0.25
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - @IBAction
    @IBAction func doneAction(_ sender: Any) {
        
        // Example Card
        // Number : 4242 4242 4242 4242
        // DueMonth : 01
        // DueYear : 23
        // CCV : 123
        
        // 1. Setup TPDCard.
        tpdCard = TPDCard.setup(tpdForm)
        
        // 2. Setup TPDCard on Success Callback.
        tpdCard.onSuccessCallback { (prime, cardInfo) in
            
            let result = "Prime : \(prime!),\n LastFour : \(cardInfo!.lastFour!),\n Bincode : \(cardInfo!.bincode!),\n Issuer : \(cardInfo!.issuer!),\n cardType : \(cardInfo!.cardType),\n funding : \(cardInfo!.cardType),\n country : \(cardInfo!.country!),\n countryCode : \(cardInfo!.countryCode!),\n level : \(cardInfo!.level!)"
            
            print(result)
            
            DispatchQueue.main.async {
                //                let payment = "Use below cURL to proceed the payment.\ncurl -X POST \\\nhttps://sandbox.tappaysdk.com/tpc/payment/pay-by-prime \\\n-H \'content-type: application/json\' \\\n-H \'x-api-key: partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\' \\\n-d \'{ \n \"prime\": \"\(prime!)\", \"partner_key\": \"partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\", \"merchant_id\": \"GlobalTesting_CTBC\", \"details\":\"TapPay Test\", \"amount\": 100, \"cardholder\": { \"phone_number\": \"+886923456789\", \"name\": \"Jane Doe\", \"email\": \"Jane@Doe.com\", \"zip_code\": \"12345\", \"address\": \"123 1st Avenue, City, Country\", \"national_id\": \"A123456789\" }, \"remember\": true }\'"
                //                self.displayText.text = payment
                //                print(payment)
                
                executeTask(self.url_server3!, self.requestParam) { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            print("input: \(String(data: data!, encoding: .utf8)!)")
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
            
            weak var weakSelf = self
            weakSelf?.showResult(message: "付款成功")
            
            
            // 3. Setup TPDCard on Failure Callback.
            }.onFailureCallback { (status, message) in
                
                let result = "status : \(status),\n message : \(message)"
                
                print(result)
                
                weak var weakSelf = self
                weakSelf?.showResult(message: result)
                
                // 4. Get Prime WIth TPDCard.
            }.getPrime()
        
    }
    
    @IBAction func getFraudId(_ sender: Any) {
        
        let fraudId = TPDSetup.shareInstance().getFraudID()
        
        // If use pay-by-token. Get fraud ID before first, and send fraud id to your request.
        let result = "Send Fraud Id : \(fraudId!) to your server, bring it on when you request pay-by-token API"
        
        print(result)
        showResult(message: result)
        
    }
    
    //MARK: - Function
    func showResult(message:String!){
        
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            self.performSegue(withIdentifier: "ThankPage", sender: nil)
            
        }
        
        alertController.addAction(doneAction)
        
        DispatchQueue.main.async {
            weak var weakSelf = self
            weakSelf?.present(alertController, animated: true, completion: {
            })
        }
        
    }
    
    
    func colorWithRGB(rgbString:String!, alpha:CGFloat!) -> UIColor! {
        
        let scanner = Scanner.init(string: rgbString.lowercased())
        var baseColor:UInt64 = UInt64()
        scanner.scanHexInt64(&baseColor)
        
        let red     = ((CGFloat)((baseColor & 0xFF0000) >> 16)) / 255.0
        let green   = ((CGFloat)((baseColor & 0xFF00) >> 8)) / 255.0
        let blue    = ((CGFloat)(baseColor & 0xFF)) / 255.0
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
