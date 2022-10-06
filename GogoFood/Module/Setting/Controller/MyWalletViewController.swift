//
//  MyWalletViewController.swift
//  User
//
//  Created by MAC on 30/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class MyWalletViewController: BaseTableViewController<BaseData> {

    @IBOutlet weak var recentActivityLbl: UILabel!
    @IBOutlet weak var topUpBtn: UIButton!
    @IBOutlet weak var balanceUSDLbl: UILabel!
    @IBOutlet var userImage : UIImageView!
    @IBOutlet var amountLbl : UILabel!
    @IBOutlet var idLbl : UILabel!
    
    @IBOutlet var noRecordLbl : UILabel!
    private let repo = MapRepository()
    
    var walletHistoryArray : [WalletHistory]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationLeftButton(NavigationTitleString.myWallet.localized())
        
        ServerImageFetcher.i.loadProfileImageIn(userImage, url: CurrentSession.getI().localData.profile.profile_picture ?? "")
        self.repo.walletHistoryAPI() { (data) in
            print(data)
            self.walletHistoryArray = data.walletHistory?.reversed()
            if self.walletHistoryArray.count == 0{
                self.noRecordLbl.isHidden = false
            }
            self.tableView.reloadData()
            self.amountLbl.text = String(format: "%.2f", data.userDetail?.walletBalance ?? 0.0)
            self.idLbl.text = String(format: "ID : %i", data.userDetail?.uid ?? 0)
        }
        
        balanceUSDLbl.text = "Balance (USD)".localized()
        recentActivityLbl.text = "Recent Activity".localized()
        topUpBtn.setTitle("Top Up".localized(), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.walletHistoryArray == nil{
            return 0
        }
        return self.walletHistoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellObj = tableView.dequeueReusableCell(withIdentifier: "WalletHistoryTableViewCell") as! WalletHistoryTableViewCell
        cellObj.titleLbl.text = self.walletHistoryArray[indexPath.row].remarks
        cellObj.subTitleLbl.text = self.walletHistoryArray[indexPath.row].type
        cellObj.amountLbl.text = String(format: "$ %.2f", self.walletHistoryArray[indexPath.row].amount ?? 0.0)
        cellObj.dateLbl.text = TimeDateUtils.getDataWithTime(fromDate: self.walletHistoryArray[indexPath.row].createdAt!)
        cellObj.selectionStyle = .none
        return cellObj
    }

}

class WalletHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLbl : UILabel!
    @IBOutlet var subTitleLbl : UILabel!
    @IBOutlet var amountLbl : UILabel!
    @IBOutlet var dateLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
