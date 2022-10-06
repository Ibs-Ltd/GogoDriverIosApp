//
//  FoodCollectionViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: BaseCollectionViewCell<ProductData> {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var soldItemView: UIView!
    @IBOutlet weak var cookingTime: UIButton!
    @IBOutlet weak var delevieryTime: UIButton!
    @IBOutlet weak var numberOfSold: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func initViewWith(_ data: ProductData) {
        super.initViewWith(data)
        ServerImageFetcher.i.loadImageIn(productImageView, url: data.image ?? "")
        //cookingTime.setTitle(data., for: .normal)
        numberOfSold.text = data.sold_qty?.description
        price.attributedText = data.getFinalAmount(stikeColor: AppConstant.appBlueColor, normalColor: UIColor.white, fontSize: 12, inSameLine: false)
        
        self.delevieryTime.setTitle(data.getDeliveryTime(), for: .normal)
        self.cookingTime.setTitle(data.getCookingTime(), for: .normal)
        self.soldItemView.isHidden = (data.sold_qty ?? 0) == 0
        
        
    }
    
    
}
