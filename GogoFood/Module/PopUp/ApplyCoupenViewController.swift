//
//  ApplyCoupenViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 15/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import SBCardPopup

class ApplyCoupenViewController: BaseViewController<BaseData> {

    @IBOutlet weak var addBtnOutlet: UIButton!
    @IBOutlet weak var coupenCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coupenCodeTextField.layer.borderColor = #colorLiteral(red: 0.9280869961, green: 0.2265495062, blue: 0.1618448198, alpha: 1)
        coupenCodeTextField.layer.borderWidth = 1.0
        addBtnOutlet.layer.cornerRadius = 25
    }

    @IBAction func addBtnAction(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ChangeLocationViewController") as! ChangeLocationViewController
//        let cardPopup = SBCardPopupViewController(contentViewController: vc)
//        cardPopup.show(onViewController: self)
    }
}
