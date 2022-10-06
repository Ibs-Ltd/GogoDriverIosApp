//
//  RegisterViewController.swift
//  User
//
//  Created by YOGESH BANSAL on 20/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import FlagPhoneNumber

#if User
import FBSDKCoreKit
import FBSDKLoginKit
#endif


class RegisterViewController: BaseViewController<SignupData>, FPNTextFieldDelegate, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var numberTextField: FPNTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var socialLoginInfo: UIStackView!
    @IBOutlet weak var loginWithSocialMedia: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    private let repo = AuthenticationRepository()
    var isValid = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        socialLoginInfo.isHidden = false
        #if Restaurant
        loginButton.isHidden = true
        socialLoginInfo.isHidden = true
        scrollView.isScrollEnabled = false
        #elseif Driver
        loginButton.isHidden = true
        socialLoginInfo.isHidden = true
        scrollView.isScrollEnabled = false
        #endif
        
        confirmImage.isHidden = true
        numberTextField.keyboardType = .phonePad
        
        nextBtn.layer.cornerRadius = nextBtn.frame.height / 2
        numberTextField.delegate = self
        
        scrollView.delegate = self
        
        confirmImage.layer.cornerRadius = confirmImage.frame.height / 2
    
        numberTextField.flagButtonSize  = CGSize(width: 65, height: 20)
        numberTextField.flagButton.isUserInteractionEnabled = true
 //       numberTextField.setFlag(key: .IN)
//        numberTextField.text = "9376614143"
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            scrollView.setContentOffset(CGPoint(x: 0, y: 30), animated: true)
            print(keyboardHeight)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if !isValid {
            self.showAlert(msg: "Please enter a valid number")
            return
        }
        repo.loginUser(
            numberTextField.getRawPhoneNumber()
            ?? "", countryCode:numberTextField.selectedCountry!.phoneCode){ (data) in
            let vc: VerificationViewController = self.getViewController(.verifyOtp, on: .authentication)
            vc.data = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transparentNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        visibleNavigationBar()
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    #if User
    @IBAction func facebookLoginButton(_ sender: UIButton) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    guard let userData = result as? Dictionary<String, Any> else{return}
                    guard let name = userData["name"] as? String else{return}
                    guard let picture = userData["picture"] as? Dictionary<String, Any> else {return}
                    guard let imageData = picture["data"] as? Dictionary<String, Any>, let url = imageData["url"] as? String else{return}
                    let vc: FBLoginViewController = self.getViewController(.fbLogin, on: .authentication)
                    vc.image = url
                    vc.name = name
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
            })
        }
    }
    
    #endif
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        confirmImage.isHidden = !isValid
        self.isValid = isValid
    }
    
    func fpnDisplayCountryList() {
        
    }
    
}
