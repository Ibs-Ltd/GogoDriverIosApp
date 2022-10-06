//
//  ResturantOpeningTimeViewController.swift
//  GogoFood
//
//  Created by MAC on 20/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class ResturantTimeViewController: BaseViewController<RestaurantProfileData>, UITextViewDelegate {
    
    
    // always open
    @IBOutlet weak var alwaysOpenCheckButton: UIButton!
    @IBOutlet weak var alwaysOpenTiming: ResturantTime!
    private var alwaysOpenTime: TimeData!
    
    
    // Selcted hour
    @IBOutlet weak var selectedHourCheckButton: UIButton!
    //week related
    @IBOutlet private var weekDays: [UIView]!
    @IBOutlet private var weekDaysCheckButton: [UIButton]!
    @IBOutlet var weekdaysTiming: [ResturantTime]!
    
    @IBOutlet weak var remainingDescription: UILabel!
    private let weekDaysName = [AppStrings.mon, AppStrings.tue, AppStrings.wed, AppStrings.thu, AppStrings.fri, AppStrings.sat, AppStrings.sun]
    private var selectedWeekDay = [false, false, false, false, false, false, false]
    private var selectedWeekTime: [TimeData?] = [nil, nil, nil, nil, nil, nil, nil]
    private let fullWeekDayName = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    
    @IBOutlet weak var estimateCookingTime: AppTextField!
    @IBOutlet weak var estimateDeliveryTime: AppTextField!
    
    @IBOutlet weak var descption: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    let emptyText = "Enter Description"
    
