/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

class OrderInfoData : BaseData {
	
	var dish_price : Int?
	var topping_price : Int?
	var discount : Int?
	var coupon_code : String?
	var coupon_type : String?
	var coupon_valid_for : String?
	var coupon_discount : Int?
	var tax : Int?
	var delivery_charges : Int?
	var total_amount : Int?
	var order_total : Double?
	var delivery_address : DeliveryAddress?
	var delivery_charges_tax : Int?
	var driver_id : String?
	var payment_method : String?
	var payment_status : String?
	var balance : Int?
    #if Driver
    var user_id : ProfileData?
	var restaurant_wise : [OrderData]?
    #else
    var user_id : Int?
    var restaurant_wise : [Int]?
    #endif
	var status : String?
	var restaurant_id : [Int]?
	var coupon_restaurants : [String]?
	override func mapping(map: Map) {
        super.mapping(map: map)
		user_id <- map["user_id"]
		dish_price <- map["dish_price"]
		topping_price <- map["topping_price"]
		discount <- map["discount"]
		coupon_code <- map["coupon_code"]
		coupon_type <- map["coupon_type"]
		coupon_valid_for <- map["coupon_valid_for"]
		coupon_discount <- map["coupon_discount"]
		tax <- map["tax"]
		delivery_charges <- map["delivery_charges"]
		total_amount <- map["total_amount"]
		order_total <- map["order_total"]
		delivery_address <- map["delivery_address"]
		delivery_charges_tax <- map["delivery_charges_tax"]
		driver_id <- map["driver_id"]
		payment_method <- map["payment_method"]
		payment_status <- map["payment_status"]
		balance <- map["balance"]
		restaurant_wise <- map["restaurant_wise"]
		status <- map["status"]
		restaurant_id <- map["restaurant_id"]
		coupon_restaurants <- map["coupon_restaurants"]
	}
    
    
    func getOrderTotal() -> String {
        let valueObj = String(format: "%.2f", self.order_total ?? 0)
        return "$" + (valueObj)
    }
    
    func getDeliveryFee() -> String {
        return "$" + (self.delivery_charges ?? 0).description
    }
    
    func getPaymentMethodType() -> String {
        return self.payment_method ?? ""
    }
    
    func getTotalItemInOrder() -> String {
        return self.restaurant_wise?.compactMap({$0.cart_id?.count}).reduce(0, +).description ?? ""
    }

}

class DeliveryAddress: BaseData {
    
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

class InviteEarnListRootModel: BaseData {
    
    var inviteData : InviteData?
    var message : String?
    var success : Bool?
    
    override func mapping(map: Map) {
        inviteData <- map["data"]
        message <- map["message"]
        success <- map["success"]

    }
}

class InviteData: BaseData {
    
    var currentUser : CurrentUser?
    var levelList : [LevelList]?
    
    override func mapping(map: Map) {
        currentUser <- map["driver"]
        levelList <- map["history"]

    }
}

class CurrentUser: BaseData {
    
    var userDetail : UserDetail?
    var totalIncome : Double?
    var totalInvited : Int?
    
    override func mapping(map: Map) {
        
        userDetail <- map["details"]
        totalIncome <- map["total_income"]
        totalInvited <- map["total_invited"]
    }
}

class UserDetail: BaseData {
    
    var v : Int?
    var uid : Int?
    var avgRating : Int?
    var blockEndDate : AnyObject?
    var blockReason : AnyObject?
    var blockStartDate : AnyObject?
    var createdAt : String?
    var defaultAddress : Int?
    var defaultLanguage : String?
    var deviceToken : String?
    var deviceType : String?
    var email : AnyObject?
    var latitude : AnyObject?
    var longitude : AnyObject?
    var mobile : String?
    var name : String?
    var otp : AnyObject?
    var profilePicture : String?
    var referalCode : String?
    var referalIncome : Double?
    var registeredVia : AnyObject?
    var rewards : Double?
    var status : String?
    var updatedAt : String?
    var uplineCode : AnyObject?
    var uplineEarned : Int?
    var userStatus : String?
    var walletBalance : Double?
    
    override func mapping(map: Map) {
        
        v <- map["__v"]
        uid <- map["_id"]
        avgRating <- map["avg_rating"]
        blockEndDate <- map["block_end_date"]
        blockReason <- map["block_reason"]
        blockStartDate <- map["block_start_date"]
        createdAt <- map["created_at"]
        defaultAddress <- map["default_address"]
        defaultLanguage <- map["default_language"]
        deviceToken <- map["device_token"]
        deviceType <- map["device_type"]
        email <- map["email"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        mobile <- map["mobile"]
        name <- map["name"]
        otp <- map["otp"]
        profilePicture <- map["profile_picture"]
        referalCode <- map["referal_code"]
        referalIncome <- map["referal_income"]
        registeredVia <- map["registered_via"]
        rewards <- map["rewards"]
        status <- map["status"]
        updatedAt <- map["updated_at"]
        uplineCode <- map["upline_code"]
        uplineEarned <- map["upline_earned"]
        userStatus <- map["user_status"]
        walletBalance <- map["wallet_balance"]
    }
}

class LevelList: BaseData {
    
