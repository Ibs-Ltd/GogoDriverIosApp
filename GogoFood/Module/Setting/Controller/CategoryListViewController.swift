//
//  CategoryListViewController.swift
//  GogoFood
//
//  Created by MAC on 26/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class CategoryListViewController: BaseTableViewController<CategoryData> {

    
  
    private let repo = SettingRepository()
    override func viewDidLoad() {
        super.viewDidLoad()
    createNavigationLeftButton(NavigationTitleString.listCategory)
        
        createNavigationRightButton()
        // Do any additional setup after loading the view.
    }
    
    func createNavigationRightButton() {
        let b = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(onAddCategory))
        b.tintColor = AppConstant.primaryColor
        
      self.navigationItem.rightBarButtonItem = b
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategory()
    }
    
    func fetchCategory() {
        repo.getCategoryList { (categories) in
            if categories.categories.isEmpty {
                self.showAlert(msg: "No categories found")
            }else{
                self.allItems = categories.categories
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryItemCell
        c.initView(withData: self.allItems[indexPath.row])
        return c
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allItems[indexPath.row].canUserEdit {
            showCategoryCardWithPopup(self.allItems[indexPath.row])
        } else {
            showAlert(msg: AppStrings.permissionProhibited)
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func showCategoryCardWithPopup(_ data: CategoryData?) {
        let c = self.storyboard?.instantiateViewController(withIdentifier: "AddCategortyViewController") as! AddCategortyViewController
        c.categoryData = data
        c.onDismiss = {
            self.fetchCategory()
        }
        let cardPopup = SBCardPopupViewController(contentViewController: c)
        cardPopup.show(onViewController: self)
    }
    
   @objc func onAddCategory() {
        showCategoryCardWithPopup(nil)
    }
    

}


class CategoryItemCell: BaseTableViewCell<CategoryData>{
    @IBOutlet weak var cImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var dateAdded: UILabel!
    
    override func initView(withData: CategoryData) {
        super.initView(withData: withData)
        ServerImageFetcher.i.loadImageIn(cImage, url: withData.image ?? "")
        name.text = withData.cat_name ?? ""
        desc.text = withData.description ?? ""
        dateAdded.text = TimeDateUtils.getDateOnly(fromDate: withData.getCreatedTime())
    }
    
    
}
