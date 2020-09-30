//
//  CartViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/18.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore






class CartlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartlist:[Cart] = []

    //計算總杯數及總金額
    var pricelist:[Int] = []
    var countlist:[Int] = []
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    //訂單編號
    var total = 0
    var message:String?
    
    
    
    @IBOutlet weak var datapicker: UIDatePicker!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var totalcount: UILabel!
    @IBOutlet weak var totalprice: UILabel!
    @IBOutlet weak var cartemptyimg: UIImageView!
    @IBOutlet weak var carttableview: UITableView!
    @IBOutlet weak var sendbutton: UIButton!
    
    //送出訂單時 複製一份購物車資料並同時刪除購物車的tableview及firebase資料
    @IBAction func sendorder(_ sender: UIButton) {
        let price = totalprice.text
        let count = totalcount.text
           if timelabel.text! == "請選擇外送時間" {
                let alert = UIAlertController(title: "忘記選擇您的外送時間囉！", message: "趕快回去確實選擇並再此送出訂單唷！", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            } else {
                var documentId:[String] = []
                var namelist:[String] = []
                var pricelist:[Int] = []
                var countlist:[Int] = []
                var callist:[String] = []
                var sugarlist:[String] = []
                var detaillist:[String] = []
                var temperaturelist:[String] = []
                
            let alert = UIAlertController(title: "確認您的訂單了嗎？", message: "確認後記得用Line將訂單傳送給我們唷！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
        
                if let user = self.user {
                    if let email = user.email{

                        //訂單編號 每成功送出訂單就＋1
                        self.total += 1
                        if self.total < 10 {
                            self.db.collection("Ordertotal-\(email)").document("List-0\(self.total)").setData(
                                ["datetime":self.timelabel.text ?? "",
                                 "totalcount":self.totalcount.text ?? "",
                                 "totalprice":self.totalprice.text ?? "",
                                 "datenow": self.getDateString(Date())
                                ])
                        } else {
                            self.db.collection("Ordertotal-\(email)").document("List-\(self.total)").setData(
                                ["datetime":self.timelabel.text ?? "",
                                 "totalcount":self.totalcount.text ?? "",
                                 "totalprice":self.totalprice.text ?? "",
                                 "datenow": self.getDateString(Date())
                                ])
                        }
                        self.db.collection("Cart-\(email)").getDocuments { (querySnapshot, error) in
                           if let querySnapshot = querySnapshot {
                               //將每個document及documentData 分別放進陣列 再存進另一個collection
                                for document in querySnapshot.documents {
                                    print(document.documentID)
                                    documentId.append(document.documentID)
                                    namelist.append(document.data()["drinkname"] as? String ?? "")
                                    pricelist.append(Int(document.data()["drinkprice"] as? String ?? "") ?? 0)
                                    countlist.append(Int(document.data()["drinkcount"] as? String ?? "") ?? 0)
                                    callist.append(document.data()["drinkcal"] as? String ?? "")
                                    sugarlist.append(document.data()["drinksugar"] as? String ?? "")
                                    temperaturelist.append(document.data()["drinktemperature"] as? String ?? "")
                                    if document.data()["drinkdetail"] as? String ?? "" == ""{
                                        detaillist.append("無")
                                    } else {
                                        detaillist.append(document.data()["drinkdetail"] as? String ?? "")
                                    }
                                   //傳送訂單至Line
                                   self.db.collection("Milkshop").document(email).getDocument { (document, error) in
                                       if let document = document, document.exists {
                                           var str = ""
                                           for i in 0..<documentId.count {
                                               self.message = "飲料名稱：\(namelist[i])\n飲料甜度：\(sugarlist[i])\n飲料冰塊：\(temperaturelist[i])\n飲料杯數：\(countlist[i]) 杯\n飲料備註：\(detaillist[i])\n-------------------------\n"
                                               str += self.message!
                                           }
                                           let detail = "此單總杯數：  \(count ?? "")  杯\n此單總金額：\(price ?? "") NT$\n-------------------------\n姓名：\(document.data()?["Name"] as? String ?? "")\n電話：\(document.data()?["Phone"] as? String ?? "")\n地址：\(document.data()?["Address"] as? String ?? "")\n外送時間：\(self.timelabel.text ?? "")"
                                           let encodeMessage = detail.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                           let ordermessag = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                           //傳送訊息給指定用戶
                                           let lineURL = URL(string: "line://oaMessage/@337tvbck/\(ordermessag!)" + encodeMessage!) // 分享訊息的 URL Scheme
                                           if UIApplication.shared.canOpenURL(lineURL!) {
                                               UIApplication.shared.open(lineURL!, options: [:], completionHandler: nil)
                                           } else {
                                           // 若沒安裝 Line 則導到 App Store(id443904275 為 Line App 的 ID)
                                               let lineURL = URL(string: "itms-apps://itunes.apple.com/app/id443904275")!
                                               UIApplication.shared.open(lineURL, options: [:], completionHandler: nil)
                                           }
                                       }else{
                                           print("Document does not exist")
                                       }
                                   }
                                    //每一筆的document 對照 每一筆的data資料
                                    var i = 0
                                        for idx in documentId {
                                            i += 1
                                            for index in 0..<namelist.count {
                                                if index < i && self.total < 10 {
                                                    self.db.collection("OrderList-0\(self.total)-\(email)").document(idx).setData(["drinkname":namelist[index],
                                                     "drinkprice":pricelist[index],
                                                     "drinkcal":callist[index],
                                                     "drinkcount":countlist[index],
                                                     "drinksugar":sugarlist[index],
                                                     "drinktemperature":temperaturelist[index],
                                                     "drinkdetail":detaillist[index]
                                                    ])
                                                }else if index < i {
                                                    self.db.collection("OrderList-\(self.total)-\(email)").document(idx).setData(["drinkname":namelist[index],
                                                     "drinkprice":pricelist[index],
                                                     "drinkcal":callist[index],
                                                     "drinkcount":countlist[index],
                                                     "drinksugar":sugarlist[index],
                                                     "drinktemperature":temperaturelist[index],
                                                     "drinkdetail":detaillist[index]
                                                    ])
                                                }
                                            }
                                        }
                                    //把目前訂單個數再存回firebase
                                    self.db.collection("Milkshop").document("total-\(email)").setData(["total":self.total])
                                    //將每個document抓出來一一刪除
                                    for idx in documentId {
                                        self.db.collection("Cart-\(email)").document(idx).delete() { err in
                                            if let err = err {
                                                print("Error removing document: \(err)")
                                            } else {
                                                print("Document successfully removed!")
                                            }
                                        }
                                    }

                                    self.totalcount.text = "0"
                                    self.totalprice.text = "0"
                                    self.cartlist.removeAll()
                                    self.pricelist.removeAll()
                                    self.countlist.removeAll()
                                    self.tabbarbadge()
                                    self.cartempty()
                                    self.datapicker.isEnabled = false
                                    self.sendbutton.isEnabled = false
                                    self.sendbutton.backgroundColor = UIColor.lightGray
                                    self.carttableview.reloadData()
                                }
                            }
                        }
                    }
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            }
        }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartcell", for: indexPath) as! CartTableViewCell
        let cart = cartlist[indexPath.row]
        cell.cartname.text = cart.namelist
        cell.cartimg.image = UIImage(named: cart.namelist)
        cell.cartprice.text = String(cart.pricelist)
        cell.cartcount.text = String(cart.countlist)
        cell.cartsugar.text = cart.sugarlist
        cell.carttemperature.text = cart.temperaturelist
        if cart.detaillist == "" {
            cell.cartdetail.text = "無"
        } else {
            cell.cartdetail.text = cart.detaillist
        }
        return cell
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //刪除同時也把firebase及陣列資料刪除
        if editingStyle == .delete {
            if let user = user {
                if let email = user.email{
                    let cart = cartlist[indexPath.row]
                    let id = cart.documentId
                    db.collection("Cart-\(email)").document("\(id)").delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            }
            pricelist.remove(at: indexPath.row)
            countlist.remove(at: indexPath.row)
            cartlist.remove(at: indexPath.row)
            calculateTotalcount()
            calculateTotalprice()
            tabbarbadge()
            carttableview.reloadData()
            if  cartlist == [] {
                totalcount.text = "0"
                totalprice.text = "0"
                cartemptyimg.isHidden = false
                datapicker.isEnabled = false
                self.sendbutton.isEnabled = false
                sendbutton.backgroundColor = UIColor.lightGray
                
                
                
                
                
                
            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editcart", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let dvc = segue.destination as? MenuDetailTableViewController {
            if segue.identifier == "editcart" {
                let selectedIndexPath =  self.carttableview.indexPathForSelectedRow//自己所點到的選項
                //將所點選的項目id傳值過去
                //idx為判斷是為修改頁面
                if let selectedRow = selectedIndexPath?.row {
                    let cart = cartlist[selectedRow]
                    dvc.idx = 1
                    dvc.id = cart.documentId
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        carttableview.delegate = self
        carttableview.dataSource = self
        //外送時間至少現在時間的三十分鐘以上
        datapicker.minimumDate = Date(timeInterval: 1800, since: Date())
        timelabel.text = "請選擇外送時間"
        findTotal()
        elementenable()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        readData()
    }
    
    

    func elementenable() {
        //購物車為空時不給送出訂單及選擇日期
        if  cartlist.count == 0 {
            datapicker.isEnabled = false
            sendbutton.isEnabled = false
            sendbutton.backgroundColor = UIColor.lightGray
        } else {
            datapicker.isEnabled = true
            sendbutton.isEnabled = true
            sendbutton.backgroundColor = UIColor(red: 196.0/255.0, green: 148.0/255.0, blue: 77.0/255.0, alpha: 1)
        }
    }
    
    //訂單總數
    func findTotal() {
        if let user = user {
            if let email = user.email{
                db.collection("Milkshop").document("total-\(email)").getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.total = document.data()?["total"] as! Int
                        print(document.data()?["total"] as? Int ?? 0)
                    }else{
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    @IBAction func timechoose(_ sender: UIDatePicker) {
        let choosetime = getDateMax(sender.date)
        let offworktime = 22
        let onworktime = 9
        print(choosetime)
        if offworktime > Int(choosetime)! && Int(choosetime)! > onworktime {
            timelabel.text = getDateString(sender.date)
            sendbutton.isEnabled = true
            sendbutton.backgroundColor = UIColor(red: 196.0/255.0, green: 148.0/255.0, blue: 77.0/255.0, alpha: 1)
        } else {
            sendbutton.isEnabled = false
            sendbutton.backgroundColor = UIColor.lightGray
            let alert = UIAlertController(title: "非外送時間唷!!!", message: "外送時間為10:00 ~ 21:30", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func getDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd  aa  hh : mm"
        return formatter.string(from: date)
    }
    
    //在營業時間內才給選擇外送時間
   func getDateMax(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }
    

    
    func readData() {
        if let user = user {
            if let email = user.email{
                cartlist = []
                pricelist = []
                countlist = []
                db.collection("Cart-\(email)").getDocuments  { (querySnapshot, error) in
                   if let querySnapshot = querySnapshot {
                        for document in querySnapshot.documents {
                            self.cartlist.append(Cart.init(documentId: document.documentID, namelist: document.data()["drinkname"] as? String ?? "", pricelist: Int(document.data()["drinkprice"] as? String ?? "") ?? 0, countlist: Int(document.data()["drinkcount"] as? String ?? "") ?? 0, callist: document.data()["drinkcal"] as? String ?? "", sugarlist: document.data()["drinksugar"] as? String ?? "", detaillist: document.data()["drinkdetail"] as? String ?? "", temperaturelist: document.data()["drinktemperature"] as? String ?? ""))
                            self.pricelist.append(Int(document.data()["drinkprice"] as? String ?? "") ?? 0)
                            self.countlist.append(Int(document.data()["drinkcount"] as? String ?? "") ?? 0)
                        }
                   } else {
                      print("Document does not exist")
                   }
                    self.calculateTotalcount()
                    self.calculateTotalprice()
                    self.tabbarbadge()
                    self.cartempty()
                    self.elementenable()
                    self.carttableview.reloadData()
                }
            }
        }
    }
    
    //計算總杯數
       func calculateTotalcount() {
           var total = 0
           for index in countlist {
               total += index
               totalcount.text = String(total)
               
           }
       }
    
    //計算總金額
    func calculateTotalprice() {
        var total = 0
        for index in pricelist {
            total += index
            totalprice.text = String(total)
        }
    }
    
    //購物車圖示上的小圖示
    func tabbarbadge() {
        if cartlist.count == 0 {
            tabBarController?.tabBar.items?[2].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[2].badgeValue = "\(cartlist.count)"
        }
    }
    
    func cartempty() {
        if cartlist.count == 0 {
            cartemptyimg.isHidden = false
        } else {
            cartemptyimg.isHidden = true
        }
    }
}
