//
//  AddMenuItemViewController.swift
//  Restaurant
//
//  Created by MAC on 22/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SBCardPopup
//import Gallery
import ImagePicker

class AddMenuItemViewController: BaseViewController<ProductData>, ImagePickerDelegate {
    
    @IBOutlet weak var itemName: AppTextField!
    @IBOutlet weak var itemCategory: AppTextField!
    @IBOutlet weak var itemPrice: AppTextField!
    @IBOutlet weak var recommend: AppTextField!
    @IBOutlet weak var descriptionField: AppDescriptionTextView! //
    @IBOutlet weak var extra: AppTextField!
    @IBOutlet var discount: [AppRadioButton]!
    @IBOutlet weak var discountPercentage: AppTextField!
    @IBOutlet weak var couponCode: AppTextField!
    @IBOutlet weak var saveButton: AppButton!
    private let repo = SettingRepository()
    @IBOutlet weak var productStatusSwitch: UISwitch!
    var product: ProductData!
    let productPostData = ProductPostData()
    
    // for image related
    @IBOutlet var productImageViews: [UIImageView]!
    private var currentImagePointer = 0
    var imageSelected = true
    
    
    private var disountType = 0 // 0 - none, 1 - percentage, 2 - coupon
    private let discountItemName = ["None", "Percent", "Coupon"]
    private var addOns: [OptionData] = []
    
    
    
    // categoryRelated
    private  var categoryData: [CategoryData] = []
    private var selectedCategory: CategoryData!
    
    // topings
    
