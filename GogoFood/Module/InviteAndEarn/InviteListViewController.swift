//
//  InviteListViewController.swift
//  GogoFood
//
//  Created by MAC on 30/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class InviteListViewController: BaseTableViewController<BaseData> {

    private let repo = MapRepository()
    var inviteListArray : [InviteListData]!
    
    var levelStr : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        createNavigationLeftButton(NavigationTitleString.inviteList)
        
        self.repo.inviteListAPI(self.levelStr) { (data) in
            print(data)
            self.inviteListArray = data.inviteListData
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inviteListArray == nil{
            return 0
        }
        return self.inviteListArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellObj = tableView.dequeueReusableCell(withIdentifier: "InviteListTableViewCell") as! InviteListTableViewCell
        let cellDic = self.inviteListArray[indexPath.row]
        cellObj.idLbl.text = cellDic.uid?.toString() ?? ""
        cellObj.nameLbl.text = cellDic.name ?? ""
        cellObj.phoneLbl.text = cellDic.mobile ?? ""
        cellObj.levelLbl.text = String(format: "L-%@", self.levelStr)
        cellObj.earnLbl.text = cellDic.referalIncome?.toString() ?? ""
        cellObj.dateLbl.text = TimeDateUtils.getDateOnly(fromDate: cellDic.createdAt!)
        cellObj.selectionStyle = .none
        return cellObj
    }
}

class InviteListTableViewCell: UITableViewCell {
    
    @IBOutlet var idLbl : UILabel!
    @IBOutlet var nameLbl : UILabel!
    @IBOutlet var phoneLbl : UILabel!
    @IBOutlet var levelLbl : UILabel!
    @IBOutlet var earnLbl : UILabel!
    @IBOutlet var dateLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
