//
//  ViewProductViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 15/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import SBCardPopup

class ViewProductViewController: BaseViewController<ProductData> {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectOptionViewController") as! SelectOptionViewController
        let cardPopup = SBCardPopupViewController(contentViewController: vc)
        cardPopup.show(onViewController: self)
    }
}
