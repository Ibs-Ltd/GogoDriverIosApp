//
//  RecommendsCollectionViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 15/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class RecommendsCollectionViewCell: BaseCollectionViewCell<ProductData> {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cookingTime: UIButton!
    @IBOutlet weak var deliveryTime: UIButton!
    @IBOutlet weak var stepper: AppStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func initViewWith(_ data: ProductData) {
        super.initViewWith(data)
        ServerImageFetcher.i.loadImageIn(imageView, url: data.image ?? "")
        
        name.text = data.name
        price.attributedText = data.getFinalAmount(stikeColor: AppConstant.primaryColor,    normalColor: AppConstant.appBlueColor, fontSize: 12, inSameLine: false) 
        price.numberOfLines = 2
        cookingTime.setTitle(data.getCookingTime(), for: .normal)
        deliveryTime.setTitle(data.getDeliveryTime(), for: .normal)
        #if User
        stepper.dish = data
        #endif
       
    }
    

}
