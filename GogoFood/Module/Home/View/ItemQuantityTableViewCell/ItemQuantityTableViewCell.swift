//
//  ItemQuantityTableViewCell.swift
//  User
//
//  Created by YOGESH BANSAL on 14/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class ItemQuantityTableViewCell: BaseTableViewCell<ProductData> {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //stepperOutlet.labelFont = UIFont (name: "HelveticaNeue-UltraLight", size: 10.0)!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
