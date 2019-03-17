//
//  HomeVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/15.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mainclassSegment: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainclassSegment.selectedSegmentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
    }
    
    @IBAction func mainclassSegmentAction(_ sender: Any) {
        switch mainclassSegment.selectedSegmentIndex {
        case 0:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            break
        case 1:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width, y: 0), animated: true)
            break
        case 2:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width * 2, y: 0), animated: true)
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
