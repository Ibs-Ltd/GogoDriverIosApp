//
//  LiveOrderViewController.swift
//  Restaurant
//
//  Created by MAC on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import CoreLocation


class LiveOrderViewController: BaseTableViewController<OrdersData> {
    @IBOutlet weak var colVw_Orders: UICollectionView!{
        didSet{
            colVw_Orders.delegate = self
            colVw_Orders.dataSource = self
        }
    }
    
    @IBOutlet weak var colVw_height: NSLayoutConstraint!
    @IBOutlet weak var onlineStatus: UISwitch!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var badgeImage: UIImageView!
    private let repo = OrderRepository()
    private let mapRepo = MapRepository()
    private var liveOrder: [OrderData] = []
    private var acceptedOrder: [OrderData] = []
    private var acceptedDriverOrder: [OrderInfoData] = []
    let locationManager = CLLocationManager()
    let mainView = StatusView.instantiate(message: "Hello World.")
    private var timer: Timer?

    
    override func viewDidLoad() {
        nib.append(TableViewCell.restaurantHistoryTableViewCell.rawValue)
        super.viewDidLoad()
        onlineStatus.isOn  = true
        setOnline(onlineStatus)
        createNavigationLeftButton(nil)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name.newOrders, object: nil)

        self.navigationController?.hidesBottomBarWhenPushed = true
        let coords = CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "current_latitude") as? Double ?? 0, longitude: UserDefaults.standard.value(forKey: "current_longitude") as? Double ?? 0)
        
        self.mapRepo.getProfile { (profile) in
            
            if profile.profile != nil && profile.profile.status == "pending"{
                self.setupOpaqueView()
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fetchData(_:)), userInfo: nil, repeats: true)

            }else{
                self.mapRepo.uppdateLocation(coords) { (data) in
                    self.mapRepo.DriverGetOrdersSocket() { (data) in
                        self.setOrder()
                    }
                    self.setOrderWithLoader()
                }
            }
        }
    }
    
    @objc func notificationReceived(_ notification: Notification) {
          setOrder()
      }
    
    @objc func appWillEnterForeground() {
        if self.viewIfLoaded?.window != nil {
            // viewController is visible
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }else{
                let alert = UIAlertController(title: "Location Error", message: "Please enable location", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Enable Location", style: .default, handler: { (_) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, completionHandler: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    override func createNavigationLeftButton(_ withTitle: String?) {
        self.profileImage.contentMode = .scaleAspectFill
        ServerImageFetcher.i.loadProfileImageIn(profileImage, url: CurrentSession.getI().localData.profile.profile_picture ?? "")
    }
    
    @IBAction func showProfile(_ sender: UIButton) {
        //self.navigationController?.pushViewController(Controller.driverEditProfile, avaibleFor: StoryBoard.setting)
        let c: DriverEditProfileViewController = self.getViewController(.driverEditProfile, on: .setting)
        c.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(c, animated: true)
    }
    
    deinit {
        repo.disconnectSocket()
        mapRepo.disconnectSocket()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1)
        ? acceptedOrder.isEmpty ? 1 : acceptedOrder.count
        : liveOrder.isEmpty ? 1 : liveOrder.count
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellFor(indexPath: indexPath, tableView: tableView)
    }
    
    func getCellForEmpty(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmptyWaitingTableViewCell
        cell.imageVie.image = UIImage(named: "waiting")
        cell.imageVie.isHidden = (indexPath.section == 1)
        cell.emptyMessage.isHidden = (indexPath.section == 0)
        cell.emptyMessage.text = AppStrings.noLiveOrder.localized()
        cell.waitingLbl.text = (indexPath.section == 1)
            ? AppStrings.todayOrder
            : AppStrings.waitingForNewOrder
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0
        ? liveOrder.isEmpty ? tableView.frame.height / 2 : UITableView.automaticDimension
        : acceptedOrder.isEmpty ? tableView.frame.height / 2 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectat(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let yourLabel: UILabel = UILabel()
        yourLabel.frame = CGRect(x: 10, y: 0, width: 200, height: 40)
        yourLabel.textColor = UIColor.black
        yourLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        if self.liveOrder.isEmpty{
            yourLabel.text = section == 0 ? AppStrings.waitingForNewOrder : AppStrings.todayOrder
        }else{
            yourLabel.text = section == 0 ? "New Order" : AppStrings.todayOrder
        }
        headerView.addSubview(yourLabel)
        return headerView
    }
    
    @IBAction func setOnline(_ sender: UISwitch) {
        #if Driver
        repo.setAvailaiblityStatus(sender.isOn ? "online" : "Offine") {
            print("API CALL")
        }
        #endif
    }
}

// Set Live order for the restaurant

extension LiveOrderViewController {
    func setOrder() {
        repo.getOrderList() { item in
            self.liveOrder = item.newOrder
            self.acceptedOrder.removeAll()
            item.order.forEach({ (item) in
                let order = OrderData()
                order.order_id = item
                self.acceptedOrder.append(order)
                })
            if self.liveOrder.count > 0 {
                self.colVw_height.constant = 170.0

            }else{
                self.colVw_height.constant = 0.0
            }
           self.acceptedOrder =  self.acceptedOrder.sorted(by: { ($0.order_id?.id ?? 0) > ($1.order_id?.id ?? 0) })
            self.tableView.reloadData()
            self.colVw_Orders.reloadData()
        }
    }
    
    func setOrderWithLoader() {
        repo.getOrderListWithLoader() { item in
            self.liveOrder = item.newOrder
            self.acceptedOrder.removeAll()
            item.order.forEach({ (item) in
                let order = OrderData()
                order.order_id = item
                order.createdOrderID = item.getCreatedTime()
                self.acceptedOrder.append(order)
                })
            if self.liveOrder.count > 0 {
                self.colVw_height.constant = 170.0
            }else{
                self.colVw_height.constant = 0.0
            }
         self.acceptedOrder =   self.acceptedOrder.sorted(by: { ($0.order_id?.id ?? 0) > ($1.order_id?.id ?? 0) })
            self.tableView.reloadData()
            self.colVw_Orders.reloadData()
        }
    }
    
    func getCellFor(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        // section 1 will show the accepted order
        if indexPath.section == 0 {
            return self.liveOrder.isEmpty
                ? getCellForEmpty(indexPath, tableView)
                : getOrderCell(indexPath, tableView)
        }
        return self.acceptedOrder.isEmpty
            ? getCellForEmpty(indexPath, tableView)
            : getOrderCell(indexPath, tableView)
    }
    
    private func getOrderCell(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "driverOrder", for: indexPath) as! DriverOrderTableViewCell
        c.isForAceptedOrder = (indexPath.section == 1)
        c.isFromLiveOrder = indexPath.section == 1 ? false:true
        if indexPath.section == 0 {
            c.bottomViewConst.constant = 40
            c.autoRejectTimer.isHidden = false
            c.initView(withData: self.liveOrder[indexPath.row])
        }else{
            c.bottomViewConst.constant = 0
            c.autoRejectTimer.isHidden = true
            c.initView(withData: self.acceptedOrder[indexPath.row])
        }
       
        c.onReviewOrder = { isAccepted in
            if indexPath.section == 0 {
              self.onAcceptOrder(indexPath)
            }
        }
        c.onRejectOrder = { isARejected in
            if indexPath.section == 0 {
                self.onRejectOrder(indexPath)
            }
        }
        return c
    }
    
    
    func onAcceptOrder(_ indexPath: IndexPath) {
        repo.acceptOrder(self.liveOrder[indexPath.row].order_id?.id ?? 0) {
            self.setOrder()
        }
    }
    func onRejectOrder(_ indexPath: IndexPath) {
        repo.rejectOrder(self.liveOrder[indexPath.row].order_id?.id ?? 0) {
            self.setOrder()
        }
    }
    
    func didSelectat(_ indexPath: IndexPath) {
        if indexPath.section == 1 {
            let c: DriverMapViewController = self.getViewController(.orderOnMap, on: .map)
            if self.acceptedOrder.count > 0{
                let data = self.acceptedOrder[indexPath.row]
                c.data = self.acceptedOrder[indexPath.row]
                c.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(c, animated: true)
            }
     
        }
    }
}

