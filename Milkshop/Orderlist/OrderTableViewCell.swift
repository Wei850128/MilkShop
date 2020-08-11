//
//  OrderTableViewCell.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/24.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var datetime: UILabel!
    @IBOutlet weak var ordercount: UILabel!
    @IBOutlet weak var orderprice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
