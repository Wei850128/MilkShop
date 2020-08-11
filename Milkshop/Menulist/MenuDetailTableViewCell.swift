//
//  SpecialTableViewCell.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/15.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit

class MenuDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imglabel: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var callabel: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
