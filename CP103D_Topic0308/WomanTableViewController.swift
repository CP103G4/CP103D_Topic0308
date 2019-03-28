//
//  HomeTableViewController.swift
//  CP103D_Topic0308
//
//  Created by min-chia on 2019/3/19.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit

class WomanTableViewController: UITableViewController {
    var goods = [Good]()
    var goodsSubclass = [Good]()
    let url_server = URL(string: common_url + "GoodsServlet1")
    var collectionIndex = IndexPath(row: -1, section: -1)
    
    func tableViewAddRefreshControl() { //  refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showWomanGoods), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewAddRefreshControl()
        showWomanGoods()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "womanTableViewCell", for: indexPath) as! WomanTableViewCell
        cell.womanCollectionviewOutlet.tag = indexPath.section
        cell.womanCollectionviewOutlet.reloadData()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    @objc func showWomanGoods(){
        var requestParam = [String: String]()
        requestParam["param"] = "Woman"
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
extension WomanTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        goodsSubclass = goods.filter { (good) -> Bool in    //用filter將子分類篩選
            good.subclass == collectionView.tag.description
        }
        
        return (goodsSubclass.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "womanCollectionViewCell", for: indexPath) as! WomanCollectionviewCell
        
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
                DispatchQueue.main.async { cell.womancollectionviewImageview.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        cell.womancollectionViewLabel.text = goodsSubclass[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionIndex = IndexPath(row: indexPath.row, section: collectionView.tag)
        print(collectionIndex.description)
        let goodDetail = goods.filter({ (good) -> Bool in
            good.subclass == collectionIndex.section.description
        })[collectionIndex.row]
        performSegue(withIdentifier: "womanSegue", sender: goodDetail)
    }

}
