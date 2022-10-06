//
//  AppCheckButton.swift
//  GogoFood
//
//  Created by MAC on 20/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
enum RadioType{
    case square
    case round
    case redRound
}
class AppRadioButton: BaseAppView {
    
    private let roundCheck = UIImage(named: "check")
    private let roundUncheck = UIImage(named: "uncheck")
    private let squareCheck = UIImage(named: "checkSquare")
    private let squareUncheck = UIImage(named: "unCheckSquare")
    private let redRoundChek = UIImage(named: "checkRed")
    @IBOutlet weak private var button: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup("AppRadioButton")
    }
    
    
    func initView(type: RadioType, title: String?) {
        if type == .round{
            button.setImage(roundCheck, for: .selected)
            button.setImage(roundUncheck, for: .normal)
        }
        
        if type == .square {
            button.setImage(squareCheck, for: .selected)
            button.setImage(squareUncheck, for: .normal)
            
        }
        
        if type == .redRound {
            button.setImage(redRoundChek, for: .selected)
            button.setImage(roundUncheck, for: .normal)
            
        }
        
        
        button.setTitle(title, for: .normal)
        button.tintColor = UIColor.white
        
        
    }
    
    
    @IBAction func onTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        voidCallBack()
    }
    
    func setSelected(_ value: Bool) {
        self.button.isSelected = value
    }
    
    
}
