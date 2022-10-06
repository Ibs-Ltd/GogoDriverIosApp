//
//  RestaurantsViewController.swift
//  User
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class RestaurantsViewController: BaseCollectionViewController<RestaurantProfileData> {

   
    var hasShowTopRestuarants = false // To show the top restaurants
    var showRestaurantsFromCart = false //Send the list of restaurants of cart
    private let repo = HomeRepository()
    
    override func viewDidLoad() {
        //nib = CollectionViewCell.RestrauntCollectionViewCell.rawValue
        nib = CollectionViewCell.restrauntCollectionViewCell.rawValue
        super.viewDidLoad()
        self.createNavigationLeftButton(NavigationTitleString.allRestaurant)
        if showRestaurantsFromCart {
            setCartRestaurants()
        }else{
            repo.getallResturants(top: hasShowTopRestuarants) { (data) in
                self.allItems = data.resturants
                self.currentItems = self.allItems
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func setCartRestaurants() {
        let unique = Array(Set(self.allItems))
        self.allItems.removeAll()
        self.allItems = unique
        self.currentItems = unique
        self.collectionView.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: StoreInformationViewController = self.getViewController(.storeInformation, on: .home)
        let data = StoreInfomationData()
        data.restaurant = self.currentItems[indexPath.row]
        vc.data = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nib, for: indexPath) as! RestrauntCollectionViewCell
        cell.initView(withData: self.currentItems[indexPath.row])
        cell.numberOfOrder.isHidden = true
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 12
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
