/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

class MenuData: BaseData{
    var products: [ProductData] = []
    
    override func mapping(map: Map) {
        products <- map["product"]
    }
    
}

class ProductData : BaseData {
	var name : String?
	var category: CategoryData?
    var price : Double?
	var is_recomend : String?
	var restaurant_id : Int?
	var options : [Int]?
	var description : String?
	var discount_type : String? = "percentage"
	var discount_percentage : Int?
	var coupon_code : String?
	var image : String?
	var status : String?
	var created_at : String?
	var updated_at : String?
	
	var __v : Int?
    
    // for ui prespective
    var isActive = false
    
    
   
    

	override func mapping(map: Map) {
super.mapping(map: map)
		name <- map["name"]
		category <- map["category_id"]
		price <- map["price"]
		is_recomend <- map["is_recomend"]
		restaurant_id <- map["restaurant_id"]
		options <- map["options"]
		description <- map["description"]
		discount_type <- map["discount_type"]
		discount_percentage <- map["discount_percentage"]
		coupon_code <- map["coupon_code"]
		image <- map["image"]
		status <- map["status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		
		__v <- map["__v"]
        isActive = (status ?? "" == "Active")
        created_at = TimeDateUtils.getDateOnly(fromDate: created_at!)
        
        
	}

}


class ProductPostData: ProductData {
    
    
     var productImage: UIImage!
    var catedoryId = ""
   
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        catedoryId = (self.category ?? CategoryData()).id.description
       name <- map["name"]
        catedoryId <- map["category"]
        price <- map["price"]
        is_recomend <- map["is_recomend"]
        description <- map["description"]
        discount_type <- map["discount_type"]
        discount_percentage <- map["discount_percentage"]
        coupon_code <- map["coupon_code"]
       
        
    }
    
}