    var earned : Int?
    var invited : Int?
    var level : Int?
    
    override func mapping(map: Map) {
        
        earned <- map["earned"]
        invited <- map["invited"]
        level <- map["level"]
    }
}

class InviteListRootData: BaseData {
    
    var inviteListData : [InviteListData]?
    
    override func mapping(map: Map) {
        
        inviteListData <- map["users"]
    }
}

class InviteListData: BaseData {
    
    var v : Int?
    var uid : Int?
    var avgRating : Int?
    var blockEndDate : AnyObject?
    var blockReason : AnyObject?
    var blockStartDate : AnyObject?
    var createdAt : String?
    var defaultAddress : Int?
    var defaultLanguage : String?
    var deviceToken : String?
    var deviceType : String?
    var email : AnyObject?
    var latitude : AnyObject?
    var longitude : AnyObject?
    var mobile : String?
    var name : String?
    var otp : AnyObject?
    var profilePicture : String?
    var referalCode : String?
    var referalIncome : Int?
    var registeredVia : AnyObject?
    var rewards : Int?
    var status : String?
    var updatedAt : String?
    var uplineCode : String?
    var uplineEarned : Int?
    var userStatus : String?
    var walletBalance : Int?
    
    override func mapping(map: Map) {
        
        v <- map["__v"]
        uid <- map["_id"]
        avgRating <- map["avg_rating"]
        blockEndDate <- map["block_end_date"]
        blockReason <- map["block_reason"]
        blockStartDate <- map["block_start_date"]
        createdAt <- map["created_at"]
        defaultAddress <- map["default_address"]
        defaultLanguage <- map["default_language"]
        deviceToken <- map["device_token"]
        deviceType <- map["device_type"]
        email <- map["email"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        mobile <- map["mobile"]
        name <- map["name"]
        otp <- map["otp"]
        profilePicture <- map["profile_picture"]
        referalCode <- map["referal_code"]
        referalIncome <- map["referal_income"]
        registeredVia <- map["registered_via"]
        rewards <- map["rewards"]
        status <- map["status"]
        updatedAt <- map["updated_at"]
        uplineCode <- map["upline_code"]
        uplineEarned <- map["upline_earned"]
        userStatus <- map["user_status"]
        walletBalance <- map["wallet_balance"]

    }
}

class NotificationListRootData: BaseData {
    
    var notifications : [NotificationList]?
    
    override func mapping(map: Map) {
        
        notifications <- map["notifications"]
    }
}

class NotificationList: BaseData {
    
    var v : Int?
    var nid : Int?
    var createdAt : String?
    var notificationId : NotificationId?
    var read : String?
    var type : String?
    var updatedAt : String?
    var userId : String?
    
    override func mapping(map: Map) {
        
        v <- map["__v"]
        nid <- map["_id"]
        createdAt <- map["created_at"]
        notificationId <- map["notification_id"]
        read <- map["read"]
        type <- map["type"]
        updatedAt <- map["updated_at"]
        userId <- map["user_id"]
    }
}

class NotificationId: BaseData {
    
    var v : Int?
    var nid : Int?
    var createdAt : String?
    var descriptionField : String?
    var image : String?
    var notifyType : String?
    var scheduleDate : String?
    var scheduleTime : String?
    var status : String?
    var title : String?
    var updatedAt : String?
    var video : String?
    
    override func mapping(map: Map) {
        
        v <- map["__v"]
        nid <- map["_id"]
        createdAt <- map["created_at"]
        descriptionField <- map["description"]
        image <- map["image"]
        notifyType <- map["notify_type"]
        scheduleDate <- map["schedule_date"]
        scheduleTime <- map["schedule_time"]
        status <- map["status"]
        title <- map["title"]
        updatedAt <- map["updated_at"]
        video <- map["video"]
    }
}

class WalletHistoryRootData: BaseData {
    
    var userDetail : UserDetail?
    var walletHistory : [WalletHistory]?
    
    override func mapping(map: Map) {
        
        userDetail <- map["user"]
        walletHistory <- map["wallet_history"]
    }
}

class WalletHistory: BaseData {
    var v : Int?
    var wid : Int?
    var amount : Double?
    var createdAt : String?
    var filter : String?
    var filterUserId : Int?
    var remarks : String?
    var type : String?
    var userId : Int?
    
    override func mapping(map: Map) {
        v <- map["__v"]
        wid <- map["_id"]
        amount <- map["amount"]
        createdAt <- map["created_at"]
        filter <- map["filter"]
        filterUserId <- map["filter_user_id"]
        remarks <- map["remarks"]
        type <- map["type"]
        userId <- map["user_id"]
    
    }
}
