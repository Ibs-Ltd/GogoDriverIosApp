//
//  BaseCollectionViewController.swift
//  globalCart
//
//  Created by Crinoid Mac Mini on 16/03/19.
//  Copyright © 2019 Crinoid. All rights reserved.
//

import UIKit


class BaseCollectionViewController<T: BaseData>: BaseViewController<T>,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allItems: [T] = []
    var currentItems: [T] = []
    final var nib: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib(nibs: nib)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // Do any additional setup after loading the view.
    }
    
    
    func registerNib(nibs: String) {
     
            let nibName = UINib(nibName: nib, bundle:nil)
            collectionView.register(nibName, forCellWithReuseIdentifier: nib)

    }


     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return currentItems.count
        return currentItems.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nib, for: indexPath) 
        //cell.data = allItems[indexPath.row]
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

   
     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
  
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 

  
     func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

     func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        return
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 1.3
        return CGSize(width: width, height: 90)
    }
    
}
