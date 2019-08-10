//
//  LikedListTableViewController.swift
//  CardSwipeApp
//
//  Created by 中村泰輔 on 2019/08/10.
//  Copyright © 2019 icannot.t.n. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {
    
    // いいねされた名前一覧
    var likedName : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    // セクションの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likedName.count
    }

    //セクションに代入するもの
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = likedName[indexPath.row]

        return cell
    }
    

}
