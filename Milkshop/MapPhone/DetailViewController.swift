//
//  DetailViewController.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/9.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var count:Int = 1
    var infoFromViewOne:String?
    var infoFromViewPrice:String?

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var mylabel: UILabel!
    @IBOutlet weak var myPrice: UILabel!
    @IBOutlet weak var myCount: UILabel!
    
    //點選加減時 mycount作增加遞減顯示
    @IBAction func weaponStepper(_ sender: UIStepper) {
            count = Int(sender.value)
            myCount.text = "\(count)"
            //calculate()
        //更改badge
        if "\(count)" == "1" {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        }else {
             tabBarController?.tabBar.items?[1].badgeValue = "\(count)"
        }
    }
    
    //當Stepper按加減時 金額跟著做變動
    func calculate() {
        if let price = Int(infoFromViewPrice!){
            let total = count * price
            myPrice.text = "\(total)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mylabel.text = infoFromViewOne
        myPrice.text = infoFromViewPrice
        if let okFileName = infoFromViewOne{
            myImageView.image = UIImage(named: okFileName)
        }
        addTapGesture()
        // Do any additional setup after loading the view.
    }
    
    
    func addTapGesture(){
             let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
             view.addGestureRecognizer(tap)
         }
     @objc private func hideKeyboard(){
             self.view.endEditing(true)
         }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
