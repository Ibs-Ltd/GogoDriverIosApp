//
//  DriverOrderTableViewCell.swift
//  Driver
//
//  Created by MAC on 05/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import MapKit

class DriverOrderTableViewCell: BaseTableViewCell<OrderData> {
    @IBOutlet weak var orderId: UIButton!
    @IBOutlet weak var itemsInOrder: UILabel!
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var restaurantOne: UILabel!
    @IBOutlet weak var restaurantTwo: UILabel!
    
    @IBOutlet weak var restaurantThree: UILabel!
    @IBOutlet weak var autoRejectTimer: UILabel!
    
    @IBOutlet weak var deliveryAddress: UILabel!
    
    @IBOutlet weak var restaurant1Status: UILabel!
    
    @IBOutlet weak var restaurant2Status: UILabel!
    
    @IBOutlet weak var restaurant3Status: UILabel!
    
    @IBOutlet weak var paymentMode: UILabel!
    var onReviewOrder: ((_ hasAccept: Bool)-> Void)!
    var onRejectOrder: ((_ hasAccept: Int)-> Void)!

    
    @IBOutlet weak var acceptRejectButton: UIStackView!
    
    @IBOutlet weak var userAddress: UILabel!
    var isForAceptedOrder: Bool = false
    
    var onOrderTimeOut: (()-> Void)!

    private var timer: Timer?

    var isFromLiveOrder = false

    @IBOutlet weak var bottomViewConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reviewOrder(_ sender: UIButton) {
        onReviewOrder(sender.tag == 0)
    }
    @IBAction func rejectOrder(_ sender: UIButton) {
          onRejectOrder(sender.tag)
      }
    
    @objc func fetchData(_ sender:Timer){
        guard  let withData = sender.userInfo as? OrderData else{return}
//        if withData.getAutoCheckInTime() == "0m 1s"{
//            sender.invalidate()
//            self.onRejectOrder(0)
//        }else{
//            self.autoRejectTimer.text = withData.getAutoCheckInTime()
//            print(withData.getAutoCheckInTime())
//
//            if withData.getAutoCheckInTime().contains("-"){
//                sender.invalidate()
//                //self.onRejectOrder(0)
//            }
//        }
    }
    
    override func initView(withData: OrderData) {
        DispatchQueue.main.async {
            
            if self.isFromLiveOrder{
              //  self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchData(_:)), userInfo: withData, repeats: true)
            }else{
                self.autoRejectTimer.text = " "
                if self.timer != nil{
                    self.timer?.invalidate()
                }
            }
            
            self.hideLabels()
            self.orderTime.text = TimeDateUtils.getTime(fromDate: withData.createdOrderID ?? "")

            let distance = self.getDistance(withData.order_id?.delivery_address?.latitude ?? 0.0, longitude: withData.order_id?.delivery_address?.longitude ?? 0.0)
            
            self.acceptRejectButton.isHidden = self.isForAceptedOrder
            self.orderId.setTitle("Order ID".localized() + (withData.order_id?.id.description ?? "0"), for: .normal)
            self.totalAmount.text = withData.order_id?.getOrderTotal()
            self.itemsInOrder.text = distance
//            self.itemsInOrder.text = (withData.order_id?.getTotalItemInOrder() ?? "0") + " " + "Items".localized()
            //self.deliveryAddress.text = withData.order_id?.delivery_address?.address ?? ""
            self.deliveryAddress.text = withData.order_id?.user_id?.default_address?.address ?? "Address not added"
            if withData.order_id?.restaurant_wise?.indices.contains(0) ?? false {
                let restaurant = withData.order_id?.restaurant_wise?[0]
                self.restaurantOne.isHidden = false
                self.restaurant1Status.isHidden = false
                self.restaurantOne.text = restaurant?.restaurant_id?.name
                self.restaurant1Status.text = self.getStatusText(orderObj: restaurant!)
                self.restaurant1Status.backgroundColor = restaurant?.getColorForStatus()
            }
            if withData.order_id?.restaurant_wise?.indices.contains(1) ?? false {
                let restaurant = withData.order_id?.restaurant_wise?[1]
                self.restaurantTwo.isHidden = false
                self.restaurant2Status.isHidden = false
                self.restaurantOne.text = restaurant?.restaurant_id?.name
                self.restaurant2Status.text = self.getStatusText(orderObj: restaurant!)
                self.restaurant2Status.backgroundColor = restaurant?.getColorForStatus()
            }
            if withData.order_id?.restaurant_wise?.indices.contains(2) ?? false {
                let restaurant = withData.order_id?.restaurant_wise?[2]
                self.restaurantThree.isHidden = false
                self.restaurant3Status.isHidden = false
                self.restaurantThree.text = restaurant?.restaurant_id?.name
                self.restaurant3Status.text = self.getStatusText(orderObj: restaurant!)
                self.restaurant3Status.backgroundColor = restaurant?.getColorForStatus()
            }
            self.paymentMode.text = "Cash Payment".localized()
        }
    }
    
    
    
    
    func getDistance(_ latitude:Double,longitude:Double) -> String {
        let coordinate₀ = CLLocation(latitude: UserDefaults.standard.value(forKey: "current_latitude") as? Double  ?? 0, longitude: UserDefaults.standard.value(forKey: "current_latitude") as? Double ?? 0)
        let coordinate₁ = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)/1000
        let distnace = String(format: "%.2fkm",distanceInMeters)
        return distnace
    }
    
    
    
    func getStatusText(orderObj : OrderData) -> String {
        var tmpStr = ""
        if orderObj.getOrderStatus() == .accept{
            tmpStr = " Accepted "
        }else if orderObj.getOrderStatus() == .completed || orderObj.getOrderStatus() == .delivered || orderObj.getOrderStatus() == .dispatched{
            tmpStr = " Completed "
        }else if orderObj.getOrderStatus() == .cancel{
            tmpStr = " Cancelled "
        }else if orderObj.getOrderStatus() == .driverAssigned{
            tmpStr = " Accepted "
        }else if orderObj.getOrderStatus() == .pickedUp{
            tmpStr = " Picked Up "
        }else if orderObj.getOrderStatus() == .pending{
            tmpStr = " Pending "
        }else if orderObj.getOrderStatus() == .arrivedToRes{
            tmpStr = " Arrived To Resturant "
        }else{
            tmpStr = String(format: "  %@  ", orderObj.getOrderStatus().rawValue.capitalized)
        }
        return tmpStr
    }
    
    func hideLabels() {
        self.restaurantOne.isHidden = true
        self.restaurant1Status.isHidden = true
        self.restaurantTwo.isHidden = true
        self.restaurant2Status.isHidden = true
        self.restaurantThree.isHidden = true
        self.restaurant3Status.isHidden = true
        
    }
    

}