private let repo = SettingRepository()
    
    @IBOutlet weak var saveButton: AppButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekDaysCheckButton.forEach({$0.isSelected = false})
        setNavigationTitleTextColor(NavigationTitleString.restaurantOpeningTime)
        // Do any additional setup after loading the view.
        descriptionTextView.delegate = self
      
        remainingDescription.text = "160"
        repo.getResturantTimmig { (data) in
            self.data = data
            self.initView()
        }
    }
    
    
    
    func initView() {
        setViewForSelectedHour()
        
        // for set estimate Time
        
        estimateCookingTime.initiateView(type: .largeTimeSelection, infoText: AppStrings.estimateCooking, placeHolder: "00 min")
        estimateCookingTime.voidCallBack =  {
            self.showActionPicker(self.estimateCookingTime, onComplition: { (item) in
                self.estimateCookingTime.isValueSet = true
                self.estimateCookingTime.setText("\(item) min")
            })
        }
        
        // for set Delivery time
        
        estimateDeliveryTime.initiateView(type: .largeTimeSelection, infoText: AppStrings.estimateDeliveryTime, placeHolder: "00 min")
        estimateDeliveryTime.voidCallBack = {
            self.showActionPicker(self.estimateDeliveryTime, onComplition: { (item) in
                 self.estimateDeliveryTime.isValueSet = true
                self.estimateDeliveryTime.setText("\(item) min")
            })
        }
        
       
        
       
        if let d = self.data {
            if !d.restaurantTime.isEmpty{
            estimateCookingTime.setText(self.data?.getCookingTime() ?? "")
            estimateDeliveryTime.setText(self.data?.getDeliveryTime() ?? "")
            let firstTime = d.restaurantTime.first
            setRestaurantOpenTime((firstTime?.type == .all) ? alwaysOpenCheckButton : selectedHourCheckButton)
            if d.restaurantTime.first?.type == .all {
                alwaysOpenTiming.setStartAndEndTime(firstTime?.startTime ?? "", firstTime?.endTime ?? "")
                
            }else{
                
                self.weekdaysTiming.forEach { (time) in
                    let t = d.restaurantTime.first(where: {$0.name == self.fullWeekDayName[time.tag]})
                    time.setStartAndEndTime(t?.startTime ?? "", t?.endTime ?? "")
                     self.weekDaysCheckButton[time.tag].isSelected = true
                    self.selectedWeekDay[time.tag] = true
                }
            }
              descriptionTextView.text = d.description ?? emptyText
            self.setViewForSelectedHour()
            
            
        }}
        
        setSaveButton()
    }
    
    @IBAction func setRestaurantOpenTime(_ sender: UIButton) {
        selectedHourCheckButton.isSelected = (sender.tag == selectedHourCheckButton.tag)
        alwaysOpenCheckButton.isSelected = (sender.tag == alwaysOpenCheckButton.tag)
        setViewForSelectedHour()
        
    }
    
    
    func setViewForSelectedHour() {
        for i in 0..<weekDaysName.count {
            self.weekDaysCheckButton[i].isSelected = self.selectedWeekDay[i]
            self.weekDaysCheckButton[i].setTitle(self.weekDaysName[i], for: .normal)
            self.weekDays[i].isHidden = !selectedHourCheckButton.isSelected
            
        }
        self.weekdaysTiming.forEach { (data) in
            data.userStart = {
                self.weekDaysCheckButton[data.tag].isSelected = true
                self.selectedWeekDay[data.tag] = true
            }
        }
        
    }
    
    func setSaveButton() {
        self.saveButton.initButton(type: .red, text: AppStrings.save, image: nil)
        self.saveButton.voidCallBack = {
            if self.isDataValid() {
                self.repo.addRestaurantTime(data: self.createPostData(), onComplition: { (item) in
                    CurrentSession.getI().localData.profile = item.profile
                    CurrentSession.getI().saveData()
                    if CurrentSession.getI().localData.profile.userStatus == .activated {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        let sb = UIStoryboard(name: StoryBoard.main.rawValue, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: Controller.initController.rawValue)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                })
            
            }
            
            
            
        }
        
    }
    
    func isDataValid() -> Bool {
        if self.alwaysOpenCheckButton.isSelected {
            if alwaysOpenTiming.isDataValid() {
                self.alwaysOpenTime = TimeData(name: self.fullWeekDayName[0], startTime: self.alwaysOpenTiming.getRestaurantTime().0!, endTime: self.alwaysOpenTiming.getRestaurantTime().1!)
            }else{
                showAlert(msg: "Start time should be greater than the close time")
                return false
            }
            
        }else
            // if selected the week timming
        {
            // iterate on all timmings
            for i in 0..<self.weekDaysName.count{
                // check if user select day
                if self.selectedWeekDay[i] {
                    // get the restaurant time view by comparing time
                    for j in 0..<self.weekdaysTiming.count {
                        if weekdaysTiming[j].tag == i {
                            if weekdaysTiming[j].isDataValid() {
                                // append timming
                                self.selectedWeekTime[i] =
                                    TimeData(name: self.fullWeekDayName[i], startTime: self.weekdaysTiming[j].getRestaurantTime().0!, endTime: self.weekdaysTiming[j].getRestaurantTime().1!)
                            }else{
                                showAlert(msg: "Please enter the correct timming for \(self.fullWeekDayName[i])")
                                return false
                                
                            }
                        }
                    }
                }
            }
        
        }
        
        
        if !self.estimateCookingTime.isValueSet {
            showAlert(msg: "Please Enter estimate cooking time")
            return false
        }
        
        if !self.estimateDeliveryTime.isValueSet {
            showAlert(msg: "Please Enter estimate delivery time")
            return false
        }
        
        return true
        
    }
    
    @IBAction func selectWeekDay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.selectedWeekDay[sender.tag] = !self.selectedWeekDay[sender.tag]
    }
    
    func showActionPicker(_ sender: UIView, onComplition: @escaping (_ value: Int) -> Void) {
        let seconds = 0..<60
        ActionSheetMultipleStringPicker.show(withTitle: "Select time", rows: [
            seconds.map({$0.description})
            ], initialSelection: [1], doneBlock: {
                picker, indexes, values in
                if let items = indexes as? [Int] {
                    if let index = items.first {
                        onComplition(index)
                    }
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
    }
    
    private func createPostData() -> RestaurantTimmingData {
        let data = RestaurantTimmingData()
        data.type = self.alwaysOpenCheckButton.isSelected ? .all : .single
        if self.alwaysOpenCheckButton.isSelected{
            data.day.append(self.alwaysOpenTime)
        }else{
            for i in self.selectedWeekTime {
                if let v = i {
                    data.day.append(v)
                }
            }
            
        }
        data.cookingTime =  Int(estimateCookingTime.getText().replacingOccurrences(of: " min", with: ""))!
        data.deliveryTime = Int(estimateDeliveryTime.getText().replacingOccurrences(of: " min", with: ""))!
        if descriptionTextView.text != emptyText {
            data.description = descriptionTextView.text
        }
        return data
    
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == emptyText{
            textView.text = ""
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = emptyText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.remainingDescription.text = "\(160 - textView.text.count) / 160"
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        return (textView.text.count < 160)
    }
    
    
}
