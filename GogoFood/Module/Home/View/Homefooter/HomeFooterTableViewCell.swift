//
//  HomeFooterTableViewCell.swift
//  GogoFood
//
//  Created by MAC on 17/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class HomeFooterTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var button: UIButton!
    
    var tapOnButton: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTap(_ sender: UIButton) {
        tapOnButton()
    }
}
