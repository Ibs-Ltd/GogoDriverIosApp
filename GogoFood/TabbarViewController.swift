//
//  TabbarViewController.swift
//  GogoFood
//
//  Created by MAC on 16/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    private let home = UITabBarItem(title: NavigationTitleString.home.localized(), image: #imageLiteral(resourceName: "home_unselected"), selectedImage: nil)
    private let inviteAndEarn = UITabBarItem(title: NavigationTitleString.inviteAndEarn.localized(), image: #imageLiteral(resourceName: "referEarn_unselected"), selectedImage: nil)
    private let history = UITabBarItem(title: NavigationTitleString.history.localized(), image: #imageLiteral(resourceName: "history_unselected"), selectedImage: nil)
    private let notification = UITabBarItem(title: NavigationTitleString.notification.localized(), image: #imageLiteral(resourceName: "notification_unselected"), selectedImage: nil)
    private let setting = UITabBarItem(title: NavigationTitleString.setting.localized(), image: #imageLiteral(resourceName: "setting_unselected"), selectedImage: nil)
    private let liveOrder = UITabBarItem(title: NavigationTitleString.liveOrder, image: #imageLiteral(resourceName: "liveOrder"), selectedImage: nil)
    private let aceepted = UITabBarItem(title: NavigationTitleString.accepted, image: #imageLiteral(resourceName: "acceptedOrder"), selectedImage: nil)
    private let restaurantHistory = UITabBarItem(title: NavigationTitleString.history, image: #imageLiteral(resourceName: "hisoryRestaurant"), selectedImage: nil)
    private let feed = UITabBarItem(title: NavigationTitleString.feed, image: #imageLiteral(resourceName: "feed"), selectedImage: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.tintColor = AppConstant.primaryColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if Restaurant
            setTabForRestaurant()
        #else
            setTabForUser()
        #endif
        
        
    }
    
    func setTabForUser() {
        self.viewControllers?[0].tabBarItem = self.home
        self.viewControllers?[1].tabBarItem = self.inviteAndEarn
        self.viewControllers?[2].tabBarItem = self.history
        self.viewControllers?[3].tabBarItem = self.notification
        self.viewControllers?[4].tabBarItem = self.setting
    }
    
    func setTabForRestaurant() {
        self.viewControllers?.first?.tabBarItem = liveOrder
        self.viewControllers?[1].tabBarItem = self.restaurantHistory
        self.viewControllers?[2].tabBarItem = self.feed
        self.viewControllers?[3].tabBarItem = self.setting
    }
    
    func createHome() -> UIViewController {
        let storyBoard = UIStoryboard(name: StoryBoard.home.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.initController.rawValue)
        vc.tabBarItem = home
        return vc
    }
    
    func createSettingController() -> UIViewController {
        let storyBoard = UIStoryboard(name: StoryBoard.setting.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.initController.rawValue)
        vc.tabBarItem = setting
        return vc
    }
    
    
    func createHistoryController() -> UIViewController {
        let storyBoard = UIStoryboard(name: StoryBoard.history.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.initController.rawValue)
        vc.tabBarItem =  CurrentSession.getI().getAppType() == App.restaurant ? restaurantHistory : history
        return vc
    }
    
    func createNotification() -> UIViewController {
        let storyBoard = UIStoryboard(name: StoryBoard.notification.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.initController.rawValue)
        vc.tabBarItem = notification
        return vc
    }
    
    func createReferAndEarn() -> UIViewController{
        let storyBoard = UIStoryboard(name: StoryBoard.inviteAndEarn.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.initController.rawValue)
        vc.tabBarItem = inviteAndEarn
        return vc
    }
    
    // For restaurant
    func createFeed() -> UIViewController {
        let storyBoard = UIStoryboard(name: StoryBoard.feed.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.initController.rawValue)
        vc.tabBarItem = feed
        return vc
        
    }
    
    func createLiveOrder() -> UIViewController{
        let storyBoard = UIStoryboard(name: StoryBoard.order.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.liveOrder.rawValue)
        vc.tabBarItem = liveOrder
        return vc
    }
    
    func createHistory() -> UIViewController {
        let storyBoard = UIStoryboard(name: StoryBoard.history.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller.storeInformation.rawValue)
        vc.tabBarItem = liveOrder
        return vc
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
}

extension UIStoryboard {
    

}
