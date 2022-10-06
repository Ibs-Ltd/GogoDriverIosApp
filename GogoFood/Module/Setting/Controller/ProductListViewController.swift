//
//  ProductListViewController.swift
//  Restaurant
//
//  Created by MAC on 26/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class ProductListViewController: BaseTableViewController<ProductData> {
    
    
    private let repo = SettingRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationLeftButton(NavigationTitleString.listFood)
              createNavigationRightButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repo.getProductList { (data) in
            self.allItems = data.products
            self.tableView.reloadData()
        }
      
    }
     func createNavigationRightButton() {
        let b = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(navigateToAddMenuItem))
        b.tintColor = AppConstant.primaryColor
        
        self.navigationItem.rightBarButtonItem = b
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let c =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantProductTableViewCell
        c.initView(withData: allItems[indexPath.row])
        c.onChangeStatus = {
            c.activeStatus.isEnabled = false
            self.repo.changeProductStatus(ofId: (self.allItems[indexPath.row].id), onComplition: { (_) in
                c.activeStatus.isEnabled = true
               // c.activeStatus.setOn(!c.activeStatus.isOn, animated: true)
            })
            
            
        }
    return c
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = self.storyboard?.instantiateViewController(withIdentifier: "AddMenuItemViewController") as! AddMenuItemViewController
        c.product = self.allItems[indexPath.row]
        self.navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func navigateToAddMenuItem() {
        let c = self.storyboard?.instantiateViewController(withIdentifier: "AddMenuItemViewController") as! AddMenuItemViewController
        
        self.navigationController?.pushViewController(c, animated: true)
    }
}



class RestaurantProductTableViewCell: BaseTableViewCell<ProductData> {
    var onChangeStatus: (()->Void)!
    @IBOutlet weak var productImage: UIImageView!
     @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var activeStatus: UISwitch!
    
    @IBAction func changeStatus(_ sender: UISwitch) {
        onChangeStatus()
        
    }
    
    override func initView(withData: ProductData) {
        super.initView(withData: withData)
        ServerImageFetcher.i.loadImageIn(productImage, url: withData.image ?? "")
        productName.text = withData.name ?? ""
        price.attributedText = withData.getFinalAmount(stikeColor: AppConstant.appGrayColor, normalColor: UIColor.black, fontSize: 12, inSameLine: true)
        category.text = (withData.category_id ?? CategoryData()).cat_name ?? ""
        date.text = TimeDateUtils.getDateOnly(fromDate: withData.getCreatedTime())
        activeStatus.isOn = withData.isActive
        
    }
    
   
    
}
