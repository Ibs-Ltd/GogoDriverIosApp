//
//  AddAmountViewController.swift
//  User
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class AddAmountViewController: BaseViewController<BaseData>, SBCardPopupContent {

    @IBOutlet var amountTxt : UITextField!
    private let repo = MapRepository()
    weak var popupViewController: SBCardPopupViewController?
    
    var previousVCOBj : InviteDetailViewController!
    let allowsTapToDismissPopupCard = true
    let allowsSwipeToDismissPopupCard = true
    
    static func create(vcOBj : InviteDetailViewController) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddAmountViewController") as! AddAmountViewController
        viewController.previousVCOBj = vcOBj
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(sender: UIButton){
        popupViewController?.close()
    }

    @IBAction func sendButtonPressed(sender: UIButton){
        if self.amountTxt.text == ""{
            showAlert(msg: "Please enter amount!")
        }else{
            self.repo.addBalanceToWallet(self.amountTxt.text!) { (data) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.popupViewController?.close()
                    self.previousVCOBj.callRefferListAPI()
                })
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
