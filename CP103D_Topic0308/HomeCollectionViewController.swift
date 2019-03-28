//
//  HomeCollectionViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/27.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "homeCollectionViewCell"

class HomeCollectionViewController: UICollectionViewController {
    var goods = [Good]()
    var goodDetail = Good.init(id: -1, name: "-1", descrip: "-1", price: -1, mainclass: "-1", subclass: "-1", shelf: "-1", date: Date.init(), evulation: -1, color1: "-1", color2: "-1", size1: "-1", size2: "-1", specialPrice: -1, quatity: -1)
    
    let url_server = URL(string: common_url + "GoodsServlet1")
    
    func tableViewAddRefreshControl() { //  refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllGoods), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsize()
        tableViewAddRefreshControl()
        showAllGoods()
        // Do any additional setup after loading the view.
    }
    func setCellsize(){
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        // Cell的大小
        let cellwidth = (UIScreen.main.bounds.size.width - CGFloat(8*3))/2
        layout.itemSize = CGSize(width: cellwidth, height: cellwidth)
        // 同一列Cell之間的間距
        layout.minimumInteritemSpacing = 8
        // 列和列之間的間距
        layout.minimumLineSpacing = 20
        // Section的邊界
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let controller = segue.destination as! GooddetailViewController
        let indexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)
        controller.goodDetail = goods[(indexPath?.row)!]
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return goods.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = goods[indexPath.row].id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { cell.homecellImageview.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        cell.homecellLabel.text = goods[indexPath.row].name
        goodDetail = goods[indexPath.row]
        return cell    }

    // MARK: UICollectionViewDelegate

    @objc func showAllGoods(){
        var requestParam = [String: String]()
        requestParam["param"] = "getAll"
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(format)
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    do{
                        self.goods = try decoder.decode([Good].self, from: data!)
                        DispatchQueue.main.async {
                            if let control = self.collectionView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.collectionView.reloadData()
                        }
                    }catch{
                        print(error)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}
