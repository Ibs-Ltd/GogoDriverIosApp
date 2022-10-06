//
//  FoodCollectionTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 16/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class FoodCollectionTableViewCell: BaseCollectionViewInTableViewCell<ProductData> {

    
    @IBOutlet weak var nameLabel: UILabel!
    var selectProduct: ((_ data: ProductData) -> Void)!
    
    override func awakeFromNib() {
        nib = CollectionViewCell.foodCollectionViewCell.rawValue
        super.awakeFromNib()
        // Initialization code
    }
    
    override func initView(withData: [ProductData]) {
        super.initView(withData: withData)
        self.collectionView.reloadData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = super.collectionView(collectionView, cellForItemAt: indexPath) as! FoodCollectionViewCell
        c.initViewWith(self.data?[indexPath.row] ?? ProductData())
        return c
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectProduct(self.data?[indexPath.row] ?? ProductData())
    }
    
    
}
