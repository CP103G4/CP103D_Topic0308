//
//  G87ConsumerInformationViewController.swift
//  CP103D_Topic0308
//
//  Created by User on 2019/3/13.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class G87ConsumerInformationViewController: UIViewController,UIScrollViewDelegate{

    @IBOutlet weak var continer1: UIView!
    @IBOutlet weak var continer2: UIView!
    @IBOutlet weak var continer3: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var Scrollcontroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Scrollcontroll.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        segment.selectedSegmentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
    }
    
    
    
    
    
    @IBAction func pagesegment(_ sender: UISegmentedControl) {
        
        switch segment.selectedSegmentIndex
        {
        case 0:
            Scrollcontroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        case 1:
            Scrollcontroll.setContentOffset(CGPoint(x: Scrollcontroll.bounds.size.width, y: 0), animated: true)
        case 2:
            Scrollcontroll.setContentOffset(CGPoint(x: Scrollcontroll.bounds.size.width * 2, y: 0), animated: true)
        default:
            break;
        }
    }
    

}
