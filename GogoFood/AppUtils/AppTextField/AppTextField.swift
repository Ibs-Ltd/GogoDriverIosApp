//
//  AppTextField.swift
//  GogoFood
//
//  Created by MAC on 20/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
enum AppTextFieldType{
    case smallTimeSelection
    case largeTimeSelection
    case dropDown
    case withoutImage
    case qwertyKeyBoardType // to show keyboard
    case phoneKeyboard//
    case numPad
    case decimalPad
}


class AppTextField: BaseAppView, UITextFieldDelegate {
    @IBOutlet weak private var lable: UILabel!
    @IBOutlet weak private var textField: UITextField!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var rightButton: UIImageView!
    
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    
    private var type: AppTextFieldType!
    private let watchImage = UIImage(named: "timeButton")
    private let dropDownImage = UIImage(named: "dropDown")
    var isValueSet = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup("AppTextField")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    func initiateView(type: AppTextFieldType, infoText: String?, placeHolder: String?) {
        self.lable.text = infoText
        self.textField.placeholder = placeHolder
        self.type = type
        setTextfiledView(type)
        
    }
    private func performBoth() {
        self.endEditing(true)
        voidCallBack()
    }
    
    func setText(_ text: String){
        self.textField.text = text
        self.isValueSet = true
    }
    
    func getText() -> String {
        return self.textField.text!
    }
    

    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
       
        switch type! {
     
        case .dropDown:
            editingEnd()
        break
        case .smallTimeSelection, .largeTimeSelection:
            performBoth()
        break
        case .withoutImage:
            voidCallBack()
            break
        case .qwertyKeyBoardType, .phoneKeyboard, .numPad, .decimalPad:
            voidCallBack()
        
        }
        
    }
    
    private func editingEnd() {
    
        voidCallBack()
       
    }
    
    
    
    
    private func setTextfiledView(_ forType: AppTextFieldType) {
        self.type = forType
        switch forType {
        
        case .smallTimeSelection:
            self.textFieldHeight.constant = 30
            self.outerView.cornerRadius = 15
            self.layoutIfNeeded()
            break
        case .largeTimeSelection:
            self.textFieldHeight.constant = 50
            self.outerView.cornerRadius = 8
            break
            
        case .dropDown:
            self.rightButton.image = dropDownImage
            break
        case .withoutImage:
            self.rightButton.isHidden = true
            break
        case .qwertyKeyBoardType:
            self.rightButton.isHidden = true
            break
            
        case .phoneKeyboard:
            textField.keyboardType = .phonePad
            self.rightButton.isHidden = true
        case .numPad:
            textField.keyboardType = .numberPad
            self.rightButton.isHidden = true
   
        case .decimalPad:
            textField.keyboardType = .decimalPad
            self.rightButton.isHidden = true
        }
        
        
    }
 
    func getTextFieldValue() -> String? {
        return self.textField.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       textField.resignFirstResponder()
    }

}
