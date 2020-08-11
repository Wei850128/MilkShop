//
//  MemberShipViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/12.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication

class MemberShipViewController: UIViewController, UITextFieldDelegate {
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    @IBOutlet weak var emailtext: UILabel!
    @IBOutlet weak var nameinput: UITextField!
    @IBOutlet var editingView: UIView!
    @IBOutlet weak var addressinput: UITextField!
    @IBOutlet weak var phoneinput: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var quickSwitch: UISwitch!
    
    //登出
    @IBAction func logoutbutton(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "goToLogin", sender: self)
        }catch{
            print("Error")
        }
    }
    
    @IBAction func savedatabuttom(_ sender: UIButton) {
        let db = Firestore.firestore()
        //修改資料
        if let name = nameinput.text, let phone = phoneinput.text , let adderss = addressinput.text{
            if name == "" || phone == "" || adderss == "" {
                let alert = UIAlertController(title: "欄位不得為空白", message: "請確實輸入資料作修改", preferredStyle: .alert)
                let ok1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok1)
                self.present(alert, animated: true, completion: nil)
            }else{
                db.collection("Milkshop").document(emailtext.text!).setData(["Name":name,"Phone":phone,"Address":adderss])
                let alert = UIAlertController(title: "儲存", message: "儲存資料成功", preferredStyle: .alert)
                let ok1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok1)
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        setupSubview()
//        canUseQuickLogin()
    }
    
   
   
    
    override func viewDidAppear(_ animated: Bool) {
         //當註冊成功 抓取當前的email(doucument.id與email同名)
        if let user = user {
            if let email = user.email{
                emailtext.text = email
                //抓取document裡的各個data
                db.collection("Milkshop").document(email).getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.nameinput.text = document.data()?["Name"] as? String
                        self.phoneinput.text = document.data()?["Phone"] as? String
                        self.addressinput.text = document.data()?["Address"] as? String
                        self.loading.stopAnimating()
                    }else{
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
//    func canUseQuickLogin() {
//        let context = LAContext()
//        var error: NSError?
//        let isAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
//        
//        quickSwitch.isEnabled = isAvailable
//        
//        if isAvailable {
//            if let owner = UserDefaults.standard.value(forKey: UserTokenOwner) as? String {
//                quickSwitch.isOn = owner == user?.email ?? "" ? true : false
//            }
//        } else {
//            quickSwitch.isEnabled = false
//        }
//    }
//    
//    @IBAction func quickLogin(_ sender: UISwitch) {
//        if sender.isOn {
//            let context = LAContext()
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "啟用快速登入") { (success, error) in
//                if success {
//                    if let user = self.user {
//                        if let email = user.email {
//                            let token = "abc"
//                            self.db.collection("Milkshop").document(email).setData([
//                                "token": token
//                            ],merge: true)
//                            UserDefaults.standard.set(token, forKey: UserToken)
//                            UserDefaults.standard.set(user.email ?? "", forKey: UserTokenOwner)
//                            UserDefaults.standard.synchronize()
//                        }
//                    }
//                } else {
//                    sender.isOn = false
//                }
//            }
//        } else {
//            UserDefaults.standard.removeObject(forKey: UserTokenOwner)
//            UserDefaults.standard.removeObject(forKey: UserToken)
//        }
//    }
    
    func setupSubview() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        loading.hidesWhenStopped = true
        loading.startAnimating()
        loading.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        
        guard let nameimg = UIImage(named: "person")else{return}
        guard let phoneimg = UIImage(named: "phone")else{return}
        guard let addressimg = UIImage(named: "address")else{return}
        addIcon(to: nameinput, withimage: nameimg)
        addIcon(to: phoneinput, withimage: phoneimg)
        addIcon(to: addressinput, withimage: addressimg)
    }

}

        
