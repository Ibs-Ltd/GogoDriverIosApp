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
        products <- map["products"]
    }
    
}

class RecommendedMenuData: BaseData{
    var productsRec: [ProductData] = []
    
    override func mapping(map: Map) {
        productsRec <- map["dishes"]
    }
    
}

class ProductDataForFavorites: BaseData{
    var favoritesDic : ProductData?
    
    override func mapping(map: Map) {
        favoritesDic <- map["dish_id"]
    }
    
}

class ProductData : BaseData {
    var name : String?
    #if Restaurant
    var category_id : CategoryData!
    var options : [Int]?
    var productOption: [OptionData]?
    #else
    var category_id : Int?
    var options : [OptionData]?
    #endif
    var price : Double?
    var is_recomend : String?
    var is_commentable : String?
    var restaurant_id : RestaurantProfileData?
    
    var description : String?
    var discount_type : String?
    var discount_percentage : Double?
    var coupon_code : String?
    var image : String? = "https://gogo-food.s3.ap-southeast-1.amazonaws.com/1587550577357-ice.jpg"
    var sold_qty : Int?
    var created_by : String?
    var status : String?
    private var toppings : String?
    var totalLikes : Int!
    var totalComments : Int!
    var totalShare : Int!
    var isFavourites : String!
    var isLike : String!
    var avgRating : Double!
    var user_rated : String!
    
    
    var dish_images : [String]?
    // for ui prespective
    var isActive = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        dish_images <- map["dish_images"]
        category_id <- map["category_id"]
        price <- map["price"]
        is_recomend <- map["is_recomend"]
        is_commentable <- map["is_commentable"]
        restaurant_id <- map["restaurant_id"]
        options <- map["options"]
        #if Restaurant // because some api developer are really ill
        productOption <- map["options"]
        #endif
        description <- map["description"]
        discount_type <- map["discount_type"]
        discount_percentage <- map["discount_percentage"]
        coupon_code <- map["coupon_code"]
        image <- map["image"]
        sold_qty <- map["sold_qty"]
        created_by <- map["created_by"]
        status <- map["status"]
        toppings <- map["toppings"]
        totalLikes <- map["total_likes"]
        totalComments <- map["total_comments"]
        totalShare <- map["total_shares"]
        isFavourites <- map["is_favourite"]
        isLike <- map["like"]
        avgRating <- map["total_rating"]
        user_rated <- map["user_rated"]
        
        isActive = (status ?? "" == "Active")
    }
    
    func getCookingTime() -> String {
        if let r = restaurant_id {
            return r.getCookingTime()
        }
        return ""
    }
    
    func getDeliveryTime() -> String {
        if let r = restaurant_id {
            return r.getDeliveryTime()
        }
        return ""
        
    }
    
    
    func getFinalAmount(stikeColor: UIColor, normalColor: UIColor, fontSize: CGFloat, inSameLine: Bool) -> NSAttributedString {
        let attributeString = NSMutableAttributedString()
        let normalAttributes:  [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: normalColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)]
        if self.discount_type == "percentage" || self.discount_type == "amount" || self.discount_type == "percent"{
            attributeString.append(NSAttributedString(string: "$" + getFinalPriceAfterAddUpValue().description))
            let strikethroughAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.strikethroughStyle: 1,
                NSAttributedString.Key.strikethroughColor: stikeColor,
                NSAttributedString.Key.foregroundColor: stikeColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            attributeString.addAttributes(strikethroughAttributes, range: NSMakeRange(0, attributeString.length))
            attributeString.append(NSAttributedString(string: inSameLine ? " " : "\n"))
            attributeString.append(NSAttributedString(string:  "$" + getFinalPriceAfterDiscount().description, attributes: normalAttributes))
        }else{
            attributeString.append(NSAttributedString(string: "$" + getFinalPriceAfterAddUpValue().description, attributes: normalAttributes))
        }
        return attributeString
    }
 
    func getFinalPriceAfterAddUpValue() -> Double {
        let realValue = (self.price ?? 0.0)
        let addUpValue = (self.price ?? 0.0) * Double(self.restaurant_id?.add_up_value ?? 0) / 100.0
        return realValue + addUpValue
    }
    
    func getFinalPriceAfterDiscount() -> Double {
        
        if self.discount_type == "percentage" || self.discount_type == "percent"{
            let option1 = self.getFinalPriceAfterAddUpValue()
            let option2 = ((self.getFinalPriceAfterAddUpValue()) * Double(self.discount_percentage ?? 0)) / 100.0
            return option1 - option2
        }else if self.discount_type == "amount"{
            return (self.getFinalPriceAfterAddUpValue()) - Double(self.discount_percentage ?? 0)
        }
        return self.price ?? 0.0
        
    }
    
}


class ProductPostData: ProductData {
    
    
    var productImage: UIImage!
    var catedoryId = ""
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
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
