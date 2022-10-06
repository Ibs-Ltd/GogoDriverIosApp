//
//  DriverMapViewController.swift
//  Restaurant
//
//  Created by MAC on 04/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
class DriverMapViewController: BaseViewController<OrderData> {

    @IBOutlet weak var callShopLbl: UILabel!
    @IBOutlet weak var swipeButton: TGFlingActionButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    private let repo = OrderRepository()
    private var orderDetail: OrderDetailData!
    
    @IBOutlet weak var arriveButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var callCenterLbl: UILabel!
    @IBOutlet weak var mapVIew: GMSMapView!
    // regarding the order
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoneNumer: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var userAdress: UILabel!
    var zoomLevel : Float = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        createNavigationLeftButton(nil)
        self.setOrderView(self.data!)
        self.createNavigationLeftButton(NavigationTitleString.orderDetail.localized())
        callCenterLbl.text = "Call Center".localized()
        callShopLbl.text = "Call Shop".localized()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func zoomButtonClicked(_ sender: UIButton) {
         zoomLevel = zoomLevel + 1
         mapVIew.animate(toZoom: zoomLevel)
     }
     
     @IBAction func zoomOutButtonClicked(_ sender: UIButton) {
         zoomLevel = zoomLevel - 1
         mapVIew.animate(toZoom: zoomLevel)
     }
     
