//
//  CartRepository.swift
//  GogoFood
//
//  Created by Crinoid Mac Mini on 04/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire


class CartRepository: BaseRepository {
    
    
    func appToCart(dishId: ProductData, toppings: [Int], onComplition: @escaping responseObject<CartData>) {
    showLoader(nil)
        var param: Parameters = ["dish_id": dishId.id, "restaurant_id": dishId.restaurant_id?.id ?? 0]
        if !toppings.isEmpty {
            param["toppings"] = toppings
        }
        Alamofire.request(ServerUrl.addToCartUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            if let d: CartData = self.getDataFrom(data) {
                 self.saveCartToCurrentSession(d)
                onComplition(d)
            }
        }
    }
    
    func modifyQuantity(hasIncrease: Bool, cartId: Int, onComplition: @escaping responseObject<CartData>) {
      showLoader(nil)
        let serverUrl = hasIncrease ? ServerUrl.increaseQuantity : ServerUrl.decreaseQuantity
          Alamofire.request(serverUrl, method: .post, parameters: ["cart_id": cartId], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
              if let d: CartData = self.getDataFrom(data) {
                self.saveCartToCurrentSession(d)
                  onComplition(d)
              }
          }
      }
    
    func updateTopping(cartId: Int, topping: [Int], onComplition: @escaping responseObject<CartData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.updateTopingUrl, method: .post, parameters: ["cart_id": cartId, "toppings": topping], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
              if let d: CartData = self.getDataFrom(data) {
                self.saveCartToCurrentSession(d)
                  onComplition(d)
              }
          }
    }
    
    func removeDish(_ id: Int, onComplition: @escaping responseObject<CartData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.decreaseDishUrl, method: .post, parameters: ["dish_id": id.description], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            if let d: CartData = self.getDataFrom(data) {
                self.saveCartToCurrentSession(d)
                onComplition(d)
            }
        }
    }
    
    
    func getCartItems(onComplition: @escaping responseObject<CartData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.viewCartUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            if let d: CartData = self.getDataFrom(data) {
                self.saveCartToCurrentSession(d)
                onComplition(d)
            }
        }
        let userId = CurrentSession.getI().localData.profile.id
        connectSocket("cart_data", params: ["group": "cart_data-\(userId)"]) { (data) in
            if let d: CartData = self.getDataFromSocketData(data){
                onComplition(d)
            }
        }
        
    }
    
    
    func placeOrder(paymentMethod: PaymentMethod, onComplition: @escaping responseObject<BaseObjectResponse<BaseData>>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.checkoutUrl, method: .post, parameters: ["payment_method": paymentMethod.rawValue], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            if let d: BaseObjectResponse = self.getDataFrom(data) {
                onComplition(d)
            }
        }
    }
    
    
    private func saveCartToCurrentSession(_ data: CartData) {
        CurrentSession.getI().localData.cart = data
        CurrentSession.getI().saveData()
        
    }
    
    
}
