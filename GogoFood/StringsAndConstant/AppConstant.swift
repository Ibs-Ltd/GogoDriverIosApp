//
//  AppConstant.swift
//  GogoFood
//
//  Created by MAC on 16/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import UIKit
class AppConstant {
    static let primaryColor = UIColor(named: "primaryColor")!
    static let secondaryColor = UIColor(named: "secondaryColor")!
    static let backgroundColor = UIColor(named: "backgroundColor")!
    static let tertiaryColor = UIColor(named: "tertiaryColor")!
    static let appGrayColor = UIColor(named: "appGrayColor")!
    static let appYellowColor = UIColor(named: "yellowColor")!
    static let appBlueColor = UIColor(named: "blueColor")!
    static let appOffWhiteColor = UIColor(named: "offWhite")!
    // google key
    static let googleKey = "AIzaSyBPkGp1BdI12d3ojNAKA3bxIB2q_nT_jzI"
    
}

func oneButtonAlertControllerWithBlock(msgStr : String, naviObj : UIViewController, completion: @escaping (_ result: Bool)->()){
    let alert = UIAlertController(title: "Message", message: msgStr, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
        completion(true)
        
    }))
    naviObj.present(alert, animated: true, completion: nil)
}
