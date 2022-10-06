//
//  ItemQuantityViewController.swift
//  User
//
//  Created by YOGESH BANSAL on 14/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import SocketIO

class StoreInformationViewController: BaseTableViewController<StoreInfomationData> {
    
    @IBOutlet weak var restroInfoView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mealTypes: UILabel!
    @IBOutlet weak var cookingTime: UIButton!
    @IBOutlet weak var totalSold: UILabel!
    @IBOutlet weak var openingInfoView: UIView!
    
    private let repo = HomeRepository()
    private var product: [ProductData] = []
    private var selectedTag: UInt!
   
    
    override func viewDidLoad() {
        nib = [TableViewCell.tagTableViewCell.rawValue,
               TableViewCell.tagTableViewCell.rawValue,
               TableViewCell.foodDetailTableViewCell.rawValue,
               TableViewCell.homeFooter.rawValue,
               TableViewCell.recommendation.rawValue
        ]
        super.viewDidLoad()
        setRestaurantInfo()
        createNavigationLeftButton(NavigationTitleString.storeInformation)
        
        
       
        repo.getStoreInformation(self.data?.restaurant?.id ?? 0) { (data) in
            self.data = data
            self.setRestaurantInfo()
            self.getProduct(categoryId: "all", restaurent: self.data?.restaurant?.id ?? 0)
            
            
        }
        
    }
    
    deinit {
       repo.disconnectSocket()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addCartButton()
        addNotification()
        tableView.reloadData()
    }
    
    override func onChangeCartItem(notification: Notification) {
        super.onChangeCartItem(notification: notification)
        self.tableView.reloadData()
    }
    
    
    
    
    func setRestaurantInfo() {
        if let profile = self.data?.restaurant {
            ServerImageFetcher.i.loadProfileImageIn(restaurantImageView, url: profile.profile_picture ?? "")
            name.text = profile.name
            cookingTime.setTitle(profile.getCookingTime(), for: .normal)
            totalSold.text = profile.getTotalSold()
            mealTypes.text = profile.description
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if let d = self.data?.categories {
                return d.isEmpty ? CGFloat.zero : 60
            }
        }
        return CGFloat.zero
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  section == 1 ? self.product.count : 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            
            let c =  tableView.dequeueReusableCell(withIdentifier: nib[1]) as! TagTableViewCell
            if let tags = self.data?.categories {
                c.tags = tags
                c.canAddAll = true
                c.select = self.selectedTag
                c.initData()
                c.titleTextHeightConstraint.constant = 0
                
                //c.tagViewOutlet.reload()
                c.onSelectTag = {category, selectedTag in
                    self.selectedTag = selectedTag
                    let categoryId = (selectedTag == 0) ? "all" : category.id.description
                    self.getProduct(categoryId: categoryId, restaurent: (self.data?.restaurant!.id)!)
                }
            }
            return c
        }
        return nil
    }
    
    func getProduct(categoryId: String, restaurent: Int) {
        self.repo.getProductOf(categoryId: categoryId, of: restaurent, limit: 10, page: 1, onComplition: { (data) in
            self.product = data.products
            self.tableView.reloadData()
        })
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.showProduct(product: product[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let d = self.data{
                return (d.recommended?.isEmpty ?? true) ? 0 : 150
            }
            return 130
        }
        if indexPath.section == 2{
            return 80
        }
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let c =  tableView.dequeueReusableCell(withIdentifier: nib[4]) as! RecommendationCollectionTableViewCell
            if let recommend = self.data?.recommended {
                c.initView(withData: recommend)
            }
            c.selectProduct = { item in
                self.showProduct(product: item)
                
            }
            return c
            
        }
        
        if indexPath.section == 1{
            let c = tableView.dequeueReusableCell(withIdentifier: nib[2]) as! FoodDetailTableViewCell
            if let profile = self.data?.restaurant {
                c.restaurantProfile = profile
                c.initView(withData: product[indexPath.row])
            }
            
            return c
            
        }
        let footer = tableView.dequeueReusableCell(withIdentifier: nib[3]) as! HomeFooterTableViewCell
        footer.button.backgroundColor = AppConstant.primaryColor
        footer.button.setTitle(AppStrings.openYourCart + "(\(CurrentSession.getI().localData.cart.cartItems.count) Items)", for: .normal)
        footer.button.setTitleColor(UIColor.white, for: .normal)
        footer.button.setImage(UIImage(named: "cart11"), for: .normal)
        footer.tapOnButton = {
            self.tapOnCartButton()
        }
        return footer
        
    }
    
    private func showProduct(product: ProductData) {
        showDetailOf(product: product, vc: self)
    }
    
}
