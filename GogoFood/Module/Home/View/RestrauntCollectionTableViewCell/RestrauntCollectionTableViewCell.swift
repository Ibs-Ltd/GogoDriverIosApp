//
//  RestrauntCollectionTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 16/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class RestrauntCollectionTableViewCell: BaseCollectionViewInTableViewCell<RestaurantProfileData> {

   var hideInfoView = false
    var onTapAll:  (()-> Void)!
    
    override func awakeFromNib() {
        nib = CollectionViewCell.restrauntCollectionViewCell.rawValue
        super.awakeFromNib()
        // Initialization code
    }

    
    override func initView(withData: [RestaurantProfileData]) {
        super.initView(withData: withData)
        self.collectionView.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction private func showAllRestaurants(_ sender: UIButton) {
        onTapAll()
        
        
    }
    
 
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = super.collectionView(collectionView, cellForItemAt: indexPath) as! RestrauntCollectionViewCell
        c.orderLabelOutlet.isHidden = hideInfoView
        if hideInfoView {
        c.infoViewHeight.constant = 0
            
           
        }
        if let items = self.data {
              c.initView(withData: items[indexPath.row])
        }
      
        return c
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if hideInfoView {
            let width = (collectionView.frame.height - 40)
            return CGSize(width: width * 1.5, height: width)
        }
        
        let width = (collectionView.frame.height - 10) / 2
        return CGSize(width: width, height: width)
    }
    
    
}
