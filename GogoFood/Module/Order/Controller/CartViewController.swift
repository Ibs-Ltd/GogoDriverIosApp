//
//  OrderDetailViewController.swift
//  Restaurant
//
//  Created by MAC on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit


class CartViewController: BaseTableViewController<CartData> {
    
    var expandedOrder  = false
    private let repo = CartRepository()
    private var numberOfSection = 0
    private var cartItems: [[CartItemData]] = []
    @IBOutlet weak var emptyCartImage: UIImageView!
    
    override func viewDidLoad() {
        nib = [TableViewCell.orderItemTableViewCell.rawValue, TableViewCell.orderAmountTableViewCell.rawValue,
               TableViewCell.contactInfoTableViewCell.rawValue,
               TableViewCell.deliveryDetailTableViewCell.rawValue,
               TableViewCell.paymentMethodTableViewCell.rawValue]
        super.viewDidLoad()
        createNavigationLeftButton(NavigationTitleString.viewProduct)
        addNotification()
        repo.getCartItems { (data) in
            self.data = data
            CurrentSession.getI().localData.cart = data
            CurrentSession.getI().saveData()
            self.seprateRestaurantWise()

        }
    }
    
    @objc override func onChangeCartItem(notification: Notification) {
        seprateRestaurantWise()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: Notification.Name("CartValueGetChanged"), object: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        seprateRestaurantWise()
    }
    
    
    func seprateRestaurantWise() {
        self.data = CurrentSession.getI().localData.cart
        let cartData = data?.cartItems ?? []
        var restaurant = cartData.compactMap({$0.dish_id?.restaurant_id})
        restaurant.forEach { (item) in
            restaurant.removeAll(where: {$0.id == item.id})
            restaurant.append(item)
        }
        
        self.cartItems.removeAll()
      
        restaurant.forEach { (item) in
            self.cartItems.append(cartData.filter({$0.dish_id?.restaurant_id?.id == item.id}))
        }
         self.emptyCartImage.isHidden = !cartData.isEmpty
        self.tableView.isHidden = cartData.isEmpty
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.cartItems.count + 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= cartItems.count {
            return 1
        }
        if !self.cartItems.isEmpty{
            if self.cartItems[section].first?.hasExpanded ?? false{
                return self.cartItems[section].count
            }
            return min(self.cartItems[section].count,  2)
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fixSection = cartItems.count - 1
        if indexPath.section <= fixSection {
            return getOrderItemCell(indexPath)
        }else if indexPath.section ==  fixSection + 1 {
            return getOrderAmountCell(indexPath)
        } else if indexPath.section == fixSection + 2 {
            return getContactTableCell(indexPath)
        } else if indexPath.section == fixSection + 3    {
            return getDeliveryDetailTableCell(indexPath)
        } else {
            return getPaymentMethodCell(indexPath)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fixSection = cartItems.count - 1
        if indexPath.section == fixSection + 1 {
            return 130 // for subtotal
        } else if indexPath.section == fixSection + 2 {
            return 0 // for driver
        }else if indexPath.section == fixSection + 3 {
            return 100
        } else if indexPath.section == fixSection + 4 {
            return 200
        }
        return 80
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= cartItems.count {return nil}
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! RestaurantMenuTableViewCell
        cell.resName.text = self.cartItems[section].first?.dish_id?.restaurant_id?.name
        cell.showMenu = {
            let vc: StoreInformationViewController = self.getViewController(.storeInformation, on: .home)
            let d = StoreInfomationData()
            d.restaurant = self.cartItems[section].first?.dish_id?.restaurant_id
            vc.data = d
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section >= cartItems.count {return nil}
        if self.cartItems[section].count < 2 {return nil}
        let footer = tableView.dequeueReusableCell(withIdentifier: "footer") as! CartFooterTableViewCell
        footer.expandSection = {
            self.cartItems[section].forEach({$0.hasExpanded = !$0.hasExpanded})
            self.tableView.reloadData()
            
        }
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section >= cartItems.count {return CGFloat.zero}
        if self.cartItems[section].count < 2 {return CGFloat.zero}
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= cartItems.count {return CGFloat.zero}
        return 80
    }
  
    private func getContactTableCell(_ indexPath: IndexPath) -> ContactInfoTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ContactInfoTableViewCell
        cell.selectionStyle = .none
        if let d = self.data?.user {
            cell.initView(withData: d)
        }
        return cell
    }
    
    
    private func getDeliveryDetailTableCell(_ indexPath: IndexPath) -> DeliveryDetailTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DeliveryDetailTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func getPaymentMethodCell(_ indexPath: IndexPath) -> PaymentMethodTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! PaymentMethodTableViewCell
        cell.initView(withData: CurrentSession.getI().localData.cart)
        cell.selectionStyle = .none
        cell.placeOrder = { (method) in
            if let _ = CurrentSession.getI().localData.profile.default_address {
                self.repo.placeOrder(paymentMethod: method, onComplition: { (d) in
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                let vc: AddAddressViewController = self.getViewController(.address, on: .map)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
           
        }
        return cell
    }
    
    private func getOrderAmountCell(_ indexPath: IndexPath) -> OrderAmountTableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: nib[1], for: indexPath) as! OrderAmountTableViewCell
        c.selectionStyle = .none
        if let d = self.data {
            c.initView(withData: d)
        }
       return c
    }
    
    private func getOrderItemCell(_ indexPath: IndexPath) -> OrderItemTableViewCell {
        let c =  tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath) as! OrderItemTableViewCell
        c.selectionStyle = .none
        c.initViewForDetail()
        if let _ = self.data {
            c.initView(withData: self.cartItems[indexPath.section][indexPath.row])
        }
        return c
    }
    
}

class RestaurantMenuTableViewCell: BaseTableViewCell<RestaurantProfileData> {
    
    @IBOutlet weak var resName: UILabel!
    var showMenu: (()-> Void)!
    
    @IBAction func showMenu(_ sender: UIButton) {
        showMenu()
    }
    
}

class CartFooterTableViewCell: BaseTableViewCell<BaseData> {
    var expandSection: (()-> Void)!
    @IBAction func expandSection(_ sender: Any) {
        expandSection()
    }
}
