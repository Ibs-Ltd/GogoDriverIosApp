//
//  VerifyOTPData.swift
//  GogoFood
//
//  Created by MAC on 23/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper

class OTPData: BaseData {
  
    #if User
    var profile: ProfileData!
    var userStatus = ""
    #elseif Restaurant
    var profile: RestaurantProfileData!
    #elseif Driver
    var profile: DriverProfileData!
    var userStatus = ""
    #endif
    var token: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7InJlc3RhdXJhbnRfbmFtZSI6bnVsbCwibW9iaWxlIjoiNTQ1NDU2NDQ1NiIsIm1vYmlsZTEiOm51bGwsImVtYWlsIjpudWxsLCJvdHAiOm51bGwsImltYWdlIjpudWxsLCJkZXZpY2VfdG9rZW4iOm51bGwsImF2Z19yYXRpbmciOjAsImxvbmdpdHVkZSI6MCwibGF0aXR1ZGUiOjAsImFkZHJlc3MiOm51bGwsImNpdHkiOm51bGwsInN0YXRlIjpudWxsLCJtZW1iZXJfdHlwZSI6bnVsbCwiYmlsbGluZ19wbGFuX2lkIjpudWxsLCJlc3RfY29va2luZ190aW1lIjpudWxsLCJlc3RfZGVsaXZlcnlfdGltZSI6bnVsbCwiZGVzY3JpcHRpb24iOm51bGwsImRlZmF1bHRfbGFuZ3VhZ2UiOiJlbiIsInJlc3RhdXJhbnRfc3RhdHVzIjoiMCIsIl9pZCI6OSwiY3JlYXRlZF9hdCI6IjIwMjAtMDItMjNUMTQ6MzU6MTkuNzc2WiIsInVwZGF0ZWRfYXQiOiIyMDIwLTAyLTIzVDE0OjM1OjE5Ljc3NloiLCJfX3YiOjB9LCJpYXQiOjE1ODI3MzQ4NDIsImV4cCI6MTYxNDI3MDg0Mn0.wzR60IrCruxIdZrsvRxI0H9Oz86FjI17UffcBxsSW7s"
    
    override func mapping(map: Map) {
        token <- map["token"]
        #if User
        profile <- map["user"]
        userStatus <- map["user_status"]
        if let _ = profile {
            profile.user_status = userStatus
        }
        #elseif Restaurant
        profile <- map["restaurant"]
        
        
        #elseif Driver
        profile <- map["driver"]
        userStatus <- map["driver_status"]
        if let _ = profile {
            profile.user_status = userStatus
        }
        #endif
       
      
        
    }
}


