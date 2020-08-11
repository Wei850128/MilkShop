//
//  OrderlistViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/24.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OrderlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var ordertableview: UITableView!
    var orderlist:[Order] = []
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    var total = 0
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ordercell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderTableViewCell
        let order = orderlist[indexPath.row]
        ordercell.datetime.text = order.datalist
        ordercell.ordercount.text = order.countlist
        ordercell.orderprice.text = order.pricelist
        
        return ordercell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "orderToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? OrderdetailViewController {
            if segue.identifier == "orderToDetail" {
                let selectedIndexPath = self.ordertableview.indexPathForSelectedRow//自己所點到的選項
                    //將所點選的項目id傳值過去
                if let selectedRow = selectedIndexPath?.row {
                    let order = orderlist[selectedRow]
                    dvc.id = order.documentId
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordertableview.delegate = self
        ordertableview.dataSource = self
        readData()
        loading.hidesWhenStopped = true
        loading.startAnimating()
        loading.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }
    
    
    func readData() {
        if let user = user {
            if let email = user.email{
                db.collection("Milkshop").document("total-\(email)").getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.total = document.data()?["total"] as! Int
                        print(document.data()?["total"] as? Int ?? 0)
                    }
                    self.db.collection("Ordertotal-\(email)").addSnapshotListener { (querySnapshot, error) in guard let querySnapshot = querySnapshot else {return}
                        querySnapshot.documentChanges.forEach({ (documentChange) in
                            if documentChange.type == .added {
                                //讓最新的訂單呈現於最上面因此取出後都插入第一位
                                self.orderlist.insert(Order.init(documentId: documentChange.document.documentID, datalist: documentChange.document.data()["datenow"] as? String ?? "", countlist: documentChange.document.data()["totalcount"] as? String ?? "", pricelist: documentChange.document.data()["totalprice"] as? String ?? ""), at: 0)
                            }
                            self.ordertableview.reloadData()
                            self.loading.stopAnimating()
                        })
                    }
                }
            }
        }
    }
}
