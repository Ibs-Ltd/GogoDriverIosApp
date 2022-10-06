/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import ObjectMapper

class DriverProfileData : ProfileData {
    var location : Location?
    var id_card_front : String?
    var id_card_back : String?
    var vehicle_id_front : String?
    var vehicle_id_back : String?
    var license_front : String?
    var license_back : String?
    var address : String?
    var country : String?
    var city : String?
    var district : String?
    var commune : String?
    var village : String?
    var vehicle_color : String?
    var vehicle_year : String?
    var plate_no : String?
    var vehicle_model : String?
    var block_reason : String?
    var is_special : String?
    var incentive_percentage : Int?
    var target : Int?
    var current_orders_count : Int?
    var ride_status : String?
    var _id : Int?
    var created_at : String?
 
    
   
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        location <- map["location"]
    
        id_card_front <- map["id_card_front"]
        id_card_back <- map["id_card_back"]
        vehicle_id_front <- map["vehicle_id_front"]
        vehicle_id_back <- map["vehicle_id_back"]
        license_front <- map["license_front"]
        license_back <- map["license_back"]
        address <- map["address"]
        country <- map["country"]
        city <- map["city"]
        district <- map["district"]
        commune <- map["commune"]
        village <- map["village"]
        vehicle_color <- map["vehicle_color"]
        vehicle_year <- map["vehicle_year"]
        plate_no <- map["plate_no"]
        vehicle_model <- map["vehicle_model"]
        block_reason <- map["block_reason"]
        is_special <- map["is_special"]
        incentive_percentage <- map["incentive_percentage"]
        target <- map["target"]
        current_orders_count <- map["current_orders_count"]
        user_status <- map["driver_status"]
        ride_status <- map["ride_status"]
        created_at <- map["created_at"]
    }
    
}

class Location : BaseData {
    var type : String?
    var coordinates : [Double]?
    
   
    
    override func mapping(map: Map) {
        
        type <- map["type"]
        coordinates <- map["coordinates"]
    }
    
}
