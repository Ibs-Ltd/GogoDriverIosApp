//
//  BaseAppView.swift
//  GogoFood
//
//  Created by MAC on 20/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
@IBDesignable
class BaseAppView: UIView {
    
@IBOutlet var view: UIView!
    var voidCallBack: (()->Void)!
    func showError(_ withMessage: String?) {
        let alert  = UIAlertController(title: "Error", message: withMessage ?? "Unable to fetch data this time", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
    }
    
    

    
    
    func commonSetup(_ withName: String) {
        
        Bundle.main.loadNibNamed(withName, owner: self, options: nil)
        view.frame = bounds
        // the autoresizingMask will be converted to constraints, the frame will match the parent view frame
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding nibView on the top of our view
        addSubview(view)
    }
    
    
    
    
   
}
