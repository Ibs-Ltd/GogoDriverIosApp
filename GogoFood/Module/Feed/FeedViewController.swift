//
//  FeedViewController.swift
//  GogoFood
//
//  Created by MAC on 19/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class FeedViewController: BaseTableViewController<BaseData> {
    
    
    override func viewDidLoad() {
        nib = [TableViewCell.foodDetailTableViewCell.rawValue]
        super.viewDidLoad()
        setNavigationTitleTextColor(NavigationTitleString.feed)
        #if User
        addCartButton()
        #elseif Restaurant
        print("Restaurant")
        #else
        createNavigationLeftButton(nil)
        #endif
        //self.navigationItem.hidesBackButton = false

        // Do any additional setup after loading the view.
    }
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodDetailTableViewCell") as! FoodDetailTableViewCell
        cell.soldLabel.isHidden = true
        return cell
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
    }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("detail")
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
    self.navigationController?.pushViewController(vc, animated: true)
    }

}
