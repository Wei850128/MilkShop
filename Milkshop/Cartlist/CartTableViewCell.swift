//
//  CartTableViewCell.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/18.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartimg: UIImageView!
    @IBOutlet weak var cartname: UILabel!
    @IBOutlet weak var cartsugar: UILabel!
    @IBOutlet weak var carttemperature: UILabel!
    @IBOutlet weak var cartcount: UILabel!
    @IBOutlet weak var cartprice: UILabel!
    @IBOutlet weak var cartdetail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
