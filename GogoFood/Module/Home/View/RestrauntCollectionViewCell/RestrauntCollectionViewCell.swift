//
//  RestrauntCollectionViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class RestrauntCollectionViewCell: BaseCollectionViewCell<RestaurantProfileData> {

    @IBOutlet weak var orderLabelOutlet: UILabel!
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var numberOfOrder: UILabel!
    
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var mealType: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var numberOfSold: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()        
       
    }
    
    func initView(withData: RestaurantProfileData) {
        self.restaurantName.text = withData.name ?? ""
        self.time.text = withData.getCookingTime()
        
        ServerImageFetcher.i.loadImageIn(self.restaurantImageView, url: withData.profile_picture ?? "")
       numberOfSold.text = withData.getTotalSold()
        
        
    }
    
    

    
}