    private var allToping: [String] = []
    private var selectedToping: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.createNavigationLeftButton(NavigationTitleString.addMenuItem)
        fetchOptionData()
       
       
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        itemName.initiateView(type: .qwertyKeyBoardType, infoText: AppStrings.itemName, placeHolder: AppStrings.itemName)
        itemName.voidCallBack = {}
        itemCategory.initiateView(type: .dropDown, infoText: AppStrings.category, placeHolder: AppStrings.selectCategory)
        recommend.initiateView(type: .dropDown, infoText: AppStrings.itemInfo, placeHolder: AppStrings.selectRecommend)
        itemPrice.initiateView(type: .decimalPad, infoText: AppStrings.itemPrice, placeHolder: AppStrings.itemPrice)
        itemPrice.voidCallBack = {}
        recommend.initiateView(type: .dropDown, infoText: AppStrings.recommends, placeHolder: AppStrings.selectRecommend)
        
        
        discountPercentage.initiateView(type: .numPad, infoText: AppStrings.discountPercentage, placeHolder: AppStrings.enterPercentage)
        discountPercentage.voidCallBack = {}
        couponCode.initiateView(type: .withoutImage, infoText: AppStrings.couponCode, placeHolder: AppStrings.enterCouponCode)
        couponCode.voidCallBack = {}
        setViewForExtra()
        setSaveButton()
        setDiscountType()
        setCategory()
        setRecommended()
    }
    
    
    func setDiscountType(){
        self.discount.forEach({ (btn) in
            btn.setSelected(btn.tag == self.disountType)
            self.couponCode.isHidden = !(self.disountType == 2)
            self.discountPercentage.isHidden = (self.disountType == 0)
        })
        self.discount.forEach { (button) in
            button.initView(type: .redRound, title: self.discountItemName[button.tag])
            button.voidCallBack = {
                self.disountType = button.tag
                self.setDiscountType()
            }
        }
        self.view.layoutIfNeeded()
        
    }
    
    func setViewForExtra() {
        extra.initiateView(type: .withoutImage, infoText: AppStrings.extra, placeHolder: AppStrings.extraPlaceholderTExt)
        extra.voidCallBack = {
            if self.addOns.isEmpty{
                self.showAlert(msg: "No options to add with this item")
                return
            }
            self.extra.endEditing(true)
            let c = self.storyboard?.instantiateViewController(withIdentifier: Controller.options.rawValue) as! ToppingViewController
            c.allItems = self.addOns
            c.onSave = {options in
                self.addOns = options
                self.extra.setText(self.self.addOns.filter({$0.isSelected == true}).compactMap({($0.addonName ?? "")}).joined(separator: ","))
            }
            let cardPopup = SBCardPopupViewController(contentViewController: c)
            cardPopup.show(onViewController: self)
            
        }
    }
    
    func fetchOptionData() {
        repo.getToppingOptions { (data) in
            self.addOns = data.options
            if let _ = self.product {
                self.selectedCategory = self.product.category_id
                self.setProductData()
                data.id = self.product.id
            }
        }
    }
    
    
    func isDataValid() -> Bool {
        
        if itemName.getText().isEmpty {
            showAlert(msg: "Item name shouldn't be empty")
            return false
        }
        
        if itemCategory.getText().isEmpty {
            showAlert(msg: "Please Select a category")
            return false
        }
        
        if recommend.getText().isEmpty {
            showAlert(msg: "In recommendation there should be a choice")
            return false
        }
        
        if (Double(itemPrice.getText()) ?? 0.0) <= 0.0 {
            showAlert(msg: "Please enter a valid item price")
            return false
        }
        
        if disountType == 1 {
            if (Int(discountPercentage.getText().replacingOccurrences(of: "%", with: "")) ?? 0) <= 0 {
                showAlert(msg: "Please enter a valid percentage amount")
                return false
            }
        }
        
        if disountType == 2 {
            if (Int(discountPercentage.getText().replacingOccurrences(of: "%", with: "")) ?? 0) <= 0 {
                showAlert(msg: "Please enter a valid percentage amount")
                return false
            }
            if couponCode.getText().isEmpty {
                showAlert(msg: "Coupon Code must have a valid text")
                return false
            }
        }
        
        if !imageSelected{
            showAlert(msg: "Please select atleast one image")
            return false
        }
        
        return true
    }
    
    func setCategory() {
        if categoryData.isEmpty{
            repo.getCategoryList { (data) in
                self.categoryData = data.categories
            }
        }
        
       
        
        itemCategory.voidCallBack = {
            
            var category: [String] = self.categoryData.compactMap({$0.cat_name ?? ""})
            category.insert("Add a category", at: 0)
            self.showActionPicker(self.itemCategory, data: category, pickerName: "Select a category") { (index) in
                if index == 0 {
                    
                    let c = self.storyboard?.instantiateViewController(withIdentifier: "AddCategortyViewController") as! AddCategortyViewController
                    c.categoryData = nil
                    c.onDismiss = {
                        self.categoryData.removeAll()
                        self.setCategory()
                    }
                    let cardPopup = SBCardPopupViewController(contentViewController: c)
                    cardPopup.show(onViewController: self)
                    
                }else{
                    // index -1 becuase we appended a text from our side
                    self.selectedCategory = self.categoryData[index - 1]
                    self.itemCategory.setText(self.selectedCategory.cat_name ?? "")
                }
                
                
            }
        }
    }
    
    func setRecommended() {
        let recommendation = ["Yes", "No"]
        recommend.voidCallBack = {
            self.showActionPicker(self.recommend, data: recommendation, pickerName: "Is recommended") { (index) in
                self.recommend.setText(recommendation[index])
            }
        }
    }
    
    private func showActionPicker(_ sender: UIView, data: [String], pickerName: String,  onComplition: @escaping (_ value: Int) -> Void) {
        if data.isEmpty{
            showAlert(msg: "No item to choose")
            return
        }
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        ActionSheetMultipleStringPicker.show(withTitle: pickerName, rows: [data], initialSelection: [0], doneBlock: {
            picker, indexes, values in
            if let items = indexes as? [Int] {
                if let index = items.first {
                    onComplition(index)
                }
            }
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
    }
    
    func setProductData() {
        itemName.setText(product.name ?? "")
        itemPrice.setText((product.price ?? 0.0).description)
        recommend.setText(product.is_recomend ?? "")
        descriptionField.setText(product.description ?? "")
        discountPercentage.setText((product.discount_percentage ?? 0).description)
        couponCode.setText(product.coupon_code ?? "")
        itemCategory.setText(selectedCategory.cat_name ?? "")
        productStatusSwitch.isOn = product.isActive
        ServerImageFetcher.i.loadImageIn(productImageViews.first!, url: product.image ?? "")
        self.imageSelected = true
       
        self.addOns.forEach({$0.isSelected = (self.product.options?.contains($0.id) ?? false)})
       
        
        self.extra.setText(self.addOns.filter({$0.isSelected == true}).compactMap({$0.addonName}).joined(separator: ","))
        self.disountType =  product.discount_type == "none" ? 0 : product.discount_type == "percentage" ? 1 : 2
        self.setDiscountType()
        
    }
    
    func setSaveButton() {
        saveButton.initButton(type: .red, text: AppStrings.save, image: nil)
        self.saveButton.voidCallBack = {
            if self.isDataValid() {
                let data = self.productPostData
                if let product = self.product {
                    data.id = product.id
                }
                data.productImage = self.productImageViews.first?.image
                data.name = self.itemName.getText()
                data.catedoryId = self.selectedCategory.id.description
                data.price = Double(self.itemPrice.getText()) ?? 0.0
                //data.productImage =
                data.is_recomend = self.recommend.getText()
                data.description = self.descriptionField.getText()
                data.discount_type = self.disountType == 0 ? "none" : self.disountType == 1 ? "percentage" : "coupon"
                data.coupon_code = self.couponCode.getText()
                data.discount_percentage = Int(self.discountPercentage.getText()) ?? 0
                data.options = self.addOns.filter({$0.isSelected == true}).compactMap({$0.id})
                self.repo.modifyProductList(withAdd: (self.product == nil), data: data, onComplition: { (_) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
                
            }}
    }
    
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
       
    }
    @IBAction func selectFirstImage(_ sender: UITapGestureRecognizer) {
        currentImagePointer = 0
        showImagePicker(5)
    }
    
    @IBAction func secondImagePicker(_ sender: UITapGestureRecognizer) {
        currentImagePointer = 1
        showImagePicker(4)
    }
    
    @IBAction func thirdImagePicker(_ sender: UITapGestureRecognizer) {
        currentImagePointer = 2
        showImagePicker(3)
    }
    
    @IBAction func fourthImagePicker(_ sender: Any) {
        currentImagePointer = 3
        showImagePicker(2)
    }
    @IBAction func fifthImagePicker(_ sender: Any) {
        currentImagePointer = 4
        showImagePicker(1)
    }
    
    
    
    func showImagePicker(_ withLimit: Int) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = withLimit
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func setProductStatus(_ sender: UISwitch) {
        sender.isEnabled = false
        if self.product == nil {
            showAlert(msg: "you can't change the status of new product")
            sender.setOn(true, animated: true)
            return
        }
        self.repo.changeProductStatus(ofId: self.product.id) { (_) in
            sender.isEnabled = true
        }
        
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for i in 0..<images.count {
            productImageViews.forEach { (imageView) in
                if imageView.tag == currentImagePointer {
                    imageView.image = images[i]
                 }
            }
            currentImagePointer += 1
        }
        self.imageSelected = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
   
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
     
}
