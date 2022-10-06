//
//  LocationViewController.swift
//  User
//
//  Created by YOGESH BANSAL on 25/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import GoogleMaps


class AddAddressViewController: BaseViewController<BaseData>, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    private let geoCoder = GMSGeocoder()
    
    @IBOutlet weak var addAdressButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    private var lat: Double!
    private var lng: Double!
    private let repo = MapRepository()
    private var address: String! = ""
    private var state: String! = ""
    private var city: String! = ""
    private var gmsAddress: GMSAddress!
    
    #if User
    
    var isShownFromSetting = false
    var isUpdateLocation = false
    var userAddress: AddressData!
    #endif
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
      
        
       
        
        let camera = GMSCameraPosition.camera(withLatitude: 28.610001, longitude: 77.230003, zoom: 12)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.settings.myLocationButton = false
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showAlert(msg: "Please enable your location")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                self.mapView.isMyLocationEnabled = true
            @unknown default:
                break
                
            }
        }else{
            self.showAlert(msg: "Please enable your location")
        }
        
        #if Restaurant
        if self.navigationController?.isBeingPresented ?? false {
            self.setNavigationTitleTextColor(NavigationTitleString.addLocation)
        }else{
            self.createNavigationLeftButton(NavigationTitleString.addLocation)
        }
        showAlert(msg: "You can't change location once added")
        #elseif User
        setViewForUser()
        
        #endif
        
    }
    
    
    #if User
    func setViewForUser() {
        if let a = self.userAddress {
             setDataFor(location: CLLocationCoordinate2D(latitude: a.latitude ?? 0.0, longitude: a.longitude ?? 0.0))
        }
        if isShownFromSetting {
            createNavigationLeftButton(NavigationTitleString.myAddress)
        }
        
        if isUpdateLocation {
             createNavigationLeftButton(NavigationTitleString.changeLocation)
            addAdressButton.setTitle(AppStrings.selectLocation, for: .normal)
        }
    }
    
    #endif
    
    
    
    
    
    
    
    @IBAction func onAddLocation(_ sender: UIButton) {
       
        self.repo.addUser(self.gmsAddress, onComplition: { (data) in
            CurrentSession.getI().localData.profile = data.profile
            CurrentSession.getI().saveData()
            #if Restaurant
            let vc: ResturantTimeViewController = self.getViewController(.restaurantTime, on: .setting)
            self.navigationController?.pushViewController(vc, animated: true)
            #else
            self.navigationController?.popViewController(animated: true)
            #endif
            
        })
      
        
        
        
        
    }
    

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        lat = position.target.latitude
        lng = position.target.longitude
        
        // Create Location
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        
        setDataFor(location: location)
      
    }
    
    func setDataFor(location: CLLocationCoordinate2D) {
        // Geocode Location
        var currentAddress = String()
        geoCoder.reverseGeocodeCoordinate(location) { (response, error) in
            if let address = response?.firstResult() {
                self.gmsAddress = address
                let lines = address.lines! as [String]
                self.address = lines.joined(separator: ",")
                self.state = address.administrativeArea ?? ""
                self.city = address.locality ?? ""
                currentAddress = lines.joined(separator: "\n")
                self.addressLabel.text = currentAddress
                // currentAdd(returnAddress: currentAddress)
            }
            
        }
        
    }
    
    
}// MARK: - CLLocationManagerDelegate
//1}
extension AddAddressViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
}

