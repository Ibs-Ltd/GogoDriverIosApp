//
//  FoodCategoryViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 05/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class FoodCategoryViewController: BaseTableViewController<ProductData> {

    var category: CategoryData! = nil
    private let repo = HomeRepository()
    var restaurant: RestaurantProfileData!
    
    override func viewDidLoad() {
        nib = [TableViewCell.foodDetailTableViewCell.rawValue]
        super.viewDidLoad()
        self.createNavigationLeftButton(NavigationTitleString.foodCategory)
        self.addCartButton()
//        repo.getProductOf(categoryId: category.id.description, of: restaurant.id, limit: 10, page: 1) { (item) in
//            self.allItems = item.products
//            self.currentItems = self.allItems
//            self.tableView.reloadData()
//        }
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = super.tableView(tableView, cellForRowAt: indexPath) as! FoodDetailTableViewCell
        c.initView(withData: self.currentItems[indexPath.row])
        return c
        
    }
    
    
    
    
    
    
    @IBAction func openCart(_ sender: Any) {
//        let c: FoodInformationViewController = self.getViewController(.foodInformation, on: .setting)
//                     self.navigationController?.pushViewController(c, animated: true)
//        
//       self.navigationController?.pushViewController(Controller.foodInformation, avaibleFor: StoryBoard.food)
    }
    
}
