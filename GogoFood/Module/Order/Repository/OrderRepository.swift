//
//  OrderRepository.swift
//  Restaurant
//
//  Created by MAC on 28/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation

class OrderRepository: BaseRepository {
    
    #if Restaurant
    func getOrder(onComplition: @escaping responseObject<OrdersData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.liveOrderUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let d: OrdersData = self.getDataFrom(item) {
                onComplition(d)
            }
        }
        let id = CurrentSession.getI().localData.profile.id
        connectSocket("restaurant_orders", params: ["group":"restaurant_orders-\(id.description)"]){ data in
            if let d: OrdersData = self.getDataFromSocketData(data){
                onComplition(d)
            }
        }
    }
    
    func getTodayOrder(onComplition: @escaping responseObject<OrdersData>) {
        //showLoader(nil)
        Alamofire.request(ServerUrl.todayOrderUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let d: OrdersData = self.getDataFrom(item) {
                onComplition(d)
            }
        }
        let id = CurrentSession.getI().localData.profile.id
        connectSocket("restaurant_orders", params: ["group":"restaurant_orders-\(id.description)"]){ data in
            if let d: OrdersData = self.getDataFromSocketData(data){
                onComplition(d)
            }
        }
    }
    
    func removeItemFromOrder(_ id: [String], becauseOf reason: String, response: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.removeItemUrl, method: .post, parameters: ["id": id, "reason": reason], encoding: JSONEncoding.default, headers: self.header).responseString { (serverResponse) in
            self.dismiss()
            guard let value = serverResponse.value else{return}
            guard  let responseData = Mapper<BaseObjectResponse<BaseData>>().map(JSONString: value) else {return}
            if responseData.success {
                 response()
            }else{
                self.showError(responseData.message)
            }
           
        }
    }
    
    func rejectOrder(id: Int, response: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.rejectOrderUrl, method: .post, parameters: ["id":id], encoding: JSONEncoding.default, headers: self.header).responseString{ (item) in
            self.dismiss()
            if let _ : OrderData = self.getDataFrom(item) {
                response()
            }
        }

    }
    

    
    
    
    func orderHistory(onComplition: @escaping responseObject<OrdersData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.orderHistoryUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }

            
            if let d: OrdersData = self.getDataFrom(item) {
                onComplition(d)
            }
        })
    }
    
    func orderFinish(_ id: String, response: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.confirmPayment, method: .post, parameters: ["order_id": id], encoding: JSONEncoding.default, headers: self.header).responseString{ (item) in
            self.dismiss()
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            
            let tmpStr = dict["message"] as? String
            if tmpStr == "success"{
                response()
            }
        }
    }
    
