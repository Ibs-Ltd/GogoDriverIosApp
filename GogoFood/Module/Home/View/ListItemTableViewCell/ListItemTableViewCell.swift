//
//  ListItemTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 22/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class ListItemTableViewCell: BaseTableViewCell<ProductData> {

    @IBOutlet weak var imageName: UIImageView!
     @IBOutlet weak var itemName: UILabel!
     @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var deliveryTime: UIButton!
    
    @IBOutlet weak var cookingTime: UIButton!
    @IBOutlet weak var appStepper: AppStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func initView(withData: ProductData) {
        super.initView(withData: withData)
        
        ServerImageFetcher.i.loadImageIn(imageName, url: withData.image ?? "")
        itemName.text = withData.name
        itemPrice.attributedText = withData.getFinalAmount(stikeColor: AppConstant.primaryColor,    normalColor: AppConstant.appBlueColor, fontSize: 12, inSameLine: true)
        deliveryTime.setTitle(withData.getDeliveryTime(), for: .normal)
        cookingTime.setTitle(withData.getCookingTime(), for: .normal)
        appStepper.dish = withData
        
        
    }
 

    
}
