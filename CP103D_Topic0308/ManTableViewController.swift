//
//  ManTableViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/26.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class ManTableViewController: UITableViewController {
    var goods = [Good]()
    var goodsSubclass = [Good]()
    var goodsSubclassCloth = [Good]()
    var goodsSubclassPants = [Good]()
    var goodsSubclassUnderwear = [Good]()
    var goodsSubclassOther = [Good]()
    let url_server = URL(string: common_url + "GoodsServlet1")
    var collectionIndex = IndexPath(row: -1, section: -1)
    
    func tableViewAddRefreshControl() { //  refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(downloadManGoods), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewAddRefreshControl()
        downloadManGoods()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manTableViewCell", for: indexPath) as! ManTableViewCell
        cell.manCollectionviewOutlet.tag = indexPath.section
        cell.manCollectionviewOutlet.reloadData()
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! GooddetailViewController
        controller.goodDetail = sender as! Good
    }
    
    @objc func downloadManGoods(){
        var requestParam = [String: String]()
        requestParam["param"] = "Man"
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
                        self.goodsSubclassCloth = self.goods.filter { (good) -> Bool in    //用filter將子分類篩選
                            good.subclass == "0"
                        }
                        self.goodsSubclassPants = self.goods.filter { (good) -> Bool in    //用filter將子分類篩選
                            good.subclass == "1"
                        }
                        
                        self.goodsSubclassUnderwear = self.goods.filter { (good) -> Bool in    //用filter將子分類篩選
                            good.subclass == "2"
                        }
                        
                        self.goodsSubclassOther = self.goods.filter { (good) -> Bool in    //用filter將子分類篩選
                            good.subclass == "3"
                        }
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            self.tableView.reloadData()
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
extension ManTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        switch collectionView.tag.description {
        case "0":
            count = goodsSubclassCloth.count
        case "1":
            count = goodsSubclassPants.count
        case "2":
            count = goodsSubclassUnderwear.count
        case "3":
            count = goodsSubclassOther.count
        default:
            count = 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "manCollectionViewCell", for: indexPath) as! ManCollectionViewCell
        
        switch collectionView.tag.description {
        case "0":
            goodsSubclass = goodsSubclassCloth
        case "1":
            goodsSubclass = goodsSubclassPants
        case "2":
            goodsSubclass = goodsSubclassUnderwear
        case "3":
            goodsSubclass = goodsSubclassOther
        default:
            goodsSubclass = [Good]()
        }
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["param"] = "getImage"
        requestParam["id"] = goodsSubclass[indexPath.row].id
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
                DispatchQueue.main.async { cell.manCollectionviewImageview.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        cell.manCollectionviewLabel.text = goodsSubclass[indexPath.row].name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionIndex = IndexPath(row: indexPath.row, section: collectionView.tag)
        print(collectionIndex.description)
        let goodDetail = goods.filter({ (good) -> Bool in
            good.subclass == collectionIndex.section.description
        })[collectionIndex.row]
        performSegue(withIdentifier: "manSegue", sender: goodDetail)
    }
}
