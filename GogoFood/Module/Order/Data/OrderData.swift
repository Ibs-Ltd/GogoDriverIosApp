/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import ObjectMapper

enum OrderStatus: String {
    case pending = "pending"
    case cancel = "cancelled"
    case accept = "accepted"
    case dispatched = "dispatched"
    case completed = "completed"
    
    case pickedUp = "picked_up"
    case delivered = "delivered"
    case driverAssigned = "driver_assigned"
    case arrivedToRes = "arrived_to_restaurant"
    case started = "started"
    case arrived = "arrived"
    case none
}


class OrdersData: BaseData {
    #if Driver
    var newOrder: [OrderData] = []
    var order: [OrderInfoData] = []
    var historyOrder: [OrderData] = []
    #else
    var order: [OrderData] = []
    #endif
    
    
    override func mapping(map: Map) {
        #if Driver
        newOrder <- map["new_orders"]
        order <- map["orders"]
        historyOrder <- map["orders"]
        #else
        order <- map["order"]
        #endif
        
    }
    
}
class CreditData: BaseData {
    var credit: [CreditInfo] = []
   
    
    override func mapping(map: Map) {
        credit <- map["credits"]
    }
}
class CreditInfo: BaseData {
    var driver_id:Int?
    var amount: Double?
    var credited_by: String?
    var order: [OrderData] = []
    var created_at:String?
    var crediter:String?
    var type:String?
    override func mapping(map: Map) {
        driver_id <- map["driver_id"]
        type <- map["type"]
        crediter <- map["crediter"]
        order <- map["order"]
        credited_by <- map["credited_by"]
        amount <- map["amount"]
        driver_id <- map["driver_id"]
        created_at <- map["created_at"]
    }
    
}



class SuccessMessageRootModel: BaseData {
    
    var message : String?
    var success : Bool?
    
    override func mapping(map: Map) {
        message <- map["message"]
        success <- map["success"]
    }
}

class  OrderDetailData: BaseData {
    var order: OrderData!
    var orderInfo: OrderData!
    var orderInfoData: OrderInfoData!
    override func mapping(map: Map) {
        order <- map["details"]
        orderInfo <- map["order"]
        orderInfoData <- map["order"]
    }
}

class OrderData : BaseData {
    var user_id : ProfileData?
    var driver_id : DriverProfileData?
    #if Driver
    var restaurant_id: RestaurantProfileData?
    #else
    var restaurant_id : Int?
    #endif
    var order_id : OrderInfoData?
    var createdOrderID:String?
    var cart_id : [CartItemData]?
    var restaurant_wise : [OrderData]?
    var distance : Double?
    var delivery_charges : Double?
    var delivery_charges_tax : Int?
    private var status : String?
    
    var totalItems : Int?
    var orderTotal : Double?
    var delivery_address : DeliveryAddres?
    
    // For order Hisoty
    var restaurantWise : [RestaurantWise]?
    var totalAmount : Double?
    var OID : Int?
    var coupon_code:String?
    var coupon_discount:Double?
    var coupon_type:String?
    
    var tax_percent:Double?
    var  tax_applicable:String?
    var driver_earning:String?
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        distance <- map["distance"]

        driver_earning <- map["driver_earning"]
        tax_percent <- map["tax_percent"]
        tax_applicable <- map["tax_applicable"]        
        user_id <- map["user_id"]
        driver_id <- map["driver_id"]
        restaurant_id <- map["restaurant_id"]
        order_id <- map["order_id"]
        cart_id <- map["cart_id"]
        restaurant_wise <- map["restaurant_wise"]
        distance <- map["distance"]
        delivery_charges <- map["delivery_charges"]
        delivery_charges_tax <- map["delivery_charges_tax"]
        status <- map["status"]
        
        totalItems <- map["total_items"]
        orderTotal <- map["order_total"]
        delivery_address <- map["delivery_address"]
        
        coupon_code <- map["coupon_code"]
        coupon_discount <- map["coupon_discount"]
        coupon_type <- map["coupon_type"]

        
        
        
        restaurantWise <- map["restaurant_wise"]
        totalAmount <- map["total_amount"]
        OID <- map["_id"]
    }
    
    func getOrderTotal() -> String {
        let valueObj = String(format: "%.2f", self.orderTotal ?? 0)
        return "$" + (valueObj)
    }
    
    func updateStatus(newStatus : String){
        self.status = newStatus
    }
    
    func getOrderStatus() -> OrderStatus {
        return OrderStatus.init(rawValue: self.status ?? "") ?? .none
    }
    
    func getOrderStatusAsString() -> String {
        return " \(self.status ?? "") ".capitalized
    }
    
    func getColorForStatus() -> UIColor {
        switch OrderStatus.init(rawValue: self.status ?? "") ?? .none {
        case .cancel:
            return AppConstant.primaryColor
        case .pending:
            return AppConstant.appYellowColor
        case .accept:
            return AppConstant.appBlueColor
        case .driverAssigned:
            return AppConstant.appBlueColor
        default:
            break
        }
        
        return UIColor.clear
    }
    
    
    func getAutoCheckInTime() -> Int {
        let currentDate = Date()
        let now = TimeDateUtils.getDateinDateFormat(fromDate: self.getCreatedTime()).addingTimeInterval(1 * 60)
        let diffDateComponents = Calendar.current.dateComponents([.second], from: currentDate, to: now)
        if  let second = diffDateComponents.second{
            let timeRemaining = second
            return timeRemaining
        }
        return 0
    }
}

class  DeliveryAddres: BaseData {
    
    var v : Int?
    var did : Int?
    var address : String?
    var commune : String?
    var createdAt : String?
    var district : String?
    var isDefault : Int?
    var latitude : Double?
    var longitude : Double?
    var province : String?
    var updatedAt : String?
    var userId : Int?
    var village : String?
    
    override func mapping(map: Map) {
        v <- map["__v"]
        did <- map["_id"]
        address <- map["address"]
        commune <- map["commune"]
        createdAt <- map["created_at"]
        district <- map["district"]
        isDefault <- map["is_default"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        province <- map["province"]
        updatedAt <- map["updated_at"]
        userId <- map["user_id"]
        village <- map["village"]
    }
}


class  RestaurantWise: BaseData {
    
    var v : Int?
    var Rid : Int?
    var cartId : [CartItemData]?
    var restaurantId : RestaurantProfileData?
    var createdAt : String?
    var deliveryCharges : Int?
    var deliveryChargesTax : Float?
    var deliveryType : String?
    var distance : Float?
    var driverId : AnyObject?
    var orderId : Int?
    var status : String?
    var updatedAt : String?
    var userId : Int?
    
    
    
    var tax_applicable:String?
    var tax_percent:Double?
    
    override func mapping(map: Map) {
        v <- map["__v"]
        tax_applicable <- map["tax_applicable"]
        tax_percent <- map["tax_percent"]
        Rid <- map["_id"]
        cartId <- map["cart_id"]
        restaurantId <- map["restaurant_id"]
        createdAt <- map["created_at"]
        deliveryCharges <- map["delivery_charges"]
        deliveryChargesTax <- map["delivery_charges_tax"]
        deliveryType <- map["delivery_type"]
        distance <- map["distance"]
        driverId <- map["driver_id"]
        orderId <- map["order_id"]
        status <- map["status"]
        updatedAt <- map["updated_at"]
        userId <- map["user_id"]
    }
}
