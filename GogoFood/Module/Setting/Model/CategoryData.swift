//
//  CategoryData.swift
//  Restaurant
//
//  Created by Crinoid Mac Mini on 26/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper
class CategoriesData: BaseData {
    var categories: [CategoryData] = []

    override func mapping(map: Map) {
        categories <- map["category"]
    }
    
    
}



 class CategoryData: BaseData {
    var cat_name : String?
    var description : String?
    var image : String?
    var status : String?
    var restaurant_id : RestaurantProfileData?
  private var edit_by : String?

    
    
    
    // for UIPrespective
    
    var canUserEdit = false
    var isSelected = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cat_name <- map["cat_name"]
        description <- map["description"]
        image <- map["image"]
        status <- map["status"]
        restaurant_id <- map["restaurant_id"]
        edit_by <- map["edit_by"]
        
        
        
        canUserEdit = !(self.edit_by == "admin")
       
        
    }

    
    
}
