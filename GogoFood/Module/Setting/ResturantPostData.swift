//
//  ResturantPostData.swift
//  GogoFood
//
//  Created by MAC on 25/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper

enum TimmingType: String {
    case all = "ALL"
    case single = "SINGLE"
    case none
}

class RestaurantTimmingData: BaseData {
    var type: TimmingType = .all
    var day: [TimeData] = []
    var cookingTime = 0
    var deliveryTime = 0
    var description = ""
    
    override func mapping(map: Map) {
        var item = type.rawValue
        item <- map["type"]
        day <- map["day"]
        cookingTime <- map["est_cooking_time"]
        deliveryTime <- map["est_delivery_time"]
        description <- map["description"]
        
        
    }
    
    
}

class TimeData: BaseData{
    var name = "Sunday"
    var startTime = ""
    var endTime = ""
  
    
    override func mapping(map: Map) {
        name <- map["name"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
      
    }
    
    init(name: String, startTime: String, endTime: String) {
        super.init()
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    
}

class RestaurantTime: BaseData {
    var restiming: [RestaurantProfileData] = []
    
    override func mapping(map: Map) {
        restiming <- map["restiming"]
    }
    
    
    
}

class RestaurantParticularDayTime: BaseData{
    var name = "Sunday"
    var startTime = ""
    var endTime = ""
    var type: TimmingType = .none
    
    override func mapping(map: Map) {
        name <- map["day"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        var t = ""
        t  <- map["type"]
        type = TimmingType(rawValue: t) ?? .none
    }
    
    
    
}

