//
//  RejectionReasonViewController.swift
//  Restaurant
//
//  Created by MAC on 29/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class RejectionReasonViewController: BaseViewController<BaseData> {
    var onReject: ((_ reject: String)->Void)!
    
    @IBOutlet var choiceOption: [UIButton]!
    private var rejectionReason = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
          self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onYes(_ sender: UIButton) {
        if rejectionReason.isEmpty {return}
        self.onReject(self.rejectionReason)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rejectItem(_ sender: UIButton) {
        choiceOption.forEach({$0.isSelected = ($0.tag == sender.tag)})
        rejectionReason = sender.titleLabel!.text!
        
    }
    
   

}
