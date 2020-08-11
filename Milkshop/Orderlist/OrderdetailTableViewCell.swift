//
//  OrderdetailTableViewCell.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/26.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit

class OrderdetailTableViewCell: UITableViewCell {

    @IBOutlet weak var orderdetailimg: UIImageView!
    @IBOutlet weak var orderdetailcount: UILabel!
    @IBOutlet weak var orderdetailprice: UILabel!
    @IBOutlet weak var orderdetail: UILabel!
    @IBOutlet weak var orderdetailtemperature: UILabel!
    @IBOutlet weak var orderdetailsugar: UILabel!
    @IBOutlet weak var orderdetailname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
