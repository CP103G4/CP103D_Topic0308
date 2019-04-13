//
//  FavoriteTVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/22.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTVC: UITableViewController {

    var favorites = [Favorite]()
    var context: NSManagedObjectContext!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadData()
        
        let request = NSFetchRequest<Favorite>(entityName: "Favorite")
        do {
            favorites = try context.fetch(request)
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /* 設定可否移動資料列 */
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /* 指定資料列從來源位置移動到目的位置 */
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let favorite = favorites[fromIndexPath.row]
        /* 必須先移除後新增資料，順序不可顛倒 */
        favorites.remove(at: fromIndexPath.row)
        favorites.insert(favorite, at: to.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.photoImageView?.image = UIImage(data: favorite.image!)
        cell.nameLabel.text = favorite.name
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(favorites[indexPath.row])
            do {
                if context.hasChanges {
                    try context.save()
                    favorites.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            let request = NSFetchRequest<Favorite>(entityName: "Favorite")
            do {
                favorites = try context.fetch(request)
            } catch let erroer {
                print(erroer.localizedDescription)
            }
        }
    }
    
//    func loadData(){
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let request = NSFetchRequest<Favorite>(entityName: "Favorite")
//        do {
//            let favorites = try context.fetch(request)
//            for favorite in favorites {
//                imageView.image = UIImage(data: favorite.image!)
//                nameLable.text = favorite.name
//            }
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
}
