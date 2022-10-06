//
//  ViewProfileViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 08/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import ImagePicker
import RSKImageCropper


class ViewProfileViewController: BaseViewController<ProfileData> {


    @IBOutlet weak var profilePicOutlet: UIImageView!
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var phoneNoTextFieldOutlet: UITextField!
    
    
    
    var imageSelected = false
    private let repo = SettingRepository()
    
//for driver
   
    @IBOutlet weak var vehicalNumber: TextField!
    
    @IBOutlet weak var vehicalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtnOutlet.layer.cornerRadius = saveBtnOutlet.frame.height / 2
        profilePicOutlet.layer.cornerRadius = profilePicOutlet.frame.height / 2
        profilePicOutlet.layer.borderWidth = 1.0
        profilePicOutlet.layer.borderColor = UIColor.lightGray.cgColor
      

        nameTextFieldOutlet.layer.borderWidth = 1.0
        nameTextFieldOutlet.layer.borderColor = UIColor.lightGray.cgColor
        nameTextFieldOutlet.layer.cornerRadius = nameTextFieldOutlet.frame.height / 2

        phoneNoTextFieldOutlet.layer.borderWidth = 1.0
        phoneNoTextFieldOutlet.layer.borderColor = UIColor.lightGray.cgColor
        phoneNoTextFieldOutlet.layer.cornerRadius = phoneNoTextFieldOutlet.frame.height / 2
        self.phoneNoTextFieldOutlet.text = self.data?.mobile
        self.nameTextFieldOutlet.text = self.data?.name
        if let i = self.data?.profile_picture {
            ServerImageFetcher.i.loadProfileImageIn(profilePicOutlet
                , url: i)
            imageSelected = true
        }
        
        createNavigationLeftButton("Profile")
        
        #if Driver
        self.vehicalStackView.isHidden = false
        vehicalNumber.layer.borderWidth = 1.0
        vehicalNumber.layer.borderColor = UIColor.red.cgColor
        vehicalNumber.layer.cornerRadius = nameTextFieldOutlet.frame.height / 2
        #else
        self.vehicalStackView.isHidden = true
        #endif
        
        
    }

    
    
   
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if nameTextFieldOutlet.text!.isEmpty {
            showAlert(msg: "Please Enter your name")
            return
        }
        if !imageSelected {
              showAlert(msg: "Please Select your image")
            return
        }
        
        
        
        repo.updateUserProfile(name: nameTextFieldOutlet.text!, phoneNumber: nil, image: (self.profilePicOutlet.image?.jpegData(compressionQuality: 0.5)!)!, userStatus: data?.user_status ?? "", email: nil) { (data) in
                CurrentSession.getI().localData.profile = data.profile
                CurrentSession.getI().saveData()
           
                self.navigationController?.present(.userTab, on: .main)
           
            
            
        }
        
        
        
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visibleNavigationBar()
    }
    
}

extension ViewProfileViewController: ImagePickerDelegate, RSKImageCropViewControllerDelegate{
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        profilePicOutlet.image = croppedImage
        controller.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if let image = images.first{
            imagePicker.dismiss(animated: true) {
                let imageCropVC = RSKImageCropViewController(image: image)
                imageCropVC.delegate = self
                self.present(imageCropVC, animated: true, completion: nil)
                self.imageSelected = true
            }
          
        }
        
       
        
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
