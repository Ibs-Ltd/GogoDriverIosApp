/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

class ProfileData : BaseData{
	var name : String?
	var mobile : String?
    var mobile1 : String?
	var email : String?
	var upline_code : String?
	var referal_code : String?
	var otp : String?
	var registered_via : String?
	var profile_picture : String?
	var device_token : String?
	var avg_rating : Int?
	var wallet_balance : Int?
	var longitude : String?
	var latitude : String?
	var default_address : AddressData?
	var default_language : String?
    var user_status : String?
	var status : String?
	
    var lat:Double?
    var long:Double?
    var userStatus: UserStatus!
    
	override func mapping(map: Map) {
        super.mapping(map: map)
		name <- map["name"]
		mobile <- map["mobile"]
		email <- map["email"]
		upline_code <- map["upline_code"]
		referal_code <- map["referal_code"]
		otp <- map["otp"]
		registered_via <- map["registered_via"]
		profile_picture <- map["profile_picture"]
		device_token <- map["device_token"]
		avg_rating <- map["avg_rating"]
		wallet_balance <- map["wallet_balance"]
		longitude <- map["longitude"]
		latitude <- map["latitude"]
        long <- map["longitude"]
        lat <- map["latitude"]

		default_address <- map["default_address"]
		default_language <- map["default_language"]
		user_status <- map["user_status"]
		status <- map["status"]
		
        
        userStatus = UserStatus(rawValue: user_status ?? "")
       
	}
    
    func getPhoneNumber(secure: Bool) -> String {
      //  return "*******\(String((self.mobile?.suffix(2))!))"
        return self.mobile ?? ""
    }
    
    func getCompleteAddress(secure: Bool) -> String {
        if let d = self.default_address {
            let address = d.address ?? "      "
           return //secure
//            ? "**** \(address.dropFirst(5))"
//            :
            address
        }
        return ""
        
    }
    
    func getProfileImagerUrl() -> String{
     return profile_picture ?? ""
    }
    
}

class AddressData : BaseData {
    var user_id : Int?
    var address : String?
    var province : String?
    var district : String?
    var commune : String?
    var village : String?
    var latitude : Double?
    var longitude : Double?
    var is_default : Int?
    
    
   
    
    override func mapping(map: Map) {
        super.mapping(map: map)
       
        user_id <- map["user_id"]
        address <- map["address"]
        province <- map["province"]
        district <- map["district"]
        commune <- map["commune"]
        village <- map["village"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        is_default <- map["is_default"]
        
    }
    
    func getCompeleteAddress() -> String {
        
        return  ""
        
    }
    
}
