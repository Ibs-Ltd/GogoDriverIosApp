//
//  OrderItemTableViewCell.swift
//  Restaurant
//
//  Created by YOGESH BANSAL on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: BaseTableViewCell<CartItemData> {
    
//    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: AppStepper!
    @IBOutlet weak var chooseOptionButton: UIButton!
    var onTapToReject: (() -> Void)!
    @IBOutlet weak var itemStatusButtonView: UIView!
    
    var resturentWise : RestaurantProfileData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func initViewForDetail() {
        #if User
        let setForUser = true
        #else
        let setForUser = false
        #endif
        //rejectButton.isHidden = setForUser
        chooseOptionButton.isHidden = setForUser
        quantityLabel.isHidden = setForUser
        stepper.isHidden = !setForUser
    }
    
    func initViewForHistoryDetail() {
//        rejectButton.isHidden = true
        chooseOptionButton.isHidden = true
        quantityLabel.isHidden = false
        stepper.isHidden = true
    }
    
    override func initView(withData: CartItemData) {
        super.initView(withData: withData)
        initViewForDetail()
        setViewForCart()
        
    }
    
    private func setViewForCart() {
        if let d = self.data?.first {
            if let product = d.dish_id {
                #if User
                self.stepper.dish = product
                stepper.showFromCart = true
                stepper.cartItem = d
                #else
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    if d.hasRejecetd {
//                        self.rejectButton.backgroundColor = AppConstant.primaryColor
//                        self.rejectButton.setTitle("Cancelled", for: .normal)
//                        self.rejectButton.isUserInteractionEnabled = false
                    }else if d.status == "rejected by restaurant" {
//                        self.rejectButton.backgroundColor = AppConstant.primaryColor
//                        self.rejectButton.setTitle("Cancelled", for: .normal)
//                        self.rejectButton.isUserInteractionEnabled = false
                    }else{
//                        self.rejectButton.backgroundColor = AppConstant.appYellowColor
//                        self.rejectButton.setTitle("Reject", for: .normal)
//                        self.rejectButton.isUserInteractionEnabled = true
                    }
                })
                #endif
                if product.dish_images != nil{
                    self.foodImage.setImage(product.dish_images?[0] ?? "")
                }
//                ServerImageFetcher.i.loadImageIn(self.foodImage, url: product.dish_images[0] ?? "")
                self.foodImage.contentMode = .scaleAspectFill
                self.itemLabel.text = product.name
                
                if product.discount_type == "none"{
                    
                    let addupValue = Double(self.resturentWise?.add_up_value ?? 0)
                    var total = (d.getTotalPrice().replacingOccurrences(of: "$", with: "").toDouble()) ?? 0.0
                    let percent = total *  addupValue / 100
                    total = total + percent
                    let totalStr =    String(format: "%.2f", total)
                    self.priceLabel.text = "$ " + totalStr
                }else{
                    let addupValue = Double(self.resturentWise?.add_up_value ?? 0)
                    let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
                    let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.darkGray]               
                    var total = (d.calculateTotalPriceWithAddUp())
                    let percent = total *  addupValue / 100
                    total = total + percent
                    let totalStr =    String(format: "%.2f", total)
                    let attributedString1 = NSMutableAttributedString(string:String(format: "$ %@",totalStr), attributes:attrs1 as [NSAttributedString.Key : Any])
                    attributedString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString1.length))
                    var total1 = (d.getTotalPrice().replacingOccurrences(of: "$", with: "").toDouble()) ?? 0.0
                    let percent1 = total1 *  addupValue / 100
                    total1 = total1 + percent1
                    let totalStr1 =    String(format: "%.2f", total1)
                    let attributedString2 = NSMutableAttributedString(string:String(format: "\n%@","$ " + totalStr1), attributes:attrs2 as [NSAttributedString.Key : Any])
                    attributedString1.append(attributedString2)
                    self.priceLabel.attributedText = attributedString1
                    self.priceLabel.adjustsFontSizeToFitWidth = true
                }
                self.descriptionLabel.text = d.toppings?.compactMap({$0.addonId!.addonName! + " " + $0.topping_name!}).joined(separator: ",")
                self.chooseOptionButton.isHidden = product.options?.isEmpty ?? true
                self.quantityLabel.text = (d.quantity ?? 0).description
            }
        }
    }
    
    @IBAction func onSelectOption(_ sender: UIButton) {
        #if User
        stepper.showProductOption()
        #endif
    }
    @IBAction func onRejectItem(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.backgroundColor = AppConstant.primaryColor
        }else{
            sender.backgroundColor = AppConstant.appYellowColor
        }
        onTapToReject()
    }
}


extension UIImageView{
    
    func setImage(_ url:String){
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let imageURL = URL(string: urlString ?? "")
        self.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: ""))
    }
}
