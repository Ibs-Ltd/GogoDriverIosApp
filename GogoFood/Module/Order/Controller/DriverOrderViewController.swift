//
//  DriverOrderViewController.swift
//  Driver
//
//  Created by MAC on 04/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class DriverOrderViewController: BaseTableViewController<OrderData> {
    
    private let repo = OrderRepository()
    private var orderDetail: OrderDetailData!
    private var cartItem: [CartItemData] = []
    var restaurant_id: RestaurantProfileData?

    // RestaurantView
    
    @IBOutlet weak var lbl_promoAmount: UILabel!
    @IBOutlet weak var lbl_promo: UILabel!
    @IBOutlet weak var pickedUpBtn: UIButton!
    @IBOutlet weak var subTotalTitleLbl: UILabel!
    @IBOutlet weak var howEverLbl: UILabel!
    @IBOutlet weak var totalPayTitleLbl: UILabel!
    @IBOutlet weak var restaurantDetailTitleLbl: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantDetail: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    // Regarding order
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var orderInfoHeightConstraint: NSLayoutConstraint!
    
    var index = -1

    override func viewDidLoad() {
        nib.append(TableViewCell.orderItemTableViewCell.rawValue)
        super.viewDidLoad()
        createNavigationLeftButton(NavigationTitleString.receiptRestaurant.localized())
        repo.getOrderDetail(self.data!) { (item) in
            self.orderDetail = item
            //Naresh
            //self.setOrderData(item.order)
            self.setOrderData(item.orderInfoData)
        }
        restaurantDetailTitleLbl.text = "Restaurant Detail".localized()
        subTotalTitleLbl.text = "Subtotal".localized()
        totalPayTitleLbl.text = "Total Payment".localized()
        pickedUpBtn.setTitle("PICKED UP".localized(), for: .normal)
        howEverLbl.text = "However deliver will auto confirm after check out from restaurant in 15 seconds".localized()
        // Do any additional setup after loading the view.
    }
    
    
    func setOrderData(_ data: OrderInfoData?) {
        
        var produtPrice = 0.0

        guard let restWise = data?.restaurant_wise else {
            return
        }
        self.restaurant_id = restWise[index].restaurant_id

        let carts = data?.restaurant_wise?[index].cart_id ?? []
        for value in carts{
            
            if let _ = data?.coupon_code,let _ = data?.coupon_discount,let _ = data?.coupon_type{
             //   let addupValue = Double(data?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                var total = value.calculateTotalPriceWithAddUp()
               // let percent = total *  addupValue / 100
              //  total = total + percent
                produtPrice =  produtPrice + total
                
            }else{
                if value.dish_id?.discount_type == "none"{
                    //  let addupValue = Double(data?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                    var total = (value.getTotalPrice().replacingOccurrences(of: "$", with: "").toDouble()) ?? 0.0
                  //  let percent = total *  addupValue / 100
                //    total = total + percent
                    produtPrice =  produtPrice + total
                }else{
                    let addupValue = Double(data?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                    var total = value.calculateTotalPrice()
//                    let percent = total *  addupValue / 100
//                    total = total + percent
                    produtPrice =  produtPrice + total
                }
            }
        }
        let total =    String(format: "%.2f", produtPrice)
        self.totalAmount.text = total
        self.subTotal.text = total
        
        
        
        if let _ = self.data?.order_id?.coupon_code,let discount = self.data?.order_id?.coupon_discount,let type = self.data?.order_id?.coupon_type{
            if type == "percent"{
                let percent =   (produtPrice * Double(discount) / 100)
                self.lbl_promoAmount.text =    "$" +  String(format: "%.2f", percent)
                let subtoal =    produtPrice - percent
                let total =    String(format: "%.2f", subtoal)
                self.totalAmount.text = total
                self.subTotal.text = total

            }else{
                let subtotal =  (produtPrice - Double(discount))
            }
        }
        
        
        
        
//        if let d = data{
//        if let coupon = d.coupon_code,let couponType = d.coupon_type,let coupon_discount = d.coupon_discount{
//            lbl_promo.text = "Promo Applied:\(coupon)"
//            if couponType == "percent"{
//                let totalDish = Double(d.dish_price ?? 0)
//                let discount = Double(coupon_discount)
//                let percent = (totalDish * discount) / 100.0
//                self.lbl_promoAmount.text =    "$" +  String(format: "%.2f", percent)
//                let total = totalDish - percent
//                let totalStr =    String(format: "%.2f", total)
//                self.totalAmount.text = "$" + totalStr
//                self.subTotal.text = "$" + totalStr
//            }else{
//                let totalDish = d.dish_price ?? 0
//                let percent = totalDish - coupon_discount
//                self.lbl_promoAmount.text =    "$" +  String(format: "%.2f", percent)
//                let total = totalDish - percent
//                let totalStr =    String(format: "%.2f", total)
//                self.totalAmount.text = "$" + totalStr
//                self.subTotal.text = "$" + totalStr
//            }
//        }else{
//            let dataa = data?.restaurant_wise?[0].cart_id
//            let totall = dataa?.compactMap({$0.calculateTotalPrice()}).reduce(0, +) ?? 0
////            let dishprice  = Double(data?.dish_price ?? 0)
//            let total =    String(format: "%.2f", totall)
//            self.totalAmount.text = total
//            self.subTotal.text = total
//        }
//    }
    
        ServerImageFetcher.i.loadProfileImageIn(restaurantImage, url: data?.restaurant_wise?[index].restaurant_id?.getProfileImagerUrl() ?? "")
        restaurantDetail.text = data?.restaurant_wise?[index].restaurant_id?.name ?? ""
        restaurantAddress.text = data?.restaurant_wise?[index].restaurant_id?.getCompleteAddress(secure: false)
        self.cartItem = data?.restaurant_wise?[index].cart_id ?? []
        self.tableView.reloadData()
    }
    
    
    
    
    @IBAction func modifyView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.5) {
            self.orderInfoHeightConstraint.constant = sender.isSelected ? 0 : 370
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func onPickOrder(_ sender: UIButton) {
        repo.confirmPickup(self.index, order: self.orderDetail.orderInfoData) {
            let n: Int! = self.navigationController?.viewControllers.count
            if let previousVC = self.navigationController?.viewControllers[n-2] as? DriverMapViewController{
                previousVC.data?.order_id?.restaurant_wise![0].updateStatus(newStatus: "picked_up")
                previousVC.setOrderView(previousVC.data!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

    //Mark: - TableView Methods
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath) as! OrderItemTableViewCell
        cell.resturentWise = self.restaurant_id
        cell.initView(withData: self.cartItem[indexPath.row])
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItem.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
