//
//  MenuDetailTableViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/17.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class MenuDetailTableViewController: UITableViewController {
    
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var infoFromViewone:DrinkData?
    var count:Int = 1
    var modifycount:Int?
    var modifyprice:Int?
    var modifytotal:Int?
    var documentid:[String] = []
    var documentname = ""
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    //用idx判斷是新增還是修改訂單
    var idx:Int = -1
    //判斷修改第幾筆資料
    var id:String?
    
    @IBOutlet weak var stepperbutton: UIStepper!
    @IBOutlet weak var addcartbutton: UIButton!
    @IBOutlet weak var drinkimg: UIImageView!
    @IBOutlet weak var drinkname: UILabel!
    @IBOutlet weak var drinkcal: UILabel!
    @IBOutlet weak var drinkprice: UILabel!
    @IBOutlet weak var drinkcount: UILabel!
    @IBOutlet weak var drinksugar: UISegmentedControl!
    @IBOutlet weak var drinktemperature: UISegmentedControl!
    @IBOutlet weak var drinkdetail: UITextField!
    @IBOutlet var tableview: UITableView!
    
    @IBAction func cancelbutton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //將本頁的資料儲存到firebase
    @IBAction func addcart(_ sender: UIButton) {
        //訂單完成tabbar badge增加
       
        //新增
        if idx == 0 {
            if let user = user {
                if let email = user.email{
                    //解決相同品項內容 購物車疊加問題
                    if let drinkname = drinkname.text, let drinkcal = drinkcal.text, let drinkprice = drinkprice.text, let drinkcount =  drinkcount.text, let drinkdetail = drinkdetail.text,let drinksugar = drinksugar.titleForSegment(at: drinksugar.selectedSegmentIndex), let drinktemperature = drinktemperature.titleForSegment( at: drinktemperature.selectedSegmentIndex) {
                        if drinkdetail != "" {
                            documentname = "\(drinkname),\(drinksugar),\(drinktemperature),\(drinkdetail)"
                        } else {
                            documentname = "\(drinkname),\(drinksugar),\(drinktemperature),無"
                        }
                            var idx = "-1"
                            for i in self.documentid {
                                if i == documentname {
                                    idx = i
                                    break
                                }
                            }
                        if idx != "-1"  {
                            db.collection("Cart-\(email)").document(idx).getDocument {
                                (document, error) in
                                if let document = document, document.exists {
                                    print("same1")
                                    let pricetotal = Int(drinkprice)! + Int(document.data()?["drinkprice"] as! String)!
                                    let counttotal  = Int(drinkcount)! + Int(document.data()?["drinkcount"] as! String)!
                                    self.db.collection("Cart-\(email)").document(idx).setData(
                                        [
                                         "drinkprice":String(pricetotal),
                                         "drinkcount":String(counttotal),
                                        ],merge: true)
                                }
                            }
                    }else {
                            print("add")
                            if var badge = Int((tabBarController?.tabBar.items?[2].badgeValue) ?? "0"){
                                      badge += 1
                                      tabBarController?.tabBar.items?[2].badgeValue = "\(badge)"
                            }
                            if drinkdetail == "" {
                                db.collection("Cart-\(email)").document("\(drinkname),\(drinksugar),\(drinktemperature),無").setData(
                                    ["drinkname":drinkname,
                                    "drinkprice":drinkprice,
                                    "drinkcount":drinkcount,
                                    "drinkcal":drinkcal,
                                    "drinkdetail":drinkdetail,
                                    "drinksugar":drinksugar,
                                    "drinktemperature":drinktemperature
                                ])
                            } else {
                                db.collection("Cart-\(email)").document(documentname).setData(
                                    ["drinkname":drinkname,
                                    "drinkprice":drinkprice,
                                    "drinkcount":drinkcount,
                                    "drinkcal":drinkcal,
                                    "drinkdetail":drinkdetail,
                                    "drinksugar":drinksugar,
                                    "drinktemperature":drinktemperature
                                ])
                            }
                        }
                    }
                }
            }
                                           
            let alert = UIAlertController(title: "成功加入購物車", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                //回到上一頁
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        } else {
            //修改訂單把原資料刪除創一份新的
            if let user = user {
                if let email = user.email{
                    if let drinkname = drinkname.text, let drinkcal = drinkcal.text, let drinkprice = drinkprice.text, let drinkcount =  drinkcount.text, let drinkdetail = drinkdetail.text,let drinksugar = drinksugar.titleForSegment(at: drinksugar.selectedSegmentIndex), let drinktemperature = drinktemperature.titleForSegment( at: drinktemperature.selectedSegmentIndex) {
                        if drinkdetail != ""{
                            documentname = "\(drinkname),\(drinksugar),\(drinktemperature),\(drinkdetail)"
                        } else {
                            documentname = "\(drinkname),\(drinksugar),\(drinktemperature),無"
                        }
                        var idx = "-1"
                        for i in self.documentid {
                            if i == documentname {
                                idx = i
                                break
                            }
                        }
                        if documentname == id {
                            print("1")
                            if drinkdetail == "" {
                                db.collection("Cart-\(email)").document("\(drinkname),\(drinksugar),\(drinktemperature),無").setData([
                                "drinkprice":drinkprice,
                                "drinkcount":drinkcount,
                                "drinkdetail":drinkdetail
                                 ],merge: true)
                            } else {
                                db.collection("Cart-\(email)").document(documentname).setData([
                                "drinkprice":drinkprice,
                                "drinkcount":drinkcount,
                                "drinkdetail":drinkdetail
                                 ],merge: true)
                            }
                        } else {
                            if idx != "-1" {
                                print("2")
                                db.collection("Cart-\(email)").document(idx).getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let pricetotal = Int(drinkprice)! + Int(document.data()?["drinkprice"] as! String)!
                                        let counttotal  = Int(drinkcount)! + Int(document.data()?["drinkcount"] as! String)!
                                        self.db.collection("Cart-\(email)").document(idx).setData(
                                            ["drinkprice":String(pricetotal),
                                             "drinkcount":String(counttotal),
                                            ],merge: true)
                                    }
                                }
                            }else{
                                print("3")
                                if var badge = Int((tabBarController?.tabBar.items?[2].badgeValue) ?? "0"){
                                          badge += 1
                                          tabBarController?.tabBar.items?[2].badgeValue = "\(badge)"
                                }
                                if drinkdetail == "" {
                                    db.collection("Cart-\(email)").document("\(drinkname),\(drinksugar),\(drinktemperature),無").setData(["drinkname":drinkname,
                                         "drinkprice":drinkprice,
                                         "drinkcount":drinkcount,
                                         "drinkcal":drinkcal,
                                         "drinkdetail":drinkdetail,
                                         "drinksugar":drinksugar,
                                         "drinktemperature":drinktemperature
                                         ])
                                } else {
                                    db.collection("Cart-\(email)").document(documentname).setData(["drinkname":drinkname,
                                         "drinkprice":drinkprice,
                                         "drinkcount":drinkcount,
                                         "drinkcal":drinkcal,
                                         "drinkdetail":drinkdetail,
                                         "drinksugar":drinksugar,
                                         "drinktemperature":drinktemperature
                                        ])
                                }
                            }
                            db.collection("Cart-\(email)").document(id ?? "").delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }
                        }
                    }
                }
            }
            let alert = UIAlertController(title: "成功修改訂單", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (alction) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
   }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        setupSubview()
        if idx != 0 {
            loading.hidesWhenStopped = true
            loading.startAnimating()
            loading.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        } else {
            loading.isHidden = true
        }
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        //stepper的預設值為count(杯數)
        stepperbutton.value = Double(Int(drinkcount.text!)!)
        //計算修改訂單的杯數金額
        modifyprice = Int(drinkprice.text ?? "1")
        modifycount = Int(drinkcount.text ?? "1")
        modifytotal = (modifyprice ?? 0 )/( modifycount ?? 0)
        print("\(drinkcount.text ?? "1")")
        print("\(drinkprice.text ?? "1")")
        
    }
    
    func setupSubview() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        //判斷是新訂單還是修改訂單
        if idx == 0 {
            self.title = "新增訂單"
            if let celldata = infoFromViewone {
                drinkname.text = celldata.name
                drinkcal.text = celldata.cal
                drinkprice.text = String(celldata.price)
                drinkimg.image = UIImage(named: celldata.image)
            }
        }else {
            self.title = "修改訂單"
            addcartbutton.setTitle("確認修改", for: .normal)
            let user = Auth.auth().currentUser
            if let user = user {
                if let email = user.email{
                    let db = Firestore.firestore()
                    db.collection("Cart-\(email)").document(id ?? "").getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.drinkimg.image = UIImage(named: document.data()?["drinkname"] as! String)
                            self.drinkname.text = document.data()?["drinkname"] as? String
                            self.drinkcal.text = document.data()?["drinkcal"] as? String
                            self.drinkprice.text = document.data()?["drinkprice"] as? String
                            self.drinkcount.text = document.data()?["drinkcount"] as? String
                            if document.data()?["drinkdetail"] as? String == "無" {
                                self.drinkdetail.text = ""
                            } else {
                            self.drinkdetail.text = document.data()?["drinkdetail"] as? String
                            }
                            let drinksugaridx = document.data()?["drinksugar"] as? String
                            self.drinksugar.selectedSegmentIndex = Int(self.segmentidx(drinksugaridx!)) ?? 0
                            let drinktemperatureidx = document.data()?["drinktemperature"] as? String
                            self.drinktemperature.selectedSegmentIndex = Int(self.segmentidx(drinktemperatureidx!)) ?? 0
                            self.loading.stopAnimating()
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
    //修改時segment將正確的在原資料上
    func segmentidx(_ drinksugaridx:String) -> String {
        switch drinksugaridx {
            case "正常冰","正常糖":
                return  "0"
            case "少冰","少糖":
                return  "1"
            case "半糖","微冰":
                return  "2"
            case "微糖","熱飲":
                return  "3"
            default:
                return "default"
        }
    }


    @IBAction func stepper(_ sender: UIStepper) {
        if idx == 0 {
            count = Int(sender.value)
            drinkcount.text = String(count)
            calculate()
        } else {
            //修改資料時
            count = Int(sender.value)
            drinkcount.text = String(count)
            modifycalculate()
        }
    }
    
    func calculate() {
        if let price = infoFromViewone?.price {
            let total = count * price
            drinkprice.text = "\(total)"
        }
    }
    
    func modifycalculate() {
        if let price = modifytotal {
            let total =  count * price
            drinkprice.text = "\(total)"
        }
    }
    
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // 有六個tableview section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "modify" {
//            if let dvc = segue.destination as? CartViewController {
//                dvc.cartidx = idx
//            }
//        }
//    }
}
