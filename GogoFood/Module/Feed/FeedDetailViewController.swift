//
//  FeedDetailViewController.swift
//  Restaurant
//
//  Created by MAC on 22/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class FeedDetailViewController: BaseTableViewController<BaseData> {

   
    override func viewDidLoad() {
        nib = [TableViewCell.foodDetailTableViewCell.rawValue,
                TableViewCell.commentTableViewCell.rawValue]

        super.viewDidLoad()
        setNavigationTitleTextColor(NavigationTitleString.feed)
        #if User
       addCartButton()
        #endif
        createNavigationLeftButton(nil)
        // Do any additional setup after loading the view.
    }
    
   
    
    override func createNavigationLeftButton(_ withTitle: String?) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        imageView.image = UIImage(named: "backBtn")
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToBack))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
        let barBtn = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    @objc func navigateToBack() {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib[1]) as! CommentTableViewCell
            return cell
        }
        let c =  tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath) as! FoodDetailTableViewCell
        return c
        
    }
    
    
}
