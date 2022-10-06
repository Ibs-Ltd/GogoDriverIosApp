//
//  CollectionInTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 15/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class BaseCollectionViewInTableViewCell<T: BaseData> : BaseTableViewCell<T>, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nib: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        registerNib()
    }
    func initView(withData: [T]) {
        self.data = withData
    }
    
    func registerNib() {
         collectionView.register(UINib(nibName: nib, bundle: nil), forCellWithReuseIdentifier: nib)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: nib, for: indexPath)
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width - 10) / 2
            return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
