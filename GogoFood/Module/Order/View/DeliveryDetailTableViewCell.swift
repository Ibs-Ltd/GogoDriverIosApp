//
//  DeliveryDetailTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 04/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class DeliveryDetailTableViewCell: BaseTableViewCell<BaseData> {

    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var arrowImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
