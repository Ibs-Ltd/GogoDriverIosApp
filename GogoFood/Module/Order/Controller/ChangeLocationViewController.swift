//
//  ChangeLocationViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 15/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class ChangeLocationViewController: BaseViewController<BaseData> {
    var onChangeLocation: (()-> Void)!
    var userAddress: String!
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }
    
    @IBAction func onTapChangeLocation() {
        onChangeLocation()
    }
    
    @IBAction func onCancel() {
       
    }

    
    @IBAction func onTake() {
        
    }
    

}
