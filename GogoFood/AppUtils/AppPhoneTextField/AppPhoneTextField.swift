//
//  AppPhoneTextField.swift
//  GogoFood
//
//  Created by MAC on 24/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import FlagPhoneNumber

class AppPhoneTextField: AppTextField {
    
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var phoneNumber: FPNTextField!
    @IBOutlet weak private var correctImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup("AppPhoneTextField")
        setPhonePicker()
        phoneNumber.delegate = self
        phoneNumber.keyboardType = .phonePad
        phoneNumber.textColor = AppConstant.primaryColor
    }
    override func awakeFromNib() {
        setPhonePicker()
    }
    
    
    func setPhonePicker() {
       // phoneNumber.setFlag(source: NKVSource.init(phoneExtension: "+855"))
       // phoneNumber.setCode(source: NKVSource.init(phoneExtension: "+855"))
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.correctImage.isHidden = ((textField.text! + string).count == 9)
        return ((textField.text! + string).count < 10)
    }
    
    
}
