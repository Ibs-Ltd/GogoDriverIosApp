/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import ObjectMapper

class BannerData : BaseData {
    var name : String?
    var description : String?
    var image : String?
    var percentage : Int?
    var dish_id : ProductData?
    var start_date : String?
    var status : String?
    var end_date : String?
    var restaurant_id : RestaurantsData?
    var created_at : String?
    
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        description <- map["description"]
        image <- map["image"]
        percentage <- map["percentage"]
        dish_id <- map["dish_id"]
        start_date <- map["start_date"]
        status <- map["status"]
        end_date <- map["end_date"]
        restaurant_id <- map["restaurant_id"]
        
        
        
    }
    
}
