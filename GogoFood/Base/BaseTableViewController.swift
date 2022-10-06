//
//  BaseTableViewController.swift
//  zoukMikael
//
//  Created by admni on 04/02/19.
//  Copyright © 2019 Crinoid. All rights reserved.
//


import UIKit

class BaseTableViewController<T: BaseData>: BaseViewController<T>, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar?
   
   
    var allItems: [T] = []
    var currentItems: [T] = []
    var nib: [String]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.setBackground(color: UIColor.groupTableViewBackground)
        
        //self.register([])
        register(nib)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar?.delegate = self
      //  self.searchBar?.barTintColor = CurrentSession.getI().localData.appColor.tabColor
        // Do any additional setup after loading the view.
    }
    
    
    func register(_ nibs: [String]) {
        nibs.forEach { (nib) in
            self.tableView.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        }

    }

    func onGetResponse(_ response: [T]) {
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath)
            configureCell(cell: cell, forRowAt: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath)
            configureCell(cell: cell, forRowAt: indexPath)
            return cell
        }
      
    }
    
    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func onChangeCartItem(notification: Notification) {
        super.onChangeCartItem(notification: notification)
    }
    
    
}
