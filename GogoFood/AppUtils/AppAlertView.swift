//
//  AppAlertView.swift
//  GogoFood
//
//  Created by MAC on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class AppAlertView: UIView {

    @IBOutlet var view: UIView!
    
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup("AppAlertView")
    
    }
    
    static func initView() {
        
        
        let window = UIApplication.shared.keyWindow!
       // let center = view.c
        
        let v = UIView(frame: window.bounds)
        window.addSubview(v);
        v.backgroundColor = UIColor.clear
        let v2 = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        v2.backgroundColor = UIColor.white
        
        //window.addSubview(view)
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
