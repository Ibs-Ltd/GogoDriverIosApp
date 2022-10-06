//
//  RestaurantOrderTableViewCell.swift
//  Restaurant
//
//  Created by MAC on 02/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class RestaurantOrderTableViewCell: BaseTableViewCell<OrderData> {

    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var numberOfItem: UILabel!
    @IBOutlet weak var amount: UILabel!
 
    @IBOutlet weak var userPhoneNumber: UILabel!
    
    @IBOutlet weak var pendingChecking: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var onRejectOrder: (()-> Void)!
    private var timer: Timer!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRejectOrder(_ sender: UIButton) {
        onRejectOrder()
    }
    
    override func initView(withData: OrderData) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            if withData.getAutoCheckInTime() != "0m 0s"{
                 self.pendingChecking.text = withData.getAutoCheckInTime()
            }else{
             self.timer.invalidate()
            }
        }
        
        orderTime.text = TimeDateUtils.getAgoTime(fromDate: withData.getCreatedTime())
        orderIdLbl.text =  "#" + (withData.order_id?.id.toString())!
        amount.text = withData.order_id?.getOrderTotal()
        orderId.text = withData.user_id?.name ?? ""
        userPhoneNumber.text = withData.user_id?.mobile ?? ""
        ServerImageFetcher.i.loadProfileImageIn(userImage, url: withData.user_id?.profile_picture ?? "")
        self.userImage.contentMode = .scaleAspectFill
        numberOfItem.text = withData.cart_id?.count.description
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            if withData.getOrderStatus() == .accept{
                self.cellButton.setTitle("Accepted", for: .normal)
                self.cellButton.backgroundColor = AppConstant.tertiaryColor
                self.cellButton.isUserInteractionEnabled = false
            }else if withData.getOrderStatus() == .completed{
                self.cellButton.setTitle("Completed", for: .normal)
                self.cellButton.backgroundColor = AppConstant.appBlueColor
                self.cellButton.titleLabel!.adjustsFontSizeToFitWidth = true
                self.cellButton.isUserInteractionEnabled = false
            }else if withData.getOrderStatus() == .cancel{
                self.cellButton.setTitle("Cancelled", for: .normal)
                self.cellButton.backgroundColor = AppConstant.primaryColor
                self.cellButton.titleLabel!.adjustsFontSizeToFitWidth = true
                self.cellButton.isUserInteractionEnabled = false
            }else{
                self.cellButton.setTitle("Reject", for: .normal)
                self.cellButton.backgroundColor = AppConstant.appYellowColor
                self.cellButton.isUserInteractionEnabled = true
            }
        })
    }
}
