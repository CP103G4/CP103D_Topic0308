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
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func loadData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<Favorite>(entityName: "Favorite")
        do {
            let favorites = try context.fetch(request)
            for favorite in favorites {
                imageView.image = UIImage(data: favorite.image!)
                nameLable.text = favorite.name
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
