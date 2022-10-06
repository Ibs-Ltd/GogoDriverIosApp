//
//  BaseCollectionViewCell.swift
//  globalCart
//
//  Created by Crinoid Mac Mini on 16/03/19.
//  Copyright © 2019 Crinoid. All rights reserved.
//

import UIKit


class BaseCollectionViewCell<T: BaseData>: UICollectionViewCell {
 
    var data: T!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  func initViewWith(_ data: T){
    self.data = data
    
    }
    
}
