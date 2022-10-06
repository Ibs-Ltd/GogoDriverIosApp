//
//  FoodDetailData.swift
//  User
//
//  Created by MAC on 23/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper

class FoodDetailData: BaseData{
    var product: ProductData!
    var recommended: [ProductData] = []
    var similar: [ProductData] = []
    
    override func mapping(map: Map) {
        product <- map["product"]
        recommended <- map["recommended"]
        similar <- map["similar"]
        
    }
    
}
