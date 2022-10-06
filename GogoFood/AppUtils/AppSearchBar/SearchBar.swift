//
//  SearchBar.swift
//  GogoFood
//
//  Created by MAC on 19/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class SearchBar: BaseAppView {

    
    
    @IBOutlet weak var searchView: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func tapOnVoiceButton(_ sender: UIButton) {
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonSetup("SearchBar")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
  

    
}
