//
//  FoodInformationViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 05/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import ImageSlideshow

class FoodInformationViewController: BaseTableViewController<HomeData> {

    @IBOutlet weak var bannerView: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initateBanner()
    }
    
    
    // MARK:- Banner related stuff
    func initateBanner(){
        bannerView.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customUnder(padding: 50))
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = AppConstant.primaryColor
        pageIndicator.pageIndicatorTintColor = UIColor.clear
        
        //pageIndicator.pag = AppConstant.primaryColor
        bannerView.pageIndicator = pageIndicator
        
        bannerView.setImageInputs([
            ImageSource(image: UIImage(named: "dish")!),
            ImageSource(image: UIImage(named: "dish")!),
            ImageSource(image: UIImage(named: "dish")!),
            ImageSource(image: UIImage(named: "dish")!),
            ImageSource(image: UIImage(named: "dish")!),
            ImageSource(image: UIImage(named: "dish")!)
            ])
        bannerView.zoomEnabled = true
        
        
        bannerView.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        //bannerView.activityIndicator = DefaultActivityIndicator(style: .gray, color: UIColor.red)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FoodDetailViewController.didTap))
        bannerView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTap() {
        bannerView.presentFullScreenController(from: self)
    }
}


