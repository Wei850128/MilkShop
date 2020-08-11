//
//  MenuControllerTableViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/8.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit


class MenuControllerTableViewController: UITableViewController {
    
    //使用plist儲存飲品項目並取得 plist檔的URL
    let url = Bundle.main.url(forResource: "Drinks", withExtension: "plist")!
    
    var menuArray:[DrinkData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    func initData() {
        //將Data變成型別[Drink]的array
        if let data = try? Data(contentsOf: url), let drinks = try? PropertyListDecoder().decode([DrinkData].self, from: data) {
              menuArray = drinks
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    //總共要顯示幾列資訊
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuArray.count
    }

    //將cell的ID命名為 cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuDetailTableViewCell
            let celldata = menuArray[indexPath.row]
            cell.imglabel.image = UIImage(named: celldata.image)
            cell.namelabel.text = celldata.name
            cell.callabel.text = celldata.cal
            cell.pricelabel.text = String(celldata.price)
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)//轉場
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "飲品項目"
//    }
    
    
    
//  傳值到MenuDetailTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? MenuDetailTableViewController {
            if segue.identifier == "showDetail" {
                let selectedIndexPath =  self.tableView.indexPathForSelectedRow//自己所點到的選項
                if let selectedRow = selectedIndexPath?.row{
                    dvc.infoFromViewone = menuArray[selectedRow]
                    // 將選到位置的menuArray陣列資料存入
                    dvc.idx = 0
                }
            }
        }
    }
}