     @IBAction func focusonCurrentLocationButtonClicked(_ sender: UIButton) {
      
     var mapItem = [MKMapItem]()
        
    let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "current_latitude") as? Double ?? 0.0, longitude: UserDefaults.standard.value(forKey: "current_longitude") as? Double ?? 0.0)))
    source.name = "Current addrees"
    mapItem.append(source)
        
        guard let restWise = self.data?.order_id?.restaurant_wise else {
            return
        }
        for (index,_) in restWise.enumerated() {
            if self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .pickedUp ||
             self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .started ||
             self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .arrived {
                //user
                let user = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.data?.order_id?.delivery_address?.latitude ?? 0.0, longitude: self.data?.order_id?.delivery_address?.longitude ?? 0.0)))
                             user.name = "Delivery location"
                            mapItem.append(user)
            }else{
                //restuarent
                
                let restuarent = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: restWise[index].restaurant_id?.lat ?? 0.0, longitude: restWise[index].restaurant_id?.long ?? 0.0)))
                restuarent.name = restWise[index].restaurant_id?.name ?? ""
                mapItem.append(restuarent)
                
            }
        }
        MKMapItem.openMaps(with: mapItem, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
     }
    
    
    
    
    
    func setOrderView(_ orderData: OrderData) {
        let userData = orderData.order_id?.user_id
        ServerImageFetcher.i.loadProfileImageIn(userImage, url: userData?.getProfileImagerUrl() ?? "")
        userName.text = userData?.name
        userPhoneNumer.text = userData?.getPhoneNumber(secure: false)
        self.userAdress.text = userData?.getCompleteAddress(secure: false)
        let order = orderData.order_id
        deliveryFee.text = "Delivery Fee :".localized() + (order?.getDeliveryFee() ?? "")
        paymentMethod.text = "Payment : ".localized() + (order?.getPaymentMethodType() ?? "")
        self.collectionView.reloadData()
        setUserLocation()
        
        
        guard let restWise = self.data?.order_id?.restaurant_wise else {
            return
        }
        for (index,_) in restWise.enumerated() {
            if self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .pickedUp{
                let total = self.total()
                let totalStr =    String(format: "%.2f", total)
                totalPrice.text = "Total Price :".localized() + totalStr
                self.swipeButton.setTitle("SWIPE START TRIP", for: .normal)
            }else if self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .started{
                self.swipeButton.setTitle("SWIPE TO ARRIVE".localized(), for: .normal)
                self.swipeButton.backgroundColor = AppConstant.appBlueColor
            }else if self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .arrived{
                let total = self.total()
                let totalStr =    String(format: "%.2f", total)
                totalPrice.text = "Total Price :".localized() + totalStr
                self.swipeButton.setTitle("SWIPE TO FINISH", for: .normal)
                self.swipeButton.backgroundColor = AppConstant.appBlueColor
            }else{
               let dishprice = self.total(index: index, orderData: orderData)
                let total =    String(format: "%.2f", dishprice)
                totalPrice.text = "Total Price :".localized() + total
                self.swipeButton.setTitle("SWIPE TO ARRIVE".localized(), for: .normal)
                print(self.data!.order_id?.restaurant_wise?[index].getOrderStatusAsString() ?? "")
                return
            }
        }
    }
    
    func setUserLocation() {
        self.mapVIew.mapType = .normal
        
        
        guard let restWise = self.data?.order_id?.restaurant_wise else {
            return
        }
        for (index,_) in restWise.enumerated() {
            if self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .pickedUp ||
                self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .started ||
                self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .arrived {
                //let corrdinate = CurrentSession.getI().localData.profile.location?.coordinates
                // Delivery Marker
                let long = CLLocationCoordinate2DMake((self.data?.order_id?.delivery_address?.latitude ?? 0.0), (self.data?.order_id?.delivery_address?.longitude ?? 0.0))
                let marker = GMSMarker()
                marker.icon = #imageLiteral(resourceName: "download")
                marker.position = long
                marker.map = mapVIew
                mapVIew.moveCamera(GMSCameraUpdate.setTarget(long, zoom: zoomLevel))
                self.mapVIew.isMyLocationEnabled = true
                
            }else{
                //restuarent
                
                let restuarent = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: restWise[index].restaurant_id?.lat ?? 0.0, longitude: restWise[index].restaurant_id?.long ?? 0.0)))
                restuarent.name = restWise[index].restaurant_id?.name ?? ""
                let long = CLLocationCoordinate2DMake((restWise[index].restaurant_id?.lat ?? 0.0), (restWise[index].restaurant_id?.long ?? 0.0))
                let marker = GMSMarker()
                marker.icon = UIImage(named: "track_rest.png")
                marker.position = long
                marker.map = mapVIew
                mapVIew.moveCamera(GMSCameraUpdate.setTarget(long, zoom: zoomLevel))
                self.mapVIew.isMyLocationEnabled = true
                
            }
        }
        
        
        // Driver Marker
        let driverlong = CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "current_latitude") as? Double ?? 0, longitude: UserDefaults.standard.value(forKey: "current_longitude") as? Double ?? 0)
        let driverMark = GMSMarker()
        driverMark.position = driverlong
        driverMark.map = mapVIew
    }
    

    @IBAction func onReviewOrder(_ sender: UIButton) {
        // sender.tag == 0 for accept
        repo.confirmPickup(order: OrderInfoData()) {
            UIView.animate(withDuration: 0.1, animations: {
                self.orderViewHeightConstraint.constant = 230
                self.buttonViewHeightConstraint.constant = 0
                self.arriveButtonHeight.constant = 50
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    @IBAction func tapOnCallButton(_ sender: UIButton) {
        self.showAlert(msg: "call will Intiated")
        
    }
    
    @IBAction func flingActionCallback(_ sender: TGFlingActionButton) {
        print(sender.swipe_direction)
        guard let restWise = self.data?.order_id?.restaurant_wise else {
            return
        }
        
        let status = restWise.compactMap({$0.getOrderStatus() != .pickedUp && $0.getOrderStatus() != .started && $0.getOrderStatus() != .arrived })
        let value =    status.filter({$0 == true})
        
    
        if sender.swipe_direction == .right {
            for (index,_) in restWise.enumerated() {
               //// DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    if restWise[index].getOrderStatus() == .pickedUp{
                        self.startUserAPI(index)
                    }else if restWise[index].getOrderStatus() == .started{
                        self.arrivedToUserAPI(index)
                    }else if restWise[index].getOrderStatus() == .arrived{
                        self.finishButtonClicked()
                    }else{
                        self.arrivedResAPI(index)
                        break
                    }
                //})
        
//                if restWise[index].getOrderStatus() != .pickedUp && restWise[index].getOrderStatus() != .started && restWise[index].getOrderStatus() != .arrived {
//                    break
//                }
                
                
            }
            //TO DO: Add the code for actions to be performed once the user swipe the button to right.
        }
    }

    func loadWriteViewController() {
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController else { return }
        //popupVC.orderDic = self.orderDataDic
        popupVC.height = 650
        popupVC.topCornerRadius = 20
        popupVC.presentDuration = 0.33
        popupVC.dismissDuration = 0.33
        //popupVC.popupDelegate = self
        popupVC.shouldDismissInteractivelty = false
        popupVC.previousObj = self
        self.present(popupVC, animated: true, completion: nil)
    }
    
    func arrivedResAPI(_ index:Int) {
        if self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .arrivedToRes || self.data!.order_id?.restaurant_wise?[index].getOrderStatus() == .dispatched{
            let vc: DriverOrderViewController = self.getViewController(.driverOrder, on: .order)
            let order = self.data?.order_id?.restaurant_wise?[index]
            let orderData = self.data
            orderData?.order_id?.restaurant_wise?.removeAll()
            orderData?.order_id?.restaurant_wise?.append(order!)
            vc.data = orderData
            vc.index = index
            self.navigationController?.pushViewController(vc, animated: true)
            self.swipeButton.reset()
            return
        }else{
            self.repo.arrivedToRes((self.data?.order_id?.restaurant_wise?[index].restaurant_id?.id.toString())!, orderId: (self.data?.order_id?.id.toString())!) {
                let vc: DriverOrderViewController = self.getViewController(.driverOrder, on: .order)
                let order = self.data?.order_id?.restaurant_wise?[index]
                let orderData = self.data
                orderData?.order_id?.restaurant_wise?.removeAll()
                orderData?.order_id?.restaurant_wise?.append(order!)
                vc.data = orderData
                vc.index = index
                self.navigationController?.pushViewController(vc, animated: true)
                self.swipeButton.reset()
            }
        }
    }
    
    
    func total(index:Int,orderData: OrderData) -> Double {
        
        var produtPrice = 0.0

        guard let restWise = self.data?.order_id?.restaurant_wise else {
            return 0.0
        }

        let carts = self.data?.order_id?.restaurant_wise?[index].cart_id ?? []
        for value in carts{
            
            if let _ = self.data?.order_id?.coupon_code,let _ = self.data?.order_id?.coupon_discount,let _ = self.data?.order_id?.coupon_type{
               // let addupValue = Double(self.data?.order_id?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                var total = value.calculateTotalPriceWithAddUp()
               // let percent = total *  addupValue / 100
                //total = total + percent
                produtPrice =  produtPrice + total
                
            }else{
                if value.dish_id?.discount_type == "none"{
                    //let addupValue = Double(self.data?.order_id?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                    var total = (value.getTotalPrice().replacingOccurrences(of: "$", with: "").toDouble()) ?? 0.0
                 //   let percent = total *  addupValue / 100
                  //  total = total + percent
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
        
        if let _ = self.data?.order_id?.coupon_code,let discount = self.data?.order_id?.coupon_discount,let type = self.data?.order_id?.coupon_type{
            if type == "percent"{
                let percent =   (produtPrice * Double(discount) / 100)
                return   produtPrice - percent
            }else{
                return  (produtPrice - Double(discount))
            }
        }
        return produtPrice
        
    }


    
    private func subTotalprodutPriceForVAT() -> Double {
        
        let carts = self.data?.order_id?.restaurant_wise?[0].cart_id ?? []
        var produtPrice = 0.0
        
        for value in carts{
            let addupValue = Double(self.data?.order_id?.restaurant_wise?[0].restaurant_id?.add_up_value ?? 0)
                var total = (value.calculateTotalPriceWithAddUp())
                let percent = total *  addupValue / 100
                total = total + percent
                produtPrice =  produtPrice + total
        }
        
        return produtPrice
    }
    
    private func VAT() -> Double{
        let subTotal = subTotalprodutPrice()
        if let tax_applicable = self.data?.order_id?.restaurant_wise?[0].tax_applicable , tax_applicable == "yes", let taxPercent = self.data?.order_id?.restaurant_wise?[0].tax_percent {
            let tax = subTotal *  taxPercent / 100.0
            return tax
        }
        return 0.0
    }
    private func coupon()->(String,Double){
        if let coupon = self.data?.order_id?.coupon_code,let discount = self.data?.order_id?.coupon_discount,let type = self.data?.order_id?.coupon_type{
            let subTotal = self.subTotalprodutPrice()
            if type == "percent"{
                return  (coupon,(subTotal * Double(discount) / 100))
            }else{
                return  (coupon,(subTotal - Double(discount) ))
            }
        }else{
            return ("",0.0)
        }
    }
    private func delivery() -> Double{
        return Double(self.data?.order_id?.delivery_charges ?? Int(0.0))
    }
    
     func total() -> Double{
        
        print(subTotalprodutPrice())
        print(coupon().1)
        print(delivery())
        print(VAT())
        return subTotalprodutPrice() + VAT()  + delivery() -  coupon().1
    }

    
    private func subTotalprodutPrice() -> Double {
                
        var produtPrice = 0.0
        guard let restWise = self.data?.order_id?.restaurant_wise else {
            return 0.0
        }
        for (index,_) in restWise.enumerated(){
            let carts = self.data?.order_id?.restaurant_wise?[index].cart_id ?? []
            for value in carts{
                if let _ = self.data?.order_id?.coupon_code,let _ = self.data?.order_id?.coupon_discount,let _ = self.data?.order_id?.coupon_type{
                    let addupValue = Double(self.data?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                    var total = value.calculateTotalPriceWithAddUp()
                    let percent = total *  addupValue / 100
                    total = total + percent
                    produtPrice =  produtPrice + total
                }else{
                    if value.dish_id?.discount_type == "none"{
                        let addupValue = Double(self.data?.order_id?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
                        var total = (value.getTotalPrice().replacingOccurrences(of: "$", with: "").toDouble()) ?? 0.0
                        let percent = total *  addupValue / 100
                        total = total + percent
                        produtPrice =  produtPrice + total
                    }else{
                        let addupValue = Double(self.data?.order_id?.restaurant_wise?[index].restaurant_id?.add_up_value ?? 0)
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
    
    func startUserAPI(_ index:Int) {
        self.repo.startToUser((self.data?.order_id?.id.toString())!) {
            self.data!.order_id?.restaurant_wise?[index].updateStatus(newStatus: "started")
            self.swipeButton.setTitle("SWIPE TO ARRIVE".localized(), for: .normal)
            self.swipeButton.backgroundColor = AppConstant.appBlueColor
            self.swipeButton.reset()
        }
    }
    
    func arrivedToUserAPI(_ index:Int) {
        self.repo.arrivedToUser((self.data?.order_id?.id.toString())!) {
            self.data!.order_id?.restaurant_wise?[index].updateStatus(newStatus: "arrived")
            self.swipeButton.setTitle("SWIPE TO FINISH", for: .normal)
            self.swipeButton.backgroundColor = AppConstant.appBlueColor
            self.swipeButton.reset()
        }
    }
    
    func finishButtonClicked() {
        let vc: OrderViewController = self.getViewController(.viewOrder, on: .order)
        vc.orderDataDic = self.data
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.swipeButton.reset()
    }
    
}

extension DriverMapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.order_id?.restaurant_wise?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DriverRestaurantCollectionViewCell
        let restaurant = self.data?.order_id?.restaurant_wise?[indexPath.row]
       
            cell.name.text = "\(restaurant?.restaurant_id?.name ?? "") || \(restaurant?.restaurant_id?.mobile ?? "")"
            cell.address.text = restaurant?.restaurant_id?.getCompleteAddress(secure: false)
        let marker = GMSMarker()
        marker.icon = UIImage(named: "Group 409")
        marker.title = restaurant?.restaurant_id?.name
        marker.map = mapVIew
            ServerImageFetcher.i.loadProfileImageIn(cell.restaurantImage, url: restaurant?.restaurant_id?.getProfileImagerUrl() ?? "")
        
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: DriverOrderViewController = self.getViewController(.driverOrder, on: .order)
        let order = self.data?.order_id?.restaurant_wise?[indexPath.row]
        let orderData = self.data
        orderData?.order_id?.restaurant_wise?.removeAll()
        orderData?.order_id?.restaurant_wise?.append(order!)
        vc.data = orderData
        vc.index = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    
    
    
}




class DriverRestaurantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
}
