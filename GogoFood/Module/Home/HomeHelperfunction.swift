//
//  HomeHelperfunction.swift
//  User
//
//  Created by MAC on 24/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation

func showDetailOf(product: ProductData,  vc: UIViewController) {
    let sb = UIStoryboard(name: StoryBoard.home.rawValue, bundle: nil)
    let foodDetail = sb.instantiateViewController(withIdentifier: Controller.foodDetail.rawValue) as! FoodDetailViewController
    foodDetail.data = product
    foodDetail.hidesBottomBarWhenPushed = true
    vc.navigationController?.pushViewController(foodDetail, animated: true)
    
    
}
