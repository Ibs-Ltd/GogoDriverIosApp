//
//  NotificationTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 17/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class NotificationTableViewCell: BaseTableViewCell<BaseData> {

    @IBOutlet weak var downArrayBtn: UIButton!    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
