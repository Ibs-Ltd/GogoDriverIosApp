//
//  SettingRepository.swift
//  GogoFood
//
//  Created by MAC on 23/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire


class SettingRepository: BaseRepository {
    
    
    #if Driver
    func updateDriverProfle(image: UIImage!, name: String, email: String? , uplineCode: String?, vehicleColor: String, vehicleYear: String, vehicleModel: String, plateNumber: String, idFront: UIImage!, idBack: UIImage!, vIDFront: UIImage, vIDBack: UIImage, onComplition: @escaping responseObject<EditProfileData>) {
        showLoader(nil)
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "profile_picture", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(idFront.jpegData(compressionQuality: 0.5)!, withName: "id_card_front", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(idBack.jpegData(compressionQuality: 0.5)!, withName: "id_card_back", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(vIDFront.jpegData(compressionQuality: 0.5)!, withName: "vehicle_id_front", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(vIDBack.jpegData(compressionQuality: 0.5)!, withName: "vehicle_id_back", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(name.data(using: .utf8)!, withName: "name")
            multipartFormData.append(vehicleColor.data(using: .utf8)!, withName: "vehicle_color")
            multipartFormData.append(vehicleYear.data(using: .utf8)!, withName: "vehicle_year")
            multipartFormData.append(vehicleModel.data(using: .utf8)!, withName: "vehicle_model")
            multipartFormData.append(plateNumber.data(using: .utf8)!, withName: "plate_no")
            if let email = email{
                multipartFormData.append((email.data(using: .utf8))!, withName: "email")
            }
            
            if let upline = uplineCode {
                multipartFormData.append(upline.data(using: .utf8)!, withName: "upline_code")
            }
            
            
        },
                         usingThreshold:UInt64.init(),
                         to: ServerUrl.updateProfileUrl,
                         method:.post,
                         headers:self.header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.responseString(completionHandler: { (item) in
                                    
                                    
                                    
                                    if let d: EditProfileData =  self.getDataFromString(item.value!, showSuccess: { (messsage) in
                                        self.showError(messsage)
                                    }){
                                        
                                        onComplition(d)
                                    }
                                    
                                })
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
    }
    #else
    func updateUserProfile(name: String, phoneNumber: String?, image: Data, userStatus: String, email: String?,  onComplition: @escaping responseObject<EditProfileData>) {
        showLoader(nil)
        Alamofire.upload(multipartFormData:{ multipartFormData in
            #if Restaurant
            multipartFormData.append(image, withName: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(name.data(using: .utf8)!, withName: "restaurant_name")
            
            #elseif User
            multipartFormData.append(image, withName: "profile_picture", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(name.data(using: .utf8)!, withName: "name")
            multipartFormData.append(userStatus.data(using: .utf8)!, withName: "user_status")
            
            #endif
            if let email = email{
                multipartFormData.append((email.data(using: .utf8))!, withName: "email")
            }
            
            if let number = phoneNumber {
                multipartFormData.append(number.data(using: .utf8)!, withName: "mobile1")
            }
            
        },
                         usingThreshold:UInt64.init(),
                         to: ServerUrl.updateProfileUrl,
                         method:.post,
                         headers:self.header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.responseString(completionHandler: { (item) in
                                    
                                    
                                    
                                    if let d: EditProfileData =  self.getDataFromString(item.value!, showSuccess: { (messsage) in
                                        self.showError(messsage)
                                    }){
                                        
                                        onComplition(d)
                                    }
                                    
                                })
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
        
        
        
        
    }
    #endif
    
    #if Restaurant
    func addRestaurantTime(data: RestaurantTimmingData, onComplition: @escaping responseObject<EditProfileData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.restaurantTimmingUrl, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            if let d: EditProfileData = self.getDataFrom(item){
                onComplition(d)
            }
        }
    }
    
    
    func modifyCategory(withUpdate: Bool, name: String, discription: String, image: Data, id: String? ,onComplition: @escaping responseObject<BaseData>) {
        showLoader(nil)
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(image, withName: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(name.data(using: .utf8)!, withName: "cat_name")
            multipartFormData.append(discription.data(using: .utf8)!, withName: "description")
            if withUpdate{
                multipartFormData.append(id!.data(using: .utf8)!, withName: "id")
            }
            
        },
                         usingThreshold:UInt64.init(),
                         to: withUpdate ? ServerUrl.updateCategoryUrl : ServerUrl.addCategoryUrl,
                         method:.post,
                         headers:self.header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.responseString(completionHandler: { (item) in
                                    
                                    if let d: BaseObjectResponse<BaseData> =  self.getDataFromString(item.value!, showSuccess: nil){
                                        onComplition(d)
                                    }
                                })
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
        
    }
    
    
    
    func getCategoryList(onComplition: @escaping responseObject<CategoriesData>) {
//        showLoader(nil)
        Alamofire.request(ServerUrl.categoryUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            self.dismiss()
            if let d: CategoriesData = self.getDataFrom(item){
                onComplition(d)
            }
        }
    }
    
    
    func getProductList(onComplition: @escaping responseObject<MenuData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.productUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            if let d: MenuData = self.getDataFrom(item){
                
                onComplition(d)
            }
        }
    }
    
    func getReportList(typeStr : String, onComplition: @escaping responseObject<ReportsRootModel>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.reportUrl+"/all", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }
            
            if let d: ReportsRootModel = self.getDataFrom(item){
                onComplition(d)
            }
        }
    }
    
    func modifyProductList(withAdd: Bool, data: ProductPostData!, onComplition: @escaping responseObject<BaseData>) {
        showLoader(nil)
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(data.productImage.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(data.name!.data(using: .utf8)!, withName: "name")
            multipartFormData.append(data.catedoryId.data(using: .utf8)!, withName: "category")
            multipartFormData.append(data.price!.description.data(using: .utf8)!, withName: "price")
            multipartFormData.append(data.is_recomend!.data(using: .utf8)!, withName: "recomend")
            multipartFormData.append(data.description!.data(using: .utf8)!, withName: "description")
            multipartFormData.append(data.discount_type!.data(using: .utf8)!, withName: "discount_type")
            
            
            
            if !(data.options?.isEmpty ?? true) {
                data.options?.forEach({ (options) in
                    multipartFormData.append(options.description.data(using: .utf8)!, withName: "options[]")
                })
                
            }
            
            
            if data.discount_type! == "percentage" ||  data.discount_type! == "coupon"{
                multipartFormData.append(data.discount_percentage!.description.data(using: .utf8)!, withName: "discount_percentage")
            }else{
                multipartFormData.append("0".description.data(using: .utf8)!, withName: "discount_percentage")
            }
            if data.discount_type! == "coupon" {
                multipartFormData.append(data.coupon_code!.data(using: .utf8)!, withName: "coupon_code")
            }
            if !withAdd {
                multipartFormData.append(data.getCombineString().data(using: .utf8)!, withName: "id")
            }
        },
                         usingThreshold:UInt64.init(),
                         to: withAdd ? ServerUrl.addProductUrl : ServerUrl.updateProductUrl,
                         method:.post,
                         headers:self.header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.responseString(completionHandler: { (item) in
                                    
                                    if let d: BaseObjectResponse<BaseData> =  self.getDataFromString(item.value!, showSuccess: nil){
                                        onComplition(d)
                                    }
                                })
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
        
        
    }
    
    
    func getResturantTimmig(onComplition: @escaping responseObject<RestaurantProfileData>) {
        Alamofire.request(ServerUrl.getRestaurantTimmingUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            if let d: RestaurantTime = self.getDataFrom(item){
                onComplition(d.restiming.first!)
            }
        }
        
        
    }
    
    
    
    
    
    func changeProductStatus(ofId: Int, onComplition: @escaping responseObject<BaseData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.setProductStatus, method: .post, parameters: ["id": ofId], encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            if let d: BaseObjectResponse<BaseData> = self.getDataFrom(item){
                onComplition(d)
            }
        }
    }
    
    
    func getToppingOptions(onComplition: @escaping responseObject<FoodOptionData>){
        showLoader(nil)
        Alamofire.request(ServerUrl.toppingOptionsUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            self.dismiss()
            if let d: FoodOptionData = self.getDataFrom(item){
                onComplition(d)
            }
        }
    }
    
    #endif
}
