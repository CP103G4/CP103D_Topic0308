//
//  ChartVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/4/4.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ChartVC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scMonth: UISegmentedControl!
    @IBOutlet weak var svChart: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scMonth.selectedSegmentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        print(svChart.contentOffset.x)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scMonth.selectedSegmentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
//        print(scMonth.selectedSegmentIndex)
//    }
    
    
    
    @IBAction func scChangeMonth(_ sender: Any) {
        switch scMonth.selectedSegmentIndex {
        case 0:
            svChart.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            break
        case 1:
            svChart.setContentOffset(CGPoint(x: svChart.bounds.size.width, y: 0), animated: true)
            break
        default:
            break
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
