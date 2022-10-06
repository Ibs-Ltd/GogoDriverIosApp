//
//  ReceiptViewController.swift
//  User
//
//  Created by Apple on 18/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class ReceiptViewController: BottomPopupViewController {

    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var amountLbl : UILabel!
    @IBOutlet weak var orderLbl : UILabel!
    @IBOutlet weak var secondLbl : UILabel!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var previousObj : OrderViewController!
    var counter = 15
    var orderDic : OrderData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateLbl.text = "Date: " + (TimeDateUtils.getDataWithTime(fromDate: self.orderDic.getCreatedTime()))
        self.orderLbl.text = "#ORDER " + (self.orderDic.order_id?.id.toString())!
        self.amountLbl.text = "$" + (self.orderDic.order_id?.total_amount!.toString())!
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            self.secondLbl.text = counter.toString() + " Sec"
            counter -= 1
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
