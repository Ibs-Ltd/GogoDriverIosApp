//
//  File.swift
//  GogoFood
//
//  Created by MAC on 04/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper
class RestaurantsData: BaseData {
    var resturants: [RestaurantProfileData] = []
    
    override func mapping(map: Map) {
        resturants <- map["restaurants"]
    }
    
    
}
