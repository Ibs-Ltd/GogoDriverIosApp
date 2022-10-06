//
//  DriverEditProfileViewController.swift
//  Driver
//
//  Created by MAC on 27/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import ImagePicker

class DriverEditProfileViewController: EditProfileViewController {
    
    @IBOutlet weak var plateNumber: UITextField!
    @IBOutlet weak var vehicleYear: UITextField!
    @IBOutlet weak var vehicleColor: UITextField!
    @IBOutlet weak var vehicleModel: UITextField!
    @IBOutlet weak var voterIDFront: UIImageView!
    @IBOutlet weak var voterIDBack: UIImageView!
    @IBOutlet weak var vehicleIDFront: UIImageView!
    @IBOutlet weak var vehicleIDBack: UIImageView!
    
    var idFrontselected = false
    var idBackselected = false
    var vIdFrontselected = false
    var vIdBackselected = false
    
    private var setImage = 101
    private var selectForId = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uplineCodeTextField.text = UserDefaults.standard.value(forKey: "referCode") as? String ?? ""

        secondPhNoView.isHidden = true
        
//        if (CurrentSession.getI().localData.profile.userStatus) == .activated {
//            self.setDriverProfileData()
//        }
        if (profile?.id_card_front) != nil {
            self.setDriverProfileData()
        }
    }
    
    func setDriverProfileData() {
        plateNumber.text = profile?.plate_no
        vehicleYear.text = profile?.vehicle_year
        vehicleColor.text = profile?.vehicle_color
        vehicleModel.text = profile?.vehicle_model
        ServerImageFetcher.i.loadImageIn(voterIDFront, url: (profile?.id_card_front)!)
        ServerImageFetcher.i.loadImageIn(voterIDBack, url: (profile?.id_card_back)!)
        ServerImageFetcher.i.loadImageIn(vehicleIDFront, url: (profile?.vehicle_id_front)!)
        ServerImageFetcher.i.loadImageIn(vehicleIDBack, url: (profile?.vehicle_id_back)!)
        idFrontselected = true
        idBackselected = true
        vIdFrontselected = true
        vIdBackselected = true
    }
    
    override func updateBtnAction(_ sender: Any) {
        if nameTextField.text!.isEmpty {
            return showAlert(msg: "Please Enter name")
        }
        
        if !imageSelected {
            return showAlert(msg: "Please Select Image")
        }
        
        if !(emailTextField.text?.isEmpty ?? true) {
            if !self.isValidEmail(emailTextField.text ?? "") {
                return showAlert(msg: "Please enter a valid email")
            }
        }
        if plateNumber.text!.isEmpty {
            return showAlert(msg: "Enter vehicle plate number")
        }
        if vehicleYear.text!.isEmpty || Int(vehicleYear.text!)! > 2020 ||  vehicleYear.text!.count != 4{
            return showAlert(msg: "Enter valid model year")
        }
        if vehicleColor.text!.isEmpty {
            return showAlert(msg: "vehicle color shouldn't be empty")
        }
        if vehicleModel.text!.isEmpty {
            return showAlert(msg: "Enter model number")
        }
        
        if !idFrontselected {
           return showAlert(msg: "Please Select ID front")
        }
        
        if !idBackselected {
           return showAlert(msg: "Please select ID back")
        }
        
        if !vIdFrontselected {
          return  showAlert(msg: "Please select Vehicle ID front")
        }
        if !vIdBackselected {
            return showAlert(msg: "Please select Vehicle ID back")
        }
        
        
        repo.updateDriverProfle(
            image: self.profilePicOutlet.image,
            name: nameTextField.text!,
            email: emailTextField.text,
            uplineCode: uplineCodeTextField.text!,
            vehicleColor: vehicleColor.text!,
            vehicleYear: vehicleYear.text!,
            vehicleModel: vehicleModel.text!,
            plateNumber: plateNumber.text!,
            idFront: voterIDFront.image,
            idBack: voterIDBack.image,
            vIDFront: vehicleIDFront.image!,
            vIDBack: vehicleIDBack.image!) { (data) in
            CurrentSession.getI().localData.profile = data.profile
            CurrentSession.getI().saveData()
            self.onUpdateProfile()
        }
    }
    
    @IBAction func selectIdImage(_ sender: UIButton) {
        self.selectForId = true
        self.setImage = sender.tag
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }

    override func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if selectForId{
        if let image = images.first{
            selectForId = false
            imagePicker.dismiss(animated: true) {
                switch self.setImage {
                case 101:
                    self.voterIDFront.image = image
                    self.idFrontselected = true
                    break
                case 102:
                    self.voterIDBack.image = image
                    self.idBackselected = true
                    break
                case 201:
                    self.vehicleIDFront.image = image
                    self.vIdFrontselected = true
                    break
                case 202:
                    self.vehicleIDBack.image = image
                    self.vIdBackselected = true
                    break
                default:
                    break
                    
                }
            }
        }
        }else{
            super.doneButtonDidPress(imagePicker, images: images)
        }
    }
}
