//
//  ViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 07/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class FBLoginViewController: BaseViewController<SignupData>, FPNTextFieldDelegate {

   
    @IBOutlet weak var numberTextField: FPNTextField!
    
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var confirmImageView: UIImageView!
    private let repo = AuthenticationRepository()
    
     var isValid = false
    var name: String!
    var image: String!
    
    override func viewDidLoad() {
        //visibleNavigationBar()
        transparentNavigationBar()
        super.viewDidLoad()
        confirmImageView.isHidden = true
        nextBtnOutlet.layer.cornerRadius = nextBtnOutlet.frame.height / 2

        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .red
        

        confirmImageView.layer.cornerRadius = confirmImageView.frame.height / 2
        
       
     
        numberTextField.delegate = self
        numberTextField.flagButton.isUserInteractionEnabled = false
        self.createNavigationLeftButton(nil)
        
    }


    @IBAction func nextBtnAction(_ sender: Any) {
        if !isValid {
            self.showAlert(msg: "Please Enter a Valid phone number")
            return
        }
        
        repo.loginUser(numberTextField.text!, countryCode:numberTextField.selectedCountry!.phoneCode) { (data) in
            let vc: VerificationViewController = self.getViewController(.verifyOtp, on: .authentication)
            
            vc.data = data
            vc.image = self.image
            vc.name = self.name
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        
    }

   
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        confirmImageView.isHidden = !isValid
        self.isValid = isValid
    }
    
    func fpnDisplayCountryList() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visibleNavigationBar()
    }
    
}



