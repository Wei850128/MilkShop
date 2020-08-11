//
//  OrderdetailViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/26.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OrderdetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var orderdetail:[Orderdetail] = []
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    //判斷第幾筆訂單
    var id:String?
    var documentid:[String] = []
    
    
    @IBOutlet weak var ordertotalprice: UILabel!
    @IBOutlet weak var ordertotalcount: UILabel!
    @IBOutlet weak var orderdetailtableview: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func reorder(_ sender: UIButton) {
        let alert = UIAlertController(title: "確定重新下單後\n將會把訂單送到購物車唷！", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if let user = self.user {
                if let email = user.email {
                    //重新下單送至購物車且相同飲品內容時購物車疊加
                    for i in 0..<self.orderdetail.count {
                        var index = "-1"
                        for idx in self.documentid {
                            if idx == "\(self.orderdetail[i].namelist),\(self.orderdetail[i].sugarlist),\(self.orderdetail[i].temperaturelist),\(self.orderdetail[i].detaillist)"  {
                                    index = idx
                                    break
                                }
                            }
                        if index != "-1" {
                            self.db.collection("Cart-\(email)").document(index).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let pricetotal = self.orderdetail[i].pricelist + Int(document.data()?["drinkprice"] as! String)!
                                    let counttotal  = self.orderdetail[i].countlist + Int(document.data()?["drinkcount"] as! String)!
                                    self.db.collection("Cart-\(email)").document(index).setData(["drinkprice":String(pricetotal),
                                                  "drinkcount":String(counttotal),
                                    ],merge: true)
                                }
                            }
                        } else {
                            self.db.collection("Cart-\(email)").document("\(self.orderdetail[i].namelist),\(self.orderdetail[i].sugarlist),\(self.orderdetail[i].temperaturelist),\(self.orderdetail[i].detaillist)").setData( ["drinkname":self.orderdetail[i].namelist,
                                 "drinkprice":String(self.orderdetail[i].pricelist),
                                 "drinkcount":String(self.orderdetail[i].countlist),
                                 "drinkcal":self.orderdetail[i].callist,
                                 "drinkdetail":self.orderdetail[i].detaillist,
                                 "drinksugar":self.orderdetail[i].sugarlist,
                                 "drinktemperature":self.orderdetail[i].temperaturelist])
                        }
                    }
                }
            }
            let orderalert = UIAlertController(title: "成功加入購物車", message: nil, preferredStyle: .alert)
            let orderok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //跳轉到購物車頁面
                self.tabBarController?.selectedIndex = 2
                
            })
            orderalert.addAction(orderok)
            self.present(orderalert, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderdetailtableview.delegate = self
        orderdetailtableview.dataSource = self
        loading.hidesWhenStopped = true
        loading.startAnimating()
        loading.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        readData()
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        if let user = user {
            if let email = user.email{
                documentid = []
                db.collection("Cart-\(email)").getDocuments { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        for document in querySnapshot.documents {
                            self.documentid.append(document.documentID)
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderdetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderdetailcell = tableView.dequeueReusableCell(withIdentifier: "orderdetailcell", for: indexPath) as! OrderdetailTableViewCell
        let order = orderdetail[indexPath.row]
        orderdetailcell.orderdetailimg.image = UIImage(named: order.namelist)
        orderdetailcell.orderdetailname.text = order.namelist
        orderdetailcell.orderdetailcount.text = String(order.countlist)
        orderdetailcell.orderdetailprice.text = String(order.pricelist)
        orderdetailcell.orderdetailsugar.text = order.sugarlist
        orderdetailcell.orderdetailtemperature.text = order.temperaturelist
        orderdetailcell.orderdetail.text = order.detaillist == "" ? "無" : order.detaillist
        return orderdetailcell
    }
    
    func readData() {
        if let user = user {
            if let email = user.email {
                    db.collection("Ordertotal-\(email)").document(id ?? "").getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.title = " 外送時間 ～ \(document.data()?["datetime"] as? String ?? "") "
                            self.ordertotalprice.text = document.data()?["totalprice"] as? String ?? ""
                            self.ordertotalcount.text = document.data()?["totalcount"] as? String ?? ""
                        }
                    }
                    db.collection("Order\(id ?? "")-\(email)").getDocuments { (querySnapshot, error) in
                       if let querySnapshot = querySnapshot {
                          for document in querySnapshot.documents {
                            print(document.data())
                            self.orderdetail.append(Orderdetail.init(namelist: document.data()["drinkname"] as? String ?? "", pricelist: document.data()["drinkprice"] as? Int ?? 0, countlist: document.data()["drinkcount"] as? Int ?? 0, callist: document.data()["drinkcal"] as? String ?? "", sugarlist: document.data()["drinksugar"] as? String ?? "", detaillist: document.data()["drinkdetail"] as? String ?? "", temperaturelist: document.data()["drinktemperature"] as? String ?? ""))
                        }
                        self.orderdetailtableview.reloadData()
                        self.loading.stopAnimating()
                    }
                }
            }
        }
    }
}


