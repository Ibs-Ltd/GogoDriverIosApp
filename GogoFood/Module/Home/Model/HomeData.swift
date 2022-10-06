//
//  HomeData.swift
//  GogoFood
//
//  Created by MAC on 01/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeData: BaseData {
    var topResaturant: [RestaurantProfileData] = []
    var banners: [BannerData] = []
    var categories: [CategoryData] = []
    var topOrder: [ProductData] = []
    var recommended: [ProductData] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        topResaturant <- map["top_restaurants"]
        banners <- map["banners"]
        categories <- map["categories"]
        topOrder <- map["top_ordered"]
        recommended <- map["recommended"]
        
    }
    
    
    
}


