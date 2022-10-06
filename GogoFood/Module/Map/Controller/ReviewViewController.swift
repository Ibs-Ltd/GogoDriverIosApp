//
//  ReviewViewController.swift
//  User
//
//  Created by Apple on 18/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import Cosmos

class ReviewViewController: BottomPopupViewController {

    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var reviewTxt : UITextView!
    
    private let repo = MapRepository()
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var previousObj : DriverMapViewController!
    var orderDic : OrderData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        repo.rateUserURLAPI("", user_id: "", comments: "", rating: "") { (data) in
            print(data)
            oneButtonAlertControllerWithBlock(msgStr: "Your review has been submitted successfully!", naviObj: self) { (true) in
                self.dismiss(animated: true, completion: nil)
                if self.previousObj != nil{
                    self.previousObj.navigationController?.popToRootViewController(animated: true)
                }
            }
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
