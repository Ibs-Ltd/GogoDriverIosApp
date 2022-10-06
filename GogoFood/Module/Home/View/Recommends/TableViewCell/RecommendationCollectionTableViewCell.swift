//
//  RecommendationCollectionTableViewCell.swift
//  GogoFood
//
//  Created by MAC on 19/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class RecommendationCollectionTableViewCell: BaseCollectionViewInTableViewCell<ProductData> {

    var selectProduct: ((_ product: ProductData) -> Void)!
    
    override func awakeFromNib() {
    nib = CollectionViewCell.recommendsCollectionViewCell.rawValue
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
        let c = super.collectionView(collectionView, cellForItemAt: indexPath) as! RecommendsCollectionViewCell
        if let product = self.data?[indexPath.row] {
             c.initViewWith(product)
        }
        return c
    }
    

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.7
        return CGSize(width: width, height: collectionView.frame.height - 30)
    }
    
  override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectProduct(self.data?[indexPath.row] ?? ProductData())
    }
    
}


