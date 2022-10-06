//
//  FoodDetailTableViewCell.swift
//  User
//
//  Created by YOGESH BANSAL on 13/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class FoodDetailTableViewCell: BaseTableViewCell<ProductData> {
    
    @IBOutlet weak var soldLabel: UILabel!
    
    @IBOutlet weak private var quantitySetter: AppStepper!
    @IBOutlet weak var stepper: AppStepper!
    
    @IBOutlet weak private var restaurantImage: UIImageView!
   
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak private var proctName: UILabel!
    @IBOutlet weak private var cookingTime: UIButton!
    @IBOutlet weak private var deliveryTime: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var orders: UILabel!
    @IBOutlet weak var soldView: UIView!
    
    
    var restaurantProfile: RestaurantProfileData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        #if User
        quantitySetter.onModifyItem = { count in
            print(count)
        }
        #endif
    }
    
    override func initView(withData: ProductData) {
        super.initView(withData: withData)
        if let r = restaurantProfile {
         ServerImageFetcher.i.loadProfileImageIn(restaurantImage, url: r.profile_picture ?? "")
            cookingTime.setTitle(r.getCookingTime(), for: .normal)
            deliveryTime.setTitle(r.getDeliveryTime(), for: .normal)
        }
        
        self.proctName.text = withData.name
        ServerImageFetcher.i.loadImageIn(self.productImage, url: withData.image ?? "")
        self.price.attributedText = withData.getFinalAmount(stikeColor: AppConstant.appBlueColor, normalColor: UIColor.white, fontSize: 13, inSameLine: false)
        self.orders.text = "\(withData.sold_qty ?? 0)"
        #if User
        self.stepper.dish = withData
        #endif
        self.soldView.isHidden = (withData.sold_qty ?? 0 == 0)
        
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
