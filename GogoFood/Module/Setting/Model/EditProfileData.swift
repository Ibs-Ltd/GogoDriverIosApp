//
//  EditProfileData.swift
//  GogoFood
//
//  Created by MAC on 09/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper
class EditProfileData: BaseData {
    #if User
    var profile: ProfileData!
    #elseif Restaurant
    var profile: RestaurantProfileData!
    #elseif Driver
    var profile: DriverProfileData!
    
    #endif
    
    override func mapping(map: Map) {
        #if User
        profile <- map["user"]
        #elseif Restaurant
        profile <- map["restaurant"]
        #elseif Driver
        profile <- map["driver"]
        #endif
    }
    
    
}
