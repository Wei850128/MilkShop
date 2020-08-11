//
//  FuctionData.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/28.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit

extension UIViewController {
    //在textfield 加上icon圖片
    func addIcon(to tf:UITextField,withimage img:UIImage){
           let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
           leftImageView.image = img
           tf.leftView = leftImageView
           tf.leftViewMode = .always
       }
       //按空白處收起鍵盤
    func addTapGesture(){
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard(){
            self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


