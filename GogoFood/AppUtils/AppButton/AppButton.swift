//
//  AppButton.swift
//  GogoFood
//
//  Created by MAC on 20/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

enum ButtonType{
    case red
    case yellow
    case blue
    
    
    
}

class AppButton: BaseAppView {
    @IBOutlet weak private var button: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup("AppButton")
        
    }
    
    
    func initButton(type: ButtonType, text: String?, image: UIImage?){
        button.setTitle(text, for: .normal)
        button.backgroundColor = AppConstant.appYellowColor
        switch type {
        case .red:
            self.button.backgroundColor = AppConstant.primaryColor
        case .yellow:
            self.button.backgroundColor = UIColor.blue
            //self.button.backgroundColor = AppConstant.appYellowColor
            break
         case .blue:
            self.button.backgroundColor = AppConstant.appBlueColor
            break
       
        }
        button.layoutIfNeeded()
        
        
    }
    
    
    @IBAction private func onTap(_ sender: UIButton) {
        voidCallBack()
    }
    
    
}
