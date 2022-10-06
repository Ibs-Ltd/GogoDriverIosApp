//
//  CurrentSession.swift
//  Stay Bet
//
//  Created by PropApp on 08/02/17.
//  Copyright © 2017 Stay Bet. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class CurrentSession {
    //    let Authorization = ""
    //    let KEY_LOCAL_DATA = "local"
    //
    //
    private static var i : CurrentSession!
    //
    //
    //    let dobFormatter = DateFormatter()
    //    var sessionId = "$2y$10$pt7cH/DseV9o5Nw/m3t8c.OWJ1Td2yoNFE1SwOlYOlE5ZCOiZTp3G"
    //
    //    var profile : ProfileData!
    //
    //    var loginData = LoginResponseData()
    var localData = LocalData()
    //
    //    var token = ""
    //    var mobile = ""
    //
    static func getI() -> CurrentSession {
        
        if i == nil {
            i = CurrentSession()
        }
        
        return i
    }
    //
    init() {
        //
        //        if let data = UserDefaults.standard.object(forKey: KEY_PROFILE) as? Data {
        //            let unarc = NSKeyedUnarchiver(forReadingWith: data)
        //            profile = unarc.decodeObject(forKey: "root") as! ProfileData
        //        }
        //
        
        if let data = UserDefaults.standard.string(forKey: "localData"){
            localData = LocalData(JSONString: data) ?? LocalData()
        }
        
        //
        //
        //
        //
        //
        //
        //        dobFormatter.dateFormat = "yyyy-MM-dd"
        
    }
    //
    func saveData() {
        let ud = UserDefaults.standard
        ud.set(localData.toJSONString() ?? "", forKey: "localData")
        
    }
    
    func onLogout() {
        self.localData = LocalData()
        saveData()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "inital")
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
    
    
    func getAppType() -> App {
        if Bundle.main.bundleIdentifier == "com.gogo.driver" {
            return App.driver
        }
        if Bundle.main.bundleIdentifier == "com.gogo.userApp" {
            return App.user
        }
        return App.restaurant
    }
}


enum App {
    case user
    case driver
    case restaurant
}


class LocalData: BaseData {
    
    #if Restaurant
    var profile: RestaurantProfileData!
    #elseif User
    var profile: ProfileData!
    var cart: CartData = CartData()
    #elseif Driver
    var profile: DriverProfileData!
    #endif
    #if DEBUG
  
    var token: String! = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOnsibG9jYXRpb24iOnsidHlwZSI6IlBvaW50IiwiY29vcmRpbmF0ZXMiOlswLDBdfSwibmFtZSI6bnVsbCwibW9iaWxlIjoiODM0NzY1ODM0NyIsIm1vYmlsZV8yIjpudWxsLCJlbWFpbCI6bnVsbCwidXBsaW5lX2NvZGUiOm51bGwsInJlZmVyYWxfY29kZSI6bnVsbCwib3RwIjpudWxsLCJwcm9maWxlX3BpY3R1cmUiOm51bGwsImlkX2NhcmRfZnJvbnQiOm51bGwsImlkX2NhcmRfYmFjayI6bnVsbCwidmVoaWNsZV9pZF9mcm9udCI6bnVsbCwidmVoaWNsZV9pZF9iYWNrIjpudWxsLCJsaWNlbnNlX2Zyb250IjpudWxsLCJsaWNlbnNlX2JhY2siOm51bGwsImRldmljZV90b2tlbiI6InNhZGFzZGFqZGdhaHNmZHlxd3RldXF5dzhmN3l2czg3dHV5d2dkOHM3YWM5OHdnZDk4d2V1N2Q5MCIsImF2Z19yYXRpbmciOjAsIndhbGxldF9iYWxhbmNlIjowLCJsb25naXR1ZGUiOjAsImxhdGl0dWRlIjowLCJhZGRyZXNzIjpudWxsLCJjb3VudHJ5IjpudWxsLCJjaXR5IjpudWxsLCJkaXN0cmljdCI6bnVsbCwiY29tbXVuZSI6bnVsbCwidmlsbGFnZSI6bnVsbCwidmVoaWNsZV9jb2xvciI6bnVsbCwidmVoaWNsZV95ZWFyIjpudWxsLCJwbGF0ZV9ubyI6bnVsbCwidmVoaWNsZV9tb2RlbCI6bnVsbCwiYmxvY2tfcmVhc29uIjpudWxsLCJkZWZhdWx0X2xhbmd1YWdlIjoiZW4iLCJpc19zcGVjaWFsIjoibm8iLCJpbmNlbnRpdmVfcGVyY2VudGFnZSI6MCwidGFyZ2V0IjowLCJjdXJyZW50X29yZGVyc19jb3VudCI6MCwiZHJpdmVyX3N0YXR1cyI6InZlcmlmaWVkIiwic3RhdHVzIjoicGVuZGluZyIsInJpZGVfc3RhdHVzIjoib2ZmbGluZSIsIl9pZCI6MjIsImNyZWF0ZWRfYXQiOiIyMDIwLTA0LTAzVDE0OjQzOjQ2LjE4M1oiLCJ1cGRhdGVkX2F0IjoiMjAyMC0wNC0wM1QxNDo0Mzo0Ni4xODNaIiwiX192IjowfSwiaWF0IjoxNTg1OTkyNzI4LCJleHAiOjE2MTc1Mjg3Mjh9.UOpjpFCKhIUQz-hQNyxwKyKF-TiFLJ589c3luWprQEU"
    #else
    var token: String!
    #endif
    var fireBaseToken: String!
    override func mapping(map: Map) {
        #if Restaurant
        profile <- map["restaurant"]
        #elseif User
        profile <- map["user"]
        cart <- map["cart"]
         #elseif Driver
        profile <- map["driver"]
        #endif
        token <- map["token"]
    }
}