//    func orderFinish(_ id: String, response: @escaping emptyResponse) {
//        showLoader(nil)
//        Alamofire.request(ServerUrl.confirmPayment, method: .post, parameters: ["order_id": id], encoding: JSONEncoding.default, headers: self.header).responseString{ (item) in
//
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
//
//            if let _ : BaseData = self.getDataFrom(item) {
//                response()
//            }
//        }
//    }
    
    #elseif Driver
    func orderHistory(onComplition: @escaping responseObject<OrdersData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.orderHistoryUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }

            
            if let d: OrdersData = self.getDataFrom(item) {
                onComplition(d)
            }
        })
    }
    
    func creditHistory(onComplition: @escaping responseObject<CreditData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.creditUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }

            
            if let d: CreditData = self.getDataFrom(item) {
                onComplition(d)
            }
        })
    }
    
    
    func setAvailaiblityStatus(_ status: String, onDone: @escaping emptyResponse) {
        Alamofire.request(ServerUrl.changeStatusUrl,
                          method: .post,
                          parameters: ["status": status],
                          encoding: JSONEncoding.default,
                          headers: self.header)
            .responseString { (item) in
            if let _ : BaseData = self.getDataFrom(item) {
                onDone()
            }
        }
    }
    
    func getOrderList(onDone: @escaping responseObject<OrdersData>) {
        Alamofire.request(ServerUrl.onGoingOrderUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            if let d: OrdersData = self.getDataFrom(item) {
                onDone(d)
            }
        })
    }
    
    func getOrderListWithLoader(onDone: @escaping responseObject<OrdersData>) {
            showLoader(nil)
            Alamofire.request(ServerUrl.onGoingOrderUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
                self.dismiss()
                let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
                print(dict)
                if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                    let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
                if let d: OrdersData = self.getDataFrom(item) {
                    onDone(d)
                    self.dismiss()
                }
            })
        }
    
    func arrivedToRes(_ resID: String, orderId: String, onDone: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.arrivedToRestaurantUrl, method: .post, parameters: ["restaurant_id": resID, "order_id": orderId], encoding:JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
            
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }
            
            if let _: BaseData = self.getDataFrom(item) {
                onDone()
            }
        })
    }
    
    func confirmPickup(_ index:Int? = 0, order: OrderInfoData, onDone: @escaping emptyResponse) {
        Alamofire.request(ServerUrl.confirmPickupUrl, method: .post, parameters: ["restaurant_id": order.restaurant_wise?[index ?? 0].restaurant_id?.id.toString()
            ?? "", "order_id": order.id.toString()], encoding:JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
                
                let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
                print(dict)
                if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                    let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
                
                if let _: BaseData = self.getDataFrom(item) {
                    onDone()
                }
            })
    }
    
    func startToUser(_ orderId: String, onDone: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.startToUserUrl, method: .post, parameters: ["order_id": orderId], encoding:JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
            
            if let _: BaseData = self.getDataFrom(item) {
                onDone()
            }
        })
    }
    
    func arrivedToUser(_ orderId: String, onDone: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.arrivedToUserUrl, method: .post, parameters: ["order_id": orderId], encoding:JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
            if let _: BaseData = self.getDataFrom(item) {
                onDone()
            }
        })
        
//        connectSocketNew("driver_arrived_to_user", params: ["group":"driver_arrived_to_user-\(orderId)"]){ data in
//            if let _: BaseData = self.getDataFromSocketData(data){
//                onDone()
//            }
//        }
    }
    
    func confirmDelivery(_ orderId: String, onDone: @escaping emptyResponse,onError: @escaping (String) -> Void ) {
        showLoader(nil)
        Alamofire.request(ServerUrl.confirmDeliveryUrl, method: .post, parameters: ["order_id": orderId], encoding:JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }
            self.dismiss()
            if let _: BaseData = self.getDataFrom(item) {
                onDone()
            }else{
                if let msg  = dict["message"] as? String{
                    onError(msg)
                }
            }
        })
    }
    
    func getOrderDetail(_ order: OrderData, onDone: @escaping responseObject<OrderDetailData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.orderDetailsUrl,
                          method: .post,
                          parameters: ["order_id": order.order_id?.id ?? 0],
                          encoding: JSONEncoding.default, headers: self.header)
            .responseString(completionHandler: { response in
                
            let dict = try! JSONSerialization.jsonObject(with: response.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }
                
            if let d: OrderDetailData = self.getDataFrom(response) {
                onDone(d)
            }
        })
    }

    
    #endif
    func acceptOrder(_ orderId: Int, done: @escaping emptyResponse) {
        Alamofire.request(ServerUrl.acceptOrderUrl,
                          method: .post,
                          parameters: ["order_id": orderId],
                          encoding: JSONEncoding.default,
                          headers: self.header)
            .responseString { (data) in
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let _: BaseData = self.getDataFrom(data) {
                 done()
            }
            self.dismiss()
        }
    }
    
    func rejectOrder(_ orderId: Int, done: @escaping emptyResponse) {
        Alamofire.request(ServerUrl.rejectOrderUrl,
                          method: .post,
                          parameters: ["order_id": orderId],
                          encoding: JSONEncoding.default,
                          headers: self.header)
            .responseString { (data) in
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let _: BaseData = self.getDataFrom(data) {
                 done()
            }
            self.dismiss()
        }
    }
    
    
    
    
//    func setAvailaiblityStatus(_ status: String, onDone: @escaping emptyResponse) {
//        Alamofire.request(ServerUrl.changeStatusUrl,
//                          method: .post,
//                          parameters: ["status": status],
//                          encoding: JSONEncoding.default,
//                          headers: self.header)
//            .responseString { (item) in
//            if let _ : BaseData = self.getDataFrom(item) {
//                onDone()
//            }
//        }
//    }
    
    

    
    
}
