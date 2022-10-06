//
//  ControllerString.swift
//  GogoFood
//
//  Created by MAC on 16/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
enum Controller: String {
    case initController = "init"
    case userTab = "user"
    case driverTab = "driver"
    
    //authentication
    case verifyOtp = "VerificationViewController"
    case viewProfile = "ViewProfileViewController"
    case fbLogin = "FBLoginViewController"
    
    // home module controller
    case restaurants = "RestaurantsViewController"
    case storeInformation = "StoreInformationViewController"
    case foodCategory = "FoodCategoryViewController"
    case foodDetail = "FoodDetailViewController"
    
    //controllers for setting module
    case setting = "SettingViewController"
    case editProfile = "EditProfileViewController"
    case restaurantTime = "ResturantTimeViewController"
    case categoriesList = "CategoryListViewController"
    case productList = "ProductListViewController"
    case options = "ToppingViewController"
    case driverEditProfile = "DriverEditProfileViewController"
    case navRestaurantTime = "ReaturantTimmingWithNavigtion"
    case report = "ReportViewController"
    case support = "SupportCenterViewController"
    case myWallet = "MyWalletViewController"
    case credits = "CreditViewController"
    
    
    case historyController = "HistoryViewController"
    
    // for order module
    case liveOrder = "liveOrder"
    case cart = "CartViewController"
    case chooseOrder = "OrderChoiceViewController"
    case viewOrder = "OrderViewController"
    case currentOrder = "CurrentOrderVC"
    case reject = "RejectionReasonViewController"
    case driverOrder = "DriverOrderViewController"
    case orderOnMap = "DriverMapViewController"
    
    // for map controller
    case address = "AddAddressViewController"
    
    // for food controller
    
    
    case inviteDetail = "InviteDetailViewController"
   
}

