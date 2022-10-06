//
//  SupportCenterViewController.swift
//  User
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class SupportCenterViewController: BaseViewController<BaseData> {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var setViewForRestaurant = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewOutlet.dropShadow(scale: true)
        self.createNavigationLeftButton(NavigationTitleString.supportCenter.localized())
        
        if setViewForRestaurant {
            image.image = UIImage(named: setViewForRestaurant
                ? "supportCenter"
                : "supportCenter")
            
        }
        infoLabel.isHidden = !setViewForRestaurant
    }
    
    
    @IBAction func onClose(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
