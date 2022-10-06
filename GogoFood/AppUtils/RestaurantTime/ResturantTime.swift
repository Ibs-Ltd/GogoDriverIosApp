//
//  ResturantTimeView.swift
//  Restaurant
//
//  Created by MAC on 20/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class ResturantTime: BaseAppView {
   
    @IBOutlet weak private var startTime: AppTextField!
    @IBOutlet weak private var closeTIme: AppTextField!
    private var start: Date!
    private var close: Date!
    var userStart: (() -> ()) = {}
   
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonSetup("RestaurantTime")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startTime.initiateView(type: .smallTimeSelection, infoText: nil, placeHolder: "00:00")
        startTime.voidCallBack = {
            self.startTime.endEditing(true)
            self.startTime.voidCallBack = {
                self.userStart()
                self.openActionSheetPicker(onComplition: { (date) in
                    self.start = date
                    self.startTime.setText(self.covertDateToTime(self.start))
                    self.compareTime()
                })
            
            }}
            closeTIme.initiateView(type: .smallTimeSelection, infoText: nil, placeHolder: "00:00")
        
            closeTIme.voidCallBack = {
                self.userStart()
                self.closeTIme.endEditing(true)
                self.openActionSheetPicker(onComplition: { (date) in
                    self.close = date
                    self.closeTIme.setText(self.covertDateToTime(self.close))
                  self.compareTime()
                })
        }
//        checkButton.voidCallBack = {
//            
//        }
    }
    
    func initView(title: String, type: RadioType) {
       
        //checkButton.initView(type: type, title: title)
        
        
    }
    
    func openActionSheetPicker(onComplition: @escaping (_ date: Date) -> Void) {
        ActionSheetDatePicker.show(withTitle: "Select time", datePickerMode: .time, selectedDate: Date(), doneBlock: { (e, date, f) in
            if let d = date as? Date {
                onComplition(d)
            }
        }, cancel: {ActionDateCancelBlock in return}, origin: self)
        
        
    }
    
    func getRestaurantTime () -> (String?, String?) {
        var time: (String?, String?)
        if let _ = start{
            time.0 = self.covertDateTo12HourTime(start)
        }
        if let _ = close {
            time.1 = self.covertDateTo12HourTime(close)
        }
        
        return time
        
    }
    
    func isDataValid() -> Bool {
        guard let _ = start else {return false}
        guard let _ = close else {return false}
    
        return self.close.hours(from: self.start) > 1
    
    }
    
    
    private func compareTime() {
        guard let _ = start else {return}
        guard let _ = close else {return}
        if self.close.hours(from: self.start) < 1 {
            self.showError("Start time should be greater than the close time")
            
        }
    }
    
    
    
    @IBAction func selectTime(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
       // AppAlertView.initView()
    }
    
    private func covertDateToTime(_ date: Date?) -> String {
        guard let d = date else {return ""}
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: d)
    }
    
    private func covertDateTo12HourTime(_ date: Date!) -> String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        return format.string(from: date)
    }
    
    func setStartAndEndTime(_ startTime: String, _ endTime: String) {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        self.start = f.date(from: startTime)
        self.close = f.date(from: endTime)
        let st = self.covertDateToTime(start)
        self.startTime.setText(st)
        let ct = self.covertDateToTime(close)
        self.closeTIme.setText(ct)
    }
    
    
    
}
