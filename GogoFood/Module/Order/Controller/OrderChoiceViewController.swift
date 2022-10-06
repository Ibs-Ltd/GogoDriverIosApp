//
//  OrderChoiceViewController.swift
//  User
//
//  Created by MAC on 13/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class OrderChoiceViewController: BaseViewController<BaseData> {

    @IBOutlet weak private var selectedItem: UILabel!
    
    @IBOutlet weak private var toppingInfo: UILabel!
    var onRepeat: (() -> Void)!
    var onChoose: (() -> Void)!
    var itemName: String!
    var topping: String!
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        selectedItem.text = itemName
//        toppingInfo.text = "Do you want to repeat same order with - \(topping ?? "")"
    }
    
    
    @IBAction func onChoose(_ sender: UIButton) {
        
        onChoose()
    }
    @IBAction func onRepeat(_ sender: UIButton) {
        
        onRepeat()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

   

}
