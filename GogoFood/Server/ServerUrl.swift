//
//  ServerUrl.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import Foundation

struct ServerUrl {
    

   //  static let baseUrl = "https://gogofoodapp.com/api/"
    //static let baseUrl = "http://gogofoodapp.com:4000/"
    static let baseUrl = "https://dev.gogofoodapp.com/devapi/"
     static let socketBaseUrl = "https://dev.gogofoodapp.com"
//    static let socketBaseUrl = "https://dev.gogofoodapp.com"
    static let appUrl = ServerUrl.baseUrl + "driver/"
    
    
    // Authentication
    static let signUpUrl = ServerUrl.appUrl + "signup"
    static let verifyOTPUrl = ServerUrl.appUrl + "verify/otp"
    static let logoutUrl = ServerUrl.appUrl + "logout"
    // Home
    
    
    // order related
    
    //Setting repository
    static let updateProfileUrl = ServerUrl.appUrl + "edit/profile"
    static let acceptOrderUrl = ServerUrl.appUrl + "accept/order"
    static let rejectOrderUrl = ServerUrl.appUrl + "reject/order"

    static let onGoingOrderUrl = ServerUrl.appUrl + "home/data"
    static let changeStatusUrl = ServerUrl.appUrl + "change/status"
    static let arrivedToRestaurantUrl = ServerUrl.appUrl + "arrived/to/restaurant"
    static let startToUserUrl = ServerUrl.appUrl + "started/to/user"
    static let arrivedToUserUrl = ServerUrl.appUrl + "arrived/to/user"
    static let confirmPickupUrl = ServerUrl.appUrl + "confirm/pickup"
    static let restaurantOrderDetailsUrl = ServerUrl.appUrl + "restaurant/order/details"
    static let updateAddressUrl = ServerUrl.appUrl + "update/current/location"
    static let orderHistoryUrl = ServerUrl.appUrl + "order/history"
    static let levelWiseUserUrl = ServerUrl.appUrl + "level/wise/user"
    static let referalDetailsUrl = ServerUrl.appUrl + "referal/income/details"
    static let transferBalanceUrl = ServerUrl.appUrl + "transfer/balance"
    static let notificationsURL = ServerUrl.appUrl + "notifications"
    static let walletHistoryUrl = ServerUrl.appUrl + "wallet/history"
    
    static let orderDetailsUrl = ServerUrl.appUrl + "order/details"
    static let confirmDeliveryUrl = ServerUrl.appUrl + "confirm/delivery"
    static let rateUserUrl = ServerUrl.appUrl + "rate/user"
    static let getProfile  =  ServerUrl.appUrl + "profile/details"

    static let creditUrl = ServerUrl.appUrl + "credit/history"

}

