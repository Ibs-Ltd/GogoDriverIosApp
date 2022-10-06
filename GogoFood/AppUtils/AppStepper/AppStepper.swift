//
//  IncrementButton.swift
//  GogoFood
//
//  Created by MAC on 18/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class AppStepper: BaseAppView {
    
    @IBOutlet weak private var increaseButton: UIButton!
    @IBOutlet weak private var decreaseButton: UIButton!
    @IBOutlet weak private var currrentNumber: UILabel!
    
    #if User
    private let repo = CartRepository()
    var onModifyItem: ((_ count: Int) -> Void)!
    var dish: ProductData!{
        didSet{
            let cart = CurrentSession.getI().localData.cart.cartItems.filter({$0.dish_id?.id == dish.id})
            self.setCount(cart.compactMap({$0.quantity ?? 0}).reduce(0, +))
        }
    }
    var selectedTopings: [Toppings] = []
    var hasToModify = true
    var showFromCart = false
    var cartItem: CartItemData! {
        didSet{
            //let cart = CurrentSession.getI().localData.cart.cartItems.filter({$0.dish_id?.id == cartItem.dish_id?.id})
            //self.setCount(cart.compactMap({$0.quantity ?? 0}).reduce(0, +))
            self.setCount(cartItem.quantity ?? 0)
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonSetup("AppStepper")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    
    
    
    @IBAction  func onChangeQuantity(_ sender: UIButton) {
        
        if (cartItem != nil) && showFromCart{
            let hasIncrease = (sender.tag == 1)
            repo.modifyQuantity(hasIncrease: hasIncrease, cartId: cartItem.id) { (d) in
               self.resetProperty()
            }
        }
        
        if (dish != nil) && !showFromCart {
            if sender.tag == 1 {
                if !(dish.options?.isEmpty ?? true) {
                    showChooseOption()
                }else{
                    addToCart()
                }
            }else{
                deleteDish()
            }
        }
        //onModifyItem(count)
    }
    
    
    private func setCount(_ count: Int) {
        
        self.currrentNumber.text = count.description
        
    }
    
    func showProductOption() {
        let sb = UIStoryboard(name: "Popup", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectOptionViewController") as! SelectOptionViewController
        
        if !self.showFromCart {
           self.dish.options?.forEach({$0.toppings?.forEach({$0.isSelected = false})})
        }
        vc.allItems = self.dish.options ?? []
        vc.showFromCart = self.showFromCart
        
        vc.onSelectToping = { topings in
            vc.dismiss(animated: true, completion: nil)
            self.selectedTopings = topings
            if self.showFromCart {
                self.repo.updateTopping(cartId: self.cartItem!.id, topping: topings.compactMap({$0.id}), onComplition: { (_) in
                    self.resetProperty()
                })
            }else{
                self.addToCart()
            }
        }
        let cardPopup = SBCardPopupViewController(contentViewController: vc)
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            cardPopup.backgroundOpacity = 0.2
            cardPopup.show(onViewController: topController)
            // topController should now be your topmost view controller
        }
        //        let window = AppDelegate.sharedAppDelegate()?.window?.rootViewController
        //        cardPopup.show(onViewController: window!)
    }
    
    func showChooseOption() {
        #if User
        let cart = CurrentSession.getI().localData.cart.cartItems.filter({$0.dish_id?.id == dish.id}).filter({!($0.dish_id?.options?.isEmpty ?? false)}).filter({!($0.toppings?.isEmpty ?? false)}).last
        if cart == nil {
            showProductOption()
            return
        }
        
        
        let sb = UIStoryboard(name: StoryBoard.order.rawValue, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Controller.chooseOrder.rawValue) as! OrderChoiceViewController
        vc.itemName = cart?.dish_id?.name
        vc.topping = cart!.toppings?.compactMap({$0.topping_name}).joined(separator: ",")
        vc.onChoose = {
            vc.dismiss(animated: true, completion: {
                self.showProductOption()
            })
            
        }
        
        vc.onRepeat = {
            vc.dismiss(animated: true, completion: {
                self.selectedTopings = cart!.toppings!
                self.addToCart()
            })
        }
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let card = SBCardPopupViewController(contentViewController: vc)
            card.show(onViewController: topController)
            // topController should now be your topmost view controller
        }
        #endif
        
    }
    
    
    func addToCart() {
        repo.appToCart(dishId: dish!, toppings: self.selectedTopings.compactMap({$0.id})) { (data) in
            CurrentSession.getI().localData.cart = data
            CurrentSession.getI().saveData()
            self.resetProperty()
        }
    }
    
    
    
    
    func deleteDish() {
        if (dish != nil){
            repo.removeDish(dish.id) { (d) in
                if !d.multiple {
                   
                    self.resetProperty()
                }else{
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        
                        let alert = UIAlertController(title: "Info", message: "This item has multiple customization added. Proceed to cart to remove item", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Go to cart", style: .default){(_) in
                            NotificationCenter.default.post(name: Notification.Name("ShowCart"), object: nil)
                            
                            })
                        topController.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    
                }
                
            }
        }
        
    }
    
    private func resetProperty() {
//        if self.showFromCart {
//            self.cartItem = CurrentSession.getI().localData.cart.cartItems.first(where: {$0.id == self.cartItem.id})
//        }else{
//            self.dish = {self.dish}()
//            
//        }
         NotificationCenter.default.post(name: Notification.Name("CartValueGetChanged"), object: nil)
    }
    
    
    // Related to the observer
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if (newWindow == nil){
            NotificationCenter.default.removeObserver(self, name: Notification.Name("CartValueGetChanged"), object: nil)
        }
    }
    
    override func didMoveToWindow() {
        //  NotificationCenter.default.addObserver(self, selector: #selector(self.onChangeCartItem(notification:)), name: Notification.Name("CartValueGetChanged"), object: nil)
    }
    
    @objc func onChangeCartItem(notification: Notification) {
        resetProperty()
    }
    #endif
}
