//
//  FirstViewController.swift
//  Milkshop
//
//  Created by 劉瑄 on 2020/7/5.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKitimport FirebaseFirestore
import Network

class FirstViewController: UIViewController {

    var documentID:[String] = []
//    let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
    }
    
    func setupSubview() {
        let user = Auth.auth().currentUser
        if let user = user {
            let db = Firestore.firestore()
            if let email = user.email{
                db.collection("Cart-\(email)").getDocuments { (querySnapshot, error) in
                   if let querySnapshot = querySnapshot {
                      for document in querySnapshot.documents {
                        self.documentID.append(document.documentID)
                      }
                   }
                self.tabbarbadge()
                }
            }
        }
    }
    
    //畫面讀取時badge就載入購物車的數量
    func tabbarbadge() {
        if documentID.count == 0 {
            tabBarController?.tabBar.items?[2].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[2].badgeValue = "\(documentID.count)"
        }
    }
}
    
 
    

    
    



