//
//  FoodDetailViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 13/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import ImageSlideshow



class FoodDetailViewController: BaseTableViewController<ProductData> {
    
    @IBOutlet weak var bannerViewOutlet: ImageSlideshow!
    private let repo = HomeRepository()
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var stepper: AppStepper!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var itemDetail: FoodDetailData!
    @IBOutlet weak var navigationBar: UIView!
    
    @IBOutlet weak var cookingTime: UIButton!
    @IBOutlet weak var deliveryTime: UIButton!
    override func viewDidLoad() {
        //nib = [TableViewCell.FoodDetailTableViewCell.rawValue]
        nib = [TableViewCell.listItemTableViewCell.rawValue,
               TableViewCell.homeFooter.rawValue]
        //nib = [TableViewCell.HistoryTableViewCell.rawValue]
        
        super.viewDidLoad()
        scrollView.delegate = self
        navigationController?.edgesForExtendedLayout = []
        addNotification()
        repo.getDetailOf(self.data!) { (data) in
            self.itemDetail = data
            self.setItemDetail()
            self.addCartButton()
            self.tableView.reloadData()
            
        }
        
        createNavigationLeftButton(nil)
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
      
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        // transparentNavigationBar()
        super.viewDidAppear(animated)
       
       
    }
    
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        visibleNavigationBar()
    }
    
    
    func setItemDetail() {
        guard let detail = self.itemDetail else {return}
        self.itemName.text = detail.product.name
        self.itemPrice.attributedText = detail.product.getFinalAmount(stikeColor: AppConstant.primaryColor, normalColor: AppConstant.appBlueColor, fontSize: 15, inSameLine: true)
        self.stepper.dish = detail.product
        
        self.cookingTime.setTitle(detail.product.getCookingTime(), for: .normal)
        self.deliveryTime.setTitle(detail.product.getDeliveryTime(), for: .normal)
        
        self.setBannerData()
    }
    
    deinit {
         removeNotification()
        repo.disconnectSocket()
    }
    
    
    func setBannerData() {
        bannerViewOutlet.setImageInputs([
            SDWebImageSource(urlString: itemDetail.product.image ?? "")!
            ])
        bannerViewOutlet.zoomEnabled = true
        bannerViewOutlet.contentScaleMode = .scaleAspectFill
        bannerViewOutlet.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        bannerViewOutlet.activityIndicator = DefaultActivityIndicator(style: .gray, color: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FoodDetailViewController.didTap))
        bannerViewOutlet.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    override func onChangeCartItem(notification: Notification) {
        addCartButton()
        setItemDetail()
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detail = self.itemDetail else {return 0}
        return section == 0 ? detail.recommended.count : self.itemDetail.similar.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "header") as! FoodDetailHeaderTableViewCell
        headerView.typeLabel.text  = section == 0 ? "Recommends" : "Similars"
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detail = self.itemDetail else {return UITableViewCell()}
        let c = tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath) as! ListItemTableViewCell
        c.initView(withData: indexPath.section == 0 ? detail.recommended[indexPath.row] : detail.similar[indexPath.row])
        
        return c
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = indexPath.section == 0 ? self.itemDetail.recommended[indexPath.row] : self.itemDetail.similar[indexPath.row]
        showDetailOf(product: product, vc: self)
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        let c = tableView.dequeueReusableCell(withIdentifier: nib[1]) as! HomeFooterTableViewCell
        c.button.setTitle(AppStrings.viewCart.uppercased(), for: .normal)
        c.button.setTitleColor(AppConstant.primaryColor, for: .normal)
        c.selectionStyle = .none
        c.tapOnButton = {
            let vc: CartViewController = self.getViewController(.cart, on: .order)
            self.navigationController?.pushViewController(vc, animated: true)
            //  self.showRestaurant(all: true)
        }
        return c
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.zero : 60
    }
    
    
    @objc func didTap() {
        bannerViewOutlet.presentFullScreenController(from: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView == self.scrollView {
            self.navigationBar.backgroundColor = AppConstant.backgroundColor.withAlphaComponent(scrollView.contentOffset.y / 160)
        }
        
    }

    
}

class FoodDetailHeaderTableViewCell: BaseTableViewCell<BaseData>{
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
}
