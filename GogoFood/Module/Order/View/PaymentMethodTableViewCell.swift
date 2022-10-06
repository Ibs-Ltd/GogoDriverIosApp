//
//  PaymentMethodTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 04/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: BaseTableViewCell<CartData> {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var COD: UIButton!
    @IBOutlet weak var wallet: UIButton!

    var tapOnPaymentButton: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func initView(withData: CartData) {
        self.amountLabel.text = withData.getCartTotal()
    }
    
    @IBAction func palaceOrder(_ sender: UIButton) {
        tapOnPaymentButton()
    }
    
}
