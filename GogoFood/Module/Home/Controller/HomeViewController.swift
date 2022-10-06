//
//  HomeViewController.swift
//  User
//
//  Created by YOGESH BANSAL on 16/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import ImageSlideshow

class HomeViewController: BaseTableViewController<HomeData>, ImageSlideshowDelegate {
    
    @IBOutlet weak var bannerView: ImageSlideshow!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var searchBa: SearchBar!
    
    private let repo = HomeRepository()
  
    
    ////Banner
    
    @IBOutlet weak var soldView: UIView!
    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    private var currentBannerItem = 0
    
    @IBOutlet weak var orderNowButton: UIButton!
    
    
    //////End banner
    
    override func viewDidLoad() {
        nib = [TableViewCell.tagTableViewCell.rawValue, TableViewCell.foodCollectionTableViewCell.rawValue,
               TableViewCell.restrauntCollectionTableViewCell.rawValue,
               TableViewCell.homeFooter.rawValue]
        
        super.viewDidLoad()
        definesPresentationContext = true
        createNavigationLeftButton(nil)
    
        repo.getHomeData { (data) in
            self.data = data
            self.initateBanner()
            self.tableView.reloadData()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTrackingAndCartButton()
    } 
    
    override func createNavigationLeftButton(_ withTitle: String?) {
             ServerImageFetcher.i.loadProfileImageIn(profileImage, url: CurrentSession.getI().localData.profile.profile_picture ?? "")
    }
    
    @IBAction func showProfile(_ sender: Any) {
        self.navigationController?.pushViewController(Controller.editProfile, avaibleFor: StoryBoard.setting)
    }

    // MARK:- Banner related stuff
    func initateBanner(){
        bannerView.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customUnder(padding: 50))
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = AppConstant.primaryColor
        pageIndicator.pageIndicatorTintColor = UIColor.white
        bannerView.pageIndicator = pageIndicator
    
        if let d = self.data{
            bannerView.setImageInputs(d.banners.compactMap({SDWebImageSource(urlString: $0.image ?? "")!}))
        }
       
        bannerView.zoomEnabled = true
        bannerView.delegate = self
        bannerView.contentScaleMode = .scaleToFill
        bannerView.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        //bannerView.activityIndicator = DefaultActivityIndicator(style: .gray, color: UIColor.red)
        self.setBannerItems()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FoodDetailViewController.didTap))
        bannerView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTap() {
        bannerView.presentFullScreenController(from: self)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let c = tableView.dequeueReusableCell(withIdentifier: self.nib.first!) as! TagTableViewCell
        if let home = self.data {
            c.tags = home.categories
            c.initData()
            c.tagViewOutlet.reload()
            c.onSelectTag = { tag, _ in
                let vc: FoodCategoryViewController = self.getViewController(.foodCategory, on: .home)
                vc.category = tag
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return c
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if let d = self.data {
            return d.categories.isEmpty ? 0 : 80
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return getTopOrder(tableView)
        }
        if indexPath.row == 1 {
            return getRecommended(tableView)
        }
        if indexPath.row == 2 {
            return getRestaurant(tableView)
        }
        let c = tableView.dequeueReusableCell(withIdentifier: nib[3]) as! HomeFooterTableViewCell
        c.button.setTitle(AppStrings.restaurant, for: .normal)
        c.button.setTitleColor(AppConstant.primaryColor, for: .normal)
        c.selectionStyle = .none
        c.tapOnButton = {
            self.showRestaurant(all: true)
        }
        return c
    }
    
    private func showRestaurant(all: Bool) {
        let vc: RestaurantsViewController = self.getViewController(.restaurants, on: .home)
        vc.hasShowTopRestuarants = !all
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    private func getTopOrder(_ tableview: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib[1]) as! FoodCollectionTableViewCell
        cell.nameLabel.text = "Top Order"
        if let data = data{
            cell.initView(withData: data.topOrder)
            cell.selectProduct = { item in
                showDetailOf(product: item, vc: self)
            }
        }
        
        return cell
        
    }
    
    private func getRecommended(_ tableview: UITableView)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib[1]) as! FoodCollectionTableViewCell
        if let data = data {
            cell.initView(withData: data.recommended)
            cell.selectProduct = { item in
                showDetailOf(product: item, vc: self)
            }
        }
        
        return cell
    }
    
    private func getRestaurant(_ tableview: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib[2]) as! RestrauntCollectionTableViewCell
        cell.hideInfoView = true
        cell.onTapAll = {
            self.showRestaurant(all: false)
        }
        if let _ = data {
            cell.initView(withData: self.data?.topResaturant ?? [])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let d = self.data else{return 0}
        // for topOrder
        if indexPath.row == 0 {
            return d.topOrder.isEmpty ? 0 : 200
        }
        
        // for recommneded order
        if indexPath.row == 1  {
           return d.recommended.isEmpty ? 0 : 200
        
        }
        
        
        if indexPath.row == 3 {
            return 100
        }
        if indexPath.row == 2 {
            if let data = self.data {
                return data.topResaturant.isEmpty ? 0 : 180
            }
        }
        
        return 0
    }
    
    @IBAction func orderBannerItem(_ sender: UIButton) {
        showDetailOf(product: (self.data?.banners[self.currentBannerItem].dish_id)!, vc: self)
        
        
    }
    
   
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        self.currentBannerItem = page
        setBannerItems()
    }
    
    func setBannerItems() {
        let curentBanner = self.data?.banners[self.currentBannerItem]
        self.soldLabel.text = (curentBanner?.dish_id?.sold_qty ?? 0).description
       self.soldView.isHidden = self.soldLabel.text == "0"
        self.priceLabel.attributedText = curentBanner?.dish_id?.getFinalAmount(stikeColor: AppConstant.appBlueColor, normalColor: UIColor.white, fontSize: 15, inSameLine: false)
        self.priceView.isHidden = self.data?.banners.isEmpty ?? true
        self.soldView.isHidden = self.data?.banners.isEmpty ?? true
        self.orderNowButton.isHidden = self.data?.banners.isEmpty ?? true
        
    }
    
    
}

extension UINavigationController {
    
    func getController(_ vc: Controller, avaibleFor storyBoard: StoryBoard) -> UIViewController {
        
        let storyBoard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: vc.rawValue)
        
    }
    
    func pushViewController(_ vc: Controller, avaibleFor storyBoard: StoryBoard){
        let storyBoard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: vc.rawValue)
        viewController.hidesBottomBarWhenPushed = true
        self.pushViewController(viewController, animated: true)
        
    }
    
    func present(_ viewControllerToPresent: String, onStoryboard: String,animated flag: Bool, completion: (() -> Void)? = nil) {
        let storyBoard = UIStoryboard(name: onStoryboard, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewControllerToPresent)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: flag, completion: completion)
    }
    
}
