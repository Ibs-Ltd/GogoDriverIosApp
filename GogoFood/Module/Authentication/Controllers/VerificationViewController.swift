//
//  VerificationViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 08/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class VerificationViewController: BaseViewController<SignupData> {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var verifyCodeOutlet: UIButton!
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    
    @IBOutlet weak var resendCode: UIButton!
    
    // In case of FB login
    var name: String!
    var image: String!
    private let repo = AuthenticationRepository()
    var timer: Timer!
    var currentTime: Int! = 30
    
    let red: [NSAttributedString.Key: Any] = [
        .foregroundColor: AppConstant.primaryColor
    ]
    
    let blue: [NSAttributedString.Key: Any] = [
        .foregroundColor: AppConstant.appBlueColor as Any
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        otpTextField1.becomeFirstResponder()
        otpTextField1.text = nil
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        otpTextField1.keyboardType = .numberPad
        
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self
        startTimer()
        createNavigationLeftButton(nil)
        verifyCodeOutlet.layer.cornerRadius = verifyCodeOutlet.frame.height / 2
        
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: otpTextField1.frame.height - 1, width: otpTextField1.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(named: "roundboxColor")?.cgColor
        otpTextField1.borderStyle = UITextField.BorderStyle.none
        otpTextField1.layer.addSublayer(bottomLine)
        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: otpTextField2.frame.height - 1, width: otpTextField2.frame.width, height: 1.0)
        bottomLine1.backgroundColor = UIColor(named: "roundboxColor")?.cgColor
        otpTextField2.borderStyle = UITextField.BorderStyle.none
        otpTextField2.layer.addSublayer(bottomLine1)
        
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: otpTextField3.frame.height - 1, width: otpTextField3.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor(named: "roundboxColor")?.cgColor
        otpTextField3.borderStyle = UITextField.BorderStyle.none
        otpTextField3.layer.addSublayer(bottomLine2)
        
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0.0, y: otpTextField4.frame.height - 1, width: otpTextField4.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor(named: "roundboxColor")?.cgColor
        otpTextField4.borderStyle = UITextField.BorderStyle.none
        otpTextField4.layer.addSublayer(bottomLine3)
        
        otpTextField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOtp()
    }
    
    func showOtp() {
        if self.data?.otp != 0{
            self.showAlert(msg: "For testing purpose please Enter otp \(self.data?.otp ?? 0).")
        }
    }
    
    
    func startTimer() {
        if currentTime != 0 {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
    }
    
    @objc func update () {
        currentTime -= 1
        let text = String(format: "%02d", currentTime)
        resendCode.setAttributedTitle(self.setResneddButton(time: text), for: .normal)
        if currentTime == 0 {
            timer.invalidate()
        }
    }
    
    
    
    @IBAction func verifyCodeAction(_ sender: Any) {
        self.repo.verify(otp: self.createOTP(), forUser: self.data?.mobile ?? "", userStatus: data?.status ?? "", deviceToken: CurrentSession.getI().localData.fireBaseToken, countryCode:self.data?.countryCode ?? ""){ data in
            CurrentSession.getI().localData.profile = data.profile
            CurrentSession.getI().localData.token = data.token
            CurrentSession.getI().saveData()
            self.afterVerifyCode()
        }
    }
    
    func createOTP() -> Int {
        if otpTextField1.text!.isEmpty || otpTextField2.text!.isEmpty || otpTextField3.text!.isEmpty || otpTextField4.text!.isEmpty {
            self.showAlert(msg: "Please enter a valid verfication code")
            return 0
        }
        let OTP =  self.otpTextField1.text! + self.otpTextField2.text! + self.otpTextField3.text!  + self.otpTextField4.text!
        return Int(OTP)!
    }
    
    
    func afterVerifyCode() {
        timer.invalidate()
        let sd = CurrentSession.getI().localData.profile
        if sd?.user_status == "existing" {
             self.navigationController?.present(.driverTab, on: .main)
        }else{
            let vc: DriverEditProfileViewController = self.getViewController(.driverEditProfile, on: .setting)
            vc.data = self.data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func onResndCode(_ sender: UIButton) {
        if let data = self.data {
            repo.loginUser(data.mobile, countryCode: data.countryCode) { (data) in
                self.timer.invalidate()
                self.currentTime = 30
                self.startTimer()
                self.data = data
                self.otpTextField1.becomeFirstResponder()
                self.otpTextField1.text = ""
                self.otpTextField2.text = ""
                self.otpTextField3.text = ""
                self.otpTextField4.text = ""
                self.showOtp()
            }
        }
//        if currentTime != 0 { return }
//        if let data = self.data {
//            repo.loginUser(data.mobile, countryCode: data.countryCode) { (data) in
//                self.timer.invalidate()
//                self.currentTime = 30
//                self.startTimer()
//                self.data = data
//                self.otpTextField1.becomeFirstResponder()
//                self.showOtp()
//            }
//        }
    }   
    
    
    func setResneddButton(time: String) -> NSMutableAttributedString {
        
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: AppConstant.primaryColor]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: AppConstant.appBlueColor]
        
        let firstString = NSMutableAttributedString(string: "Don't get code?  ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Resend Code ", attributes: secondAttributes)
        let thirdString = NSAttributedString(string: "00: \(time)s", attributes: firstAttributes)
        firstString.append(secondString)
        firstString.append(thirdString)
        return firstString
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case otpTextField1:
                otpTextField2.isEnabled = true
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.isEnabled = true
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.isEnabled = true
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField4.isEnabled = true
                otpTextField4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case otpTextField1:
                otpTextField1.becomeFirstResponder()
            case otpTextField2:
                otpTextField2.isEnabled = false
                otpTextField1.becomeFirstResponder()
            case otpTextField3:
                otpTextField3.isEnabled = false
                otpTextField2.becomeFirstResponder()
            case otpTextField4:
                otpTextField4.isEnabled = false
                otpTextField3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    
    
}


extension VerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        textField.text = ""
//        if textField.text == "\u{200B}"{
//            textField.text = ""
//        }
        
        return (textField.text!.count < 1)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "\u{200B}"
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 30), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