extension LiveOrderViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last! as CLLocation
        print("-----> %.4f",latestLocation.coordinate.latitude)
        print("-----> %.4f",latestLocation.coordinate.longitude)
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(latestLocation.coordinate.latitude, forKey: "current_latitude")
        userDefaults.setValue(latestLocation.coordinate.longitude, forKey: "current_longitude")
//        userDefaults.setValue(23.1014, forKey: "current_latitude")
//        userDefaults.setValue(72.5408, forKey: "current_longitude")
        userDefaults.synchronize()
        let coords = CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "current_latitude") as? Double ?? 0, longitude: UserDefaults.standard.value(forKey: "current_longitude") as? Double ?? 0)
        self.mapRepo.uppdateLocationSocket(coords) { (data) in
            print("uppdateLocationSocket")
        }
    }
}


class EmptyWaitingTableViewCell: UITableViewCell {
    @IBOutlet weak var waitingLbl: UILabel!
    @IBOutlet weak var imageVie: UIImageView!
    @IBOutlet weak var emptyMessage: UILabel!
    override func awakeFromNib() {
        waitingLbl.text = AppStrings.waitingForNewOrder
    }
}
class Orders_collectionCell: UICollectionViewCell {
    
    @IBOutlet weak var btn_decline: UIButton!
    @IBOutlet weak var btn_accept: UIButton!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_deliveryPrice: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var timer_countDown: KCCircularTimer!
    private var timer: Timer?
    var onOrderTimeOut: (()-> Void)!

