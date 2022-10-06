//
//  BaseTableView.swift
//  zoukMikael
//
//  Created by admni on 05/02/19.
//  Copyright © 2019 Crinoid. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewCell<T: BaseData>: UITableViewCell {
    
    var data: [T]?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let data = self.data {
            initView(withData: data.first!)
        }
       contentView.backgroundColor = UIColor.clear
    }
    
    func initView(withData: T) {
        self.data = [withData]
        //fatalError("you forget to override or you call super by mistake")
    }
    
   
    
}



