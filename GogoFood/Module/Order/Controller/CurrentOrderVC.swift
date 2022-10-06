//
//  OrderViewController.swift
//  GogoFood
//
//  Created by MAC on 29/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class CurrentOrderVC: BaseTableViewController<OrderData>, BottomPopupDelegate {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    private let repo = OrderRepository()
    @IBOutlet weak var checkInTimeStack: UIStackView!
    
    @IBOutlet weak var buttonView: NSLayoutConstraint!
//    @IBOutlet weak var acceptButton: UIButton!
//    @IBOutlet weak var rejectButton: UIButton!
//    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var rejectItemStr : [String]!
    override func
        viewDidLoad() {
        nib = [TableViewCell.orderItemTableViewCell.rawValue,
               TableViewCell.orderAmountTableViewCell.rawValue
        ]
        super.viewDidLoad()
        setView()
        self.createNavigationLeftButton(NavigationTitleString.completeOrder)
    }
    
    func setView() {
        if let d = self.data {
            self.name.text = d.order_id!.user_id?.name ?? ""
            self.phoneNumber.text = d.order_id!.user_id?.getPhoneNumber(secure: true)
            self.orderDate.text = TimeDateUtils.getDataWithTime(fromDate: d.order_id!.getCreatedTime())
            self.address.text = d.order_id!.user_id?.getCompleteAddress(secure: true)
            ServerImageFetcher.i.loadProfileImageIn(userImage, url: d.order_id!.user_id?.profile_picture ?? "")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let d = self.data {
            if d.getOrderStatus() == .completed {
                return 2
            }else if d.getOrderStatus() == .cancel {
                return 2
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0
            ? self.data?.order_id?.restaurant_wise![0].cart_id?.count ?? 0
            : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return  indexPath.section == 0
            ? getOrderItemCell(tableView, indexPath: indexPath)
            : getOrderAmount(tableView, indexPath: indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    private func getOrderItemCell(_ tableView: UITableView, indexPath: IndexPath) -> OrderItemTableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: nib[indexPath.section], for: indexPath) as! OrderItemTableViewCell
        c.initView(withData: (self.data?.order_id?.restaurant_wise![0].cart_id![indexPath.row])!)
        c.onTapToReject = {
            self.rejectItem(indexPath)
        }
        
        if let d = self.data{
            if d.getOrderStatus() != .pending {
//                c.rejectButton.isHidden = true
            }
        }
        
        return c
    }
    
    func rejectItem(_ indexPath: IndexPath) {
        
    }
    
    private func getOrderAmount(_ tableView: UITableView, indexPath: IndexPath) -> OrderAmountTableViewCell {
        let c  = tableView.dequeueReusableCell(withIdentifier: nib[indexPath.section], for: indexPath) as! OrderAmountTableViewCell
        let cartData = CartData()
        cartData.cartItems = self.data!.cart_id ?? []
        c.initView(withData: cartData)
        c.setViewForDetail()
        
        return c
    }
    
    @IBAction func finishOrderButtonCllicked(_ sender: UIButton) {
        
//        repo.orderFinish((self.data!.order_id?.id.toString())!) {
//            oneButtonAlertControllerWithBlock(msgStr: "Your order finished successfully!", naviObj: self) { (true) in
//                guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptViewController") as? ReceiptViewController else { return }
//                popupVC.orderDic = self.data!
//                popupVC.height = 650
//                popupVC.topCornerRadius = 20
//                popupVC.presentDuration = 0.33
//                popupVC.dismissDuration = 0.33
//                popupVC.popupDelegate = self
//                popupVC.shouldDismissInteractivelty = false
//                popupVC.previousObj = self
//                self.present(popupVC, animated: true, completion: nil)
//            }
//        }
    }
    
    @IBAction func rejectOrder(_ sender: UIButton) {
//        let alert = UIAlertController.init(title: "Reject Order", message: "Really want to reject order", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(
//            UIAlertAction(title: "Reject", style: .default, handler: { (_) in
//                self.repo.rejectOrder(id: self.data?.id ?? 0) {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            })
//        )
//        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneRejectOrder(_ sender: UIButton) {
//        let vc: RejectionReasonViewController = self.getViewController(.reject, on: .order)
//        vc.onReject = {reason in
//            self.repo.removeItemFromOrder(self.rejectItemStr, becauseOf: reason, response: {
////                self.data?.cart_id![indexPath.row].hasRejecetd = true
////                self.data?.cart_id![indexPath.row].status = "rejected by restaurant"
////                self.tableView.reloadRows(at: [indexPath], with: .none)
//                self.tableView.reloadData()
//                self.acceptButton.isHidden = false
//                self.rejectButton.isHidden = false
//                self.doneButton.isHidden = true
//            })
//        }
//        let popUp = SBCardPopupViewController(contentViewController: vc)
//        popUp.show(onViewController: self)
    }
    
    @IBAction func onAcceptDishes(_ sender: UIButton) {
        self.repo.acceptOrder((self.data?.order_id!.id)!) {
            print("done")
            oneButtonAlertControllerWithBlock(msgStr: "Your order accepted successfully!", naviObj: self) { (true) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupWillDismiss")
        self.navigationController?.popViewController(animated: true)
    }
}
