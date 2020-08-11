//
//  RegisterViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/11.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore




class RegisterViewController: UIViewController {
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    @IBOutlet weak var confirmword: UITextField!
    @IBOutlet weak var nameinput: UITextField!
    @IBOutlet weak var phoneinput: UITextField!
    @IBOutlet weak var addressinput: UITextField!
    
    @IBAction func register(_ sender: UIButton) {
        if self.passwordtext.text! != self.confirmword.text! {
            let alert = UIAlertController(title: "驗證密碼錯誤", message: "請重新確認密碼", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else if self.nameinput.text! == "" || self.phoneinput.text! == "" || self.addressinput.text! == ""{
            let alert = UIAlertController(title: "欄位不得為空白", message: "請確實輸入資料", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: emailtext.text!, password: passwordtext.text!) { (user, error) in
                if error != nil {
                    print(error!)
                    let alert = UIAlertController(title: "註冊失敗", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }else{
                      //  success 成功註冊
                    print("Registration Successful!")
                    self.performSegue(withIdentifier: "signInToMain", sender: self)
                    //註冊時也存入firebase並且把doctmentId改成信箱名字
                    let db = Firestore.firestore()
                    if let email = self.emailtext.text, let name = self.nameinput.text, let phone = self.phoneinput.text, let address = self.addressinput.text {
                        db.collection("Milkshop").document(email).setData(["UserId":email,
                            "Name":name,
                            "Phone":phone,
                            "Address":address])
                        db.collection("Milkshop").document("total-\(email)").setData(["total":0])
                        let alert = UIAlertController(title: "註冊成功", message: nil, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                      }
                  }
              }
          }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        addTapGesture()
    }
    
    func setupSubview() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //增加icon圖示
        guard let emailimg = UIImage(named: "mail")else{return}
        guard let passwordimg = UIImage(named: "password")else{return}
        guard let checkpasswordimg = UIImage(named: "password")else{return}
        guard let nameimg = UIImage(named: "person")else{return}
        guard let phoneimg = UIImage(named: "phone")else{return}
        guard let addressimg = UIImage(named: "address")else{return}
        addIcon(to: emailtext, withimage: emailimg)
        addIcon(to: passwordtext, withimage: passwordimg)
        addIcon(to: confirmword, withimage: checkpasswordimg)
        addIcon(to: nameinput, withimage: nameimg)
        addIcon(to: phoneinput, withimage: phoneimg)
        addIcon(to: addressinput, withimage: addressimg)
    }
}
