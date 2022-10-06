//
//  OrderViewController.swift
//  GogoFood
//
//  Created by MAC on 29/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class OrderViewController: BaseTableViewController<OrderData>, BottomPopupDelegate {
//    @IBOutlet weak var userImage: UIImageView!
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var phoneNumber: UILabel!
//    @IBOutlet weak var address: UILabel!
//    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var vw_qrCode: UIView!
    private let repo = OrderRepository()
//    @IBOutlet weak var checkInTimeStack: UIStackView!
    @IBOutlet weak var img_qrCode: UIImageView!
    
//    @IBOutlet weak var buttonView: NSLayoutConstraint!
//    @IBOutlet weak var acceptButton: UIButton!
//    @IBOutlet weak var rejectButton: UIButton!
//    @IBOutlet weak var doneButton: UIButton!
//    @IBOutlet weak var finishButton: UIButton!
    
//    var previousVC : String!
//    var rejectItemStr : [String]!
    var orderDataDic : OrderData!
    var restuarentID = [RestaurantProfileData]()
    var paymentMode = ""


    override func viewDidLoad() {
        nib = [TableViewCell.orderItemTableViewCell.rawValue, TableViewCell.orderAmountTableViewCell.rawValue,
               TableViewCell.contactInfoTableViewCell.rawValue,
               TableViewCell.deliveryDetailTableViewCell.rawValue,
               TableViewCell.paymentMethodTableViewCell.rawValue]
        super.viewDidLoad()
        
        self.repo.getOrderDetail(self.orderDataDic) { (data) in
            print(data)
            self.data = data.orderInfo
            self.paymentMode = data.orderInfoData.payment_method ?? ""
            self.tableView.reloadData()
            
            
            
            if let resturent = self.data?.restaurantWise {
                for value in resturent.enumerated(){
                    if let cartID = value.element.cartId{
                        for _ in cartID{
                            self.restuarentID.append(value.element.restaurantId!)
                        }
                    }
                }
            }
            
            
            
            
        }
        self.createNavigationLeftButton(NavigationTitleString.receiptCustomer)
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.vw_qrCode.alpha = 0.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return UITableView.automaticDimension
        }else if indexPath.section == 2 {
            return 110
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.data {
            return 5
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.data?.restaurant_wise?.compactMap({$0.cart_id?.count}).reduce(0, +) ?? 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return getOrderItemCell(indexPath)
        }else if indexPath.section == 1 {
            return getOrderAmountCell(indexPath)
        }else if indexPath.section == 2 {
            return getContactTableCell(indexPath)
        }else if indexPath.section == 3 {
            return getDeliveryDetailTableCell(indexPath)
        }
        return getPaymentMethodCell(indexPath)
    }
    
    private func getOrderItemCell(_ indexPath: IndexPath) -> OrderItemTableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath) as! OrderItemTableViewCell
        if let _ = self.data {
            cell.resturentWise =  self.restuarentID.count > 0  ?  self.restuarentID[indexPath.row] : RestaurantProfileData()
            let withData = self.data?.restaurant_wise?.compactMap({$0.cart_id}).reduce([], +)
            cell.initView(withData: withData?[indexPath.row] ?? CartItemData())
            cell.initViewForHistoryDetail()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func getOrderAmountCell(_ indexPath: IndexPath) -> OrderAmountTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib[1], for: indexPath) as! OrderAmountTableViewCell
        if let _ = self.data {
            cell.subTotalLabel.text = String(format: "$ %.2f", subTotalprodutPrice())
            cell.deliveryLabel.text = String(format: "$ %.2f", self.data!.delivery_charges ?? 0.0)
            cell.vatLabel.text = String(format: "$ %.2f", VAT())
            cell.totalAmtLabel.text = String(format: "$ %.2f", self.total())
            cell.couponCode.text  = String(format: "$ %.2f", self.coupon().1)
            let driverEarning = Double(self.data?.driver_earning ?? "0.0")
            cell.driverEarning.text =  String(format: "$ %.2f", driverEarning ?? 0.0)
        }
        cell.CouponBtn.setTitle("Coupon Discount:\(self.coupon().0)", for: .normal)
        cell.removeCouponBtn.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    private func getContactTableCell(_ indexPath: IndexPath) -> ContactInfoTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ContactInfoTableViewCell
        if let _ = self.data {
            cell.initView(withData: (self.data?.user_id!)!)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func getDeliveryDetailTableCell(_ indexPath: IndexPath) -> DeliveryDetailTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DeliveryDetailTableViewCell
        if let _ = self.data {
            cell.addressLabel.text = self.data!.user_id?.default_address?.address ?? "Address not found"
            cell.itemLabel.text = self.data!.restaurantWise![0].restaurantId?.name
            
            let distance = self.data?.restaurantWise?.compactMap({$0.distance}).reduce(0, +) ?? 0.0
            cell.distanceLabel.text = String(format: "%.2f Km", distance)
            
            cell.priceLabel.isHidden = true
            cell.distanceLabel.isHidden = false
            cell.arrowImage.isHidden = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func getPaymentMethodCell(_ indexPath: IndexPath) -> PaymentMethodTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! PaymentMethodTableViewCell
        
        if self.paymentMode == "wallet"{
            cell.wallet.isSelected = true
            cell.wallet.isHidden = false
            cell.COD.isHidden = true
        }else{
            cell.COD.isSelected = true
            cell.wallet.isHidden = true
            cell.COD.isHidden = false
        }
        
        cell.amountLabel.text = String(format: "$ %.2f", self.total())
        cell.tapOnPaymentButton = {
            self.repo.confirmDelivery((self.data?.id.toString() ?? ""), onDone: {
                print("tapOnPaymentButton")
                self.navigationController?.popToRootViewController(animated: true)
            }) { (error) in
                if error == "User has not confirmed recieving" && self.paymentMode == "wallet"{
                    let image = self.generateQRCode(from: "\(self.data?.id ?? 0)")
                    self.vw_qrCode.alpha = 1.0
                    self.img_qrCode.image = image
                }
            }
            
            
            
            
//            self.repo.confirmDelivery((self.data?.id.toString())!) {
//                print("tapOnPaymentButton")
//                self.navigationController?.popToRootViewController(animated: true)
//            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func subTotalprodutPrice() -> Double {
                
        var produtPrice = 0.0
        guard let restWise = self.data?.restaurant_wise else {
            return 0.0
        }

        for (index,_) in restWise.enumerated(){
            let carts = self.data?.restaurant_wise?[index].cart_id ?? []
            
            for value in carts{
                
                if let _ = self.data?.coupon_code,let _ = self.data?.coupon_discount,let _ = self.data?.coupon_type{
                    let addupValue = Double(self.data?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                    var total = value.calculateTotalPriceWithAddUp()
                    let percent = total *  addupValue / 100
                    total = total + percent
                    produtPrice =  produtPrice + total
                    
                }else{
                    if value.dish_id?.discount_type == "none"{
                        let addupValue = Double(self.data?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                        var total = (value.getTotalPrice().replacingOccurrences(of: "$", with: "").toDouble()) ?? 0.0
                        let percent = total *  addupValue / 100
                        total = total + percent
                        produtPrice =  produtPrice + total
                    }else{
                        let addupValue = Double(self.data?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                        var total = value.calculateTotalPrice()
                        let percent = total *  addupValue / 100
                        total = total + percent
                        produtPrice =  produtPrice + total
                    }
                }
                
            }
        }
        return produtPrice
    }
    
    private func subTotalprodutPriceForVAT() -> Double {
        
        let carts = self.data?.restaurant_wise?[0].cart_id ?? []
        var produtPrice = 0.0
        
        for value in carts{
                let addupValue = Double(self.data?.restaurant_wise?[0].restaurant_id?.add_up_value ?? 0)
                var total = (value.getTotalPrice().replacingOccurrences(of: "$", with: "").toDouble()) ?? 0.0
                let percent = total *  addupValue / 100
                total = total + percent
                produtPrice =  produtPrice + total
        }
        
        return produtPrice
    }
    
    private func VAT() -> Double{
        let subTotal = subTotalprodutPrice()
        if let tax_applicable = self.data?.restaurant_wise?[0].tax_applicable , tax_applicable == "yes", let taxPercent = self.data?.restaurant_wise?[0].tax_percent {
            let tax = subTotal *  taxPercent / 100.0
            return tax
        }
        return 0
    }
    private func coupon()->(String,Double){
        if let coupon = self.data?.coupon_code,let discount = self.data?.coupon_discount,let type = self.data?.coupon_type{
            let subTotal = self.subTotalprodutPrice()
            if type == "percent"{
                return  (coupon,(subTotal * discount / 100))
            }else{
                return  (coupon,(subTotal - discount ))
            }
        }else{
            return ("",0.0)
        }
    }
    private func delivery() -> Double{
        return self.data?.delivery_charges ?? 0.0
    }
    
    private func total() -> Double{
        return subTotalprodutPrice() + VAT()  + delivery() -  coupon().1
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