    override func awakeFromNib() {
    }
    func setupCountDownTimer(_ timer: Int) {
        timer_countDown.animate(from: Double(timer), to: 0)
    }
    
    @objc func fetchData(_ sender:Timer){
        guard  let withData = sender.userInfo as? OrderData else{return}
        if withData.getAutoCheckInTime() == 0{
            sender.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.onOrderTimeOut()
            }
        }else{
            if withData.getAutoCheckInTime() < 0{
                sender.invalidate()
            }
            print(withData.getAutoCheckInTime())
        }
    }
    
    
    func initView(withData: OrderData) {
        
        
        self.timer?.invalidate()
        self.timer =  nil
        
        let total =    String(format: "%.2f", withData.order_id?.order_total ?? 0.0)
        lbl_total.text = "$\(total)"
        lbl_distance.text = "\(withData.order_id?.restaurant_wise?[0].distance ?? 0.0)KM"
        lbl_deliveryPrice.text = "$\(withData.order_id?.restaurant_wise?[0].delivery_charges ?? 0.0)"
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = nil
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchData(_:)), userInfo: withData, repeats: true)
                
                self.setupCountDownTimer(withData.getAutoCheckInTime())
            }
        }
}

extension LiveOrderViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveOrder.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Orders_collectionCell", for: indexPath) as? Orders_collectionCell
        DispatchQueue.main.async {
            cell?.initView(withData: self.liveOrder[indexPath.row])
        }
        cell?.onOrderTimeOut = {
            if self.liveOrder.count > 0 && indexPath.row < self.liveOrder.count {
                self.repo.rejectOrder(self.liveOrder[indexPath.row].order_id?.id ?? 0) {
                self.setOrder()
            }
            }
        }
        cell?.btn_decline.tag = indexPath.row
         cell?.btn_accept.tag = indexPath.row
        cell?.btn_decline.addTarget(self, action: #selector(onClickReject(_ :)), for: .touchUpInside)
        cell?.btn_accept.addTarget(self, action: #selector(onClickAccept(_ :)), for: .touchUpInside)

        return cell!
    }
    
    @objc func onClickReject(_ sender:UIButton){
        if self.liveOrder.count > 0 && sender.tag < self.liveOrder.count {
            self.repo.rejectOrder(self.liveOrder[sender.tag].order_id?.id ?? 0) {
                self.setOrder()
            }
        }
    }
    @objc func onClickAccept(_ sender:UIButton){
        repo.acceptOrder(self.liveOrder[sender.tag].order_id?.id ?? 0) {
            self.setOrder()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 150)
    }

}
extension LiveOrderViewController{
  
    @objc func fetchData(_ sender:Timer){
        self.mapRepo.getProfile { (profile) in
            if profile.profile.status == "approved"{
                self.mainView.removeFromSuperview()
                sender.invalidate()
                self.timer?.invalidate()
                self.timer = nil
            }
        }
            
    }
    func setupOpaqueView() {
        mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIApplication.shared.keyWindow?.addSubview(mainView)
        UIApplication.shared.keyWindow!.bringSubviewToFront(mainView)
//        mainView.tapOnButton = {
//            self.mainView.removeFromSuperview()
//        }
    }
}
