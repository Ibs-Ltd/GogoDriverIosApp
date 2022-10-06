//
//  BaseViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 08/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import Reachability
import SVProgressHUD
import Alamofire

class BaseViewController<T: BaseData>: UIViewController {

    var isFetchingData = false
    var Title = ""
    var message = ""
    var data: T?
    
    private var isNetworkAvaialble = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  setBackground(color: UIColor.groupTableViewBackground)
        hideKeyboardWhenTappedAround()
        isNetworkAvaialble = checkNetworkConnectivity()
        // self.visibleNavigationBar()
        hideBotomBarOnPush()
    }
    
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func hideBotomBarOnPush() {
        //self.hidesBottomBarWhenPushed = true
    }
    
    func visibleNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = AppConstant.backgroundColor
        self.navigationController?.navigationBar.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }
        else{
            showAlert(msg: "Please connect to internet".localized)
        }
        // do some tasks..
        
        
        
       
       
        if let reachability = AppDelegate.sharedAppDelegate()?.reachability
        {
            NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func pushToLogin() {
    //        let vc: AuthenticationViewController = UIStoryboard(name: "UserOnBoarding", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
    //        vc.hidesBottomBarWhenPushed = true
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        _ = note.object as! Reachability
        
        if Connectivity.isConnectedToInternet() {
            if !isNetworkAvaialble {
                isNetworkAvaialble = true
                onNetworkEastablished()
            }
        } else {
            if isNetworkAvaialble {
                isNetworkAvaialble = false
                onNetworkLost()
            }
            
        }
    }
    
    func hideKeyboard() {
        dismissKeyboard()
    }
    
    func setBackground(color: UIColor)  {
        view.backgroundColor = color
    }
    
    func showAlert(msg:String) {
        let alert = UIAlertController.init(title: "Info", message: msg, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
     
    }
    
    
    
    func showLoader() {
        //       SVProgressHUD.setForegroundColor(UIColor.init(stringHex: CurrentSession.getI().localData.appColor.appBlueColor))
        SVProgressHUD.show(withStatus: "Loading...".localized)
        
        //LoaderUtils.i.showLoader(view)
    }
    
    static func hideLoader() {
        SVProgressHUD.dismiss()
        //LoaderUtils.i.hideLoader()
    }
    
    
    
    func onSucess(response: URLResponse?,string:String)  {
    }
    
    func onSucess(response: URLResponse?,data:Data) -> Bool {
        return false
        
    }
    
    func onNetworkEastablished() {
        
    }
    
    func onNetworkLost() {
        
    }
    
    func checkNetworkConnectivity() -> Bool {
        // return InternetConnectivity.isConnectedToNetwork()
        return Connectivity.isConnectedToInternet()
    }
    
    func checkNetworkConnectivityAndShowNoInternetDialog() -> Bool {
        if !checkNetworkConnectivity() {
            showsNointernetError()
            return false
        }
        return true
        
    }
    
    func showsNointernetError()  {
        let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        controller.addAction(ok)
        controller.addAction(cancel)
        
        present(controller, animated: true, completion: nil)
    }
    
    func onFailure(response: URLResponse?,connectionError:Error) {
       // showAlert(msg: MyStrings.getText(key: "error"))
    }
    
    @objc func  afterFetchingFavoritesItem(indexPath: IndexPath) {
        
    }
    //
    //
    //    func showAlertInformation(msg:String) {
    //        let alertController = UIAlertController(title: Title, message:
    //            message, preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
    //
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    
    
    
    func showAlerts(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK".localized, style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        DispatchQueue.main.async {
            self.view.addGestureRecognizer(tap)
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createNavigationLeftButton(_ withTitle: String?){
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = AppConstant.secondaryColor
        let backButton = UIBarButtonItem(image: UIImage(named: "backBtn"), style: .plain, target: self, action: #selector(tapOnLeftItem))
        //backButton.tintColor = AppConstant.secondaryColor
        self.navigationItem.leftBarButtonItem = backButton
        setNavigationTitleTextColor(withTitle)
    }
    
    func setNavigationTitleTextColor(_ title: String?) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:AppConstant.secondaryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = title?.uppercased()
    }
    
    @objc func tapOnLeftItem() {
    self.navigationController?.popViewController(animated: true)
    }
    
    #if User
    
    func addTrackingAndCartButton() {
         self.navigationItem.rightBarButtonItems = [createCartBarButton(), createTrackingBarButton()]
        
    }
    
    func addCartButton() {
      
            self.navigationItem.rightBarButtonItems = [createCartBarButton()]
            
        
    }
    
    func createTrackingBarButton() -> UIBarButtonItem {
       return UIBarButtonItem(image: UIImage(named: "live_track"), style: .plain, target: self, action: #selector(tapOnTrackingButtton))
       // trackButton.tintColor = AppConstant.primaryColor
        
    }
    
   
    
   private func createCartBarButton() -> UIBarButtonItem {
    let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
    filterBtn.setImage(UIImage(named: "emptyCart"), for: .normal)
    filterBtn.addTarget(self, action: #selector(tapOnCartButton), for: .touchUpInside)
    
    let lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: 15, height: 15))
    lblBadge.backgroundColor = AppConstant.primaryColor
    lblBadge.clipsToBounds = true
    lblBadge.layer.cornerRadius = 7
    lblBadge.textColor = UIColor.white
    lblBadge.font = UIFont.systemFont(ofSize: 10)
    lblBadge.textAlignment = .center
    lblBadge.text = CurrentSession.getI().localData.cart.cartItems.count.description
   lblBadge.isHidden = CurrentSession.getI().localData.cart.cartItems.isEmpty
    filterBtn.addSubview(lblBadge)
    
    
    return UIBarButtonItem(customView: filterBtn)
        // trackButton.tintColor = AppConstant.primaryColor
    }
 #endif
    func createNotificationBarButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "noticount.png"), for: .normal)
        button.addTarget(self, action: #selector(tapOnNotificationButtton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }
    
    @objc func tapOnNotificationButtton() {
        
    }
    
    @objc func tapOnTrackingButtton() {
    
    }
    
    @objc func tapOnCartButton() {
        #if User
        let vc: CartViewController = self.getViewController(.cart, on: .order)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        #endif
        
    }
    
    func pushViewController(_ vc: Controller, avaibleFor storyBoard: StoryBoard){
        let storyBoard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: vc.rawValue) as! BaseViewController
        
        self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
    func getViewController<T: BaseData, C: BaseViewController<T>> (_ vc: Controller, on sb: StoryBoard) -> C  {
        let storyBoard = UIStoryboard.init(name: sb.rawValue, bundle: nil)
        let view: C = storyBoard.instantiateViewController(withIdentifier: vc.rawValue) as! C
        return view
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onChangeCartItem(notification:)), name: Notification.Name("CartValueGetChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onChangeCartItem(notification:)), name: Notification.Name("ShowCart"), object: nil)
    }
    
    @objc func onChangeCartItem(notification: Notification) {
        #if User
        if notification.name.rawValue == "ShowCart" {
            let vc: CartViewController = self.getViewController(.cart, on: .order)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.addCartButton()
            
        }
        #endif
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CartValueGetChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onChangeCartItem(notification:)), name: Notification.Name("ShowCart"), object: nil)
    }
    
    deinit {
       removeNotification()
    }
    
}



@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
