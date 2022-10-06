/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import ObjectMapper

class FoodOptionData: BaseData {
    var options: [OptionData] = []
    override func mapping(map: Map) {
        options <- map["options"]
    }
    
    
}



class OptionData : BaseData {
    var addonName : String?
    var addonType : String?
    var toppings : [Toppings]?
    
    // for UIprespective
    var isSelected = false
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        addonName <- map["addon_name"]
        addonType <- map["addon_type"]
        toppings <- map["toppings"]
        
        
    }
    
}

class Toppings : BaseData {
    var topping_name : String?
    var price : Double?
    var status : String?
    var addonId : AddonId?
    
    // for functionality related
    var isSelected = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        topping_name <- map["topping_name"]
        price <- map["price"]
        status <- map["status"]
        addonId <- map["addon_id"]
    }
    
}

class AddonId : BaseData {
    var addonName : String?
    // for functionality related
    var isSelected = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        addonName <- map["addon_name"]
    }
    
}
