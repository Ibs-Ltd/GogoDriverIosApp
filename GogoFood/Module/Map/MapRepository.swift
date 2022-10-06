//
//  MapRepository.swift
//  GogoFood
//
//  Created by MAC on 25/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire
import GoogleMaps
import ObjectMapper

class MapRepository: BaseRepository {
    func uppdateLocation(_ location: CLLocationCoordinate2D, onComplition: @escaping responseObject<SuccessMessageRootModel>) {
        let driverID = CurrentSession.getI().localData.profile.id
        Alamofire.request(ServerUrl.updateAddressUrl, method: .post, parameters: ["latitude": location.latitude, "longitude": location.longitude, "driver_id":driverID], encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in

//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }

            if let d: SuccessMessageRootModel = self.getDataFrom(item) {
                onComplition(d)
            }
        })
    }
    func getProfile(onComplition: @escaping responseObject<OTPData>) {
        //showLoader(nil)
        Alamofire.request(ServerUrl.getProfile, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let d: OTPData = self.getDataFrom(item) {
                onComplition(d)
            }
        }
    }
    
    
    
    
    func rateUserURLAPI(_ order_id: String, user_id: String, comments: String, rating: String, onComplition: @escaping responseObject<SuccessMessageRootModel>) {
            showLoader(nil)
            Alamofire.request(ServerUrl.rateUserUrl, method: .post, parameters: ["order_id" : "", "user_id" : "", "rating" : "", "comments" : ""], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
                
    //            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
    //            //print(dict)
    //            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
    //                let str = String(data: data, encoding: .utf8) {
    //                //print(str)
    //            }

                if let d: SuccessMessageRootModel = self.getDataFrom(data) {
                    onComplition(d)
                }
            }
        }
    
    func uppdateLocationSocket(_ location: CLLocationCoordinate2D, onComplition: @escaping responseObject<SuccessMessageRootModel>) {
        let driverID = CurrentSession.getI().localData.profile.id
        connectSocket("driver_location", params: ["latitude": location.latitude, "longitude": location.longitude, "driver_id":driverID]) { (data) in
            print("--------------------")
            if let d: SuccessMessageRootModel = self.getDataFromSocketData(data){
                onComplition(d)
            }
        }
    }
    
    func DriverGetOrdersSocket(onComplition: @escaping responseObject<SuccessMessageRootModel>) {
        connectSocketNew("driver_get_orders", params: ["group":"driver_get_orders-90"]){ data in
            if let d: SuccessMessageRootModel = self.getDataFromSocketData(data){
                onComplition(d)
            }
        }
    }
    
    func inviteListAPI(_ levelStrObj: String, onComplition: @escaping responseObject<InviteListRootData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.levelWiseUserUrl, method: .post, parameters: ["level":levelStrObj], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let d: InviteListRootData = self.getDataFrom(data) {
                onComplition(d)
            }
        }
    }
    
    func referalDetailsListAPI(onComplition: @escaping responseObject<InviteData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.referalDetailsUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }

            if let d: InviteData = self.getDataFrom(data) {
                onComplition(d)
            }
        }
    }
    
    func addBalanceToWallet(_ amount: String, onComplition: @escaping responseObject<SuccessMessageRootModel>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.transferBalanceUrl, method: .post, parameters: ["amount" : amount], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }

            if let d: SuccessMessageRootModel = self.getDataFrom(data) {
                onComplition(d)
            }
        }
    }
    
    func walletHistoryAPI(onComplition: @escaping responseObject<WalletHistoryRootData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.walletHistoryUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }

            if let d: WalletHistoryRootData = self.getDataFrom(data) {
                onComplition(d)
            }
        }
    }
}
