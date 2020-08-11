//
//  LoginViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/12.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
   
    
    @IBAction func loginbutton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailtext.text!, password: passwordtext.text!) { (user, error) in
                 if error != nil {
                     print(error!)
                     let alert = UIAlertController(title: "登入失敗", message: error?.localizedDescription, preferredStyle: .alert)
                     let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alert.addAction(ok)
                     self.present(alert, animated: true, completion: nil)
                 }
                 else{
                     print("Log in Successful")
                     self.performSegue(withIdentifier: "loginToMain", sender: self)
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        addTapGesture()
        setupSubview()
        //判斷之前是否有登入過有的話直接登入
        if Auth.auth().currentUser != nil {
             self.performSegue(withIdentifier: "loginToMain", sender: self)
        }

        
//        if UserDefaults.standard.object(forKey: UserTokenOwner) != nil {
//            let context = LAContext()
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "啟用快速登入") { (success, error) in
//                if success {
//                    if let token = UserDefaults.standard.object(forKey: UserToken) as? String {
//                        self.db.collection("Milkshop").whereField("token", isEqualTo: token).getDocuments() { (querySnapshot, err) in
//                            for document in querySnapshot?.documents ?? [] {
//
//                            }
//                        }
//                    } else {
//
//                    }
//                }
//            }
//        }
    }
    
    func setupSubview() {
        guard let mailimg = UIImage(named: "mail")else{return}
        guard let passwordimg = UIImage(named: "password")else{return}
        addIcon(to: emailtext, withimage: mailimg)
        addIcon(to: passwordtext, withimage: passwordimg)
    }
}
