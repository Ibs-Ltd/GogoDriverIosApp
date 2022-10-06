//
//  InviteeDetailViewController.swift
//  GogoFood
//
//  Created by MAC on 30/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class InviteDetailViewController: BaseTableViewController<BaseData> {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var enviteLbl: UILabel!
    @IBOutlet weak var earnLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    private let repo = MapRepository()
    
    var currentUser : CurrentUser!
    var levelListArray : [LevelList]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        createNavigationLeftButton(NavigationTitleString.inviteDetail)
        ServerImageFetcher.i.loadProfileImageIn(profileImage, url: CurrentSession.getI().localData.profile.profile_picture ?? "")
        
        let rightBtn = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(onClickMethod))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.callRefferListAPI()
    }
    
    func callRefferListAPI(){
        self.repo.referalDetailsListAPI() { (data) in
            print(data)
            self.levelListArray = data.levelList
            self.currentUser = data.currentUser
            self.tableView.reloadData()
            self.enviteLbl.text = data.currentUser?.totalInvited?.toString()
            self.earnLbl.text = String(format: "$ %.2f", (data.currentUser?.totalIncome)!)
            self.balanceLbl.text = String(format: "$ %.2f", (data.currentUser?.userDetail!.referalIncome)!+(data.currentUser?.userDetail!.rewards)!)
        }
    }
    
    @objc func onClickMethod() {
        let popupContent = AddAmountViewController.create(vcOBj:self)
        let cardPopup = SBCardPopupViewController(contentViewController: popupContent)
        cardPopup.show(onViewController: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.levelListArray != nil{
            return self.levelListArray.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notiCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LevelListTableViewCell
        notiCell.levelLbl.text = "Level \n" + (self.levelListArray[indexPath.row].level?.toString())!
        notiCell.invitedLbl.text = "Invited: " + (self.levelListArray[indexPath.row].invited?.toString())!
        notiCell.earnLbl.text = "Earned: " + (self.levelListArray[indexPath.row].earned?.toString())!
        notiCell.selectionStyle = .none
        return notiCell
    }

    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.levelListArray[indexPath.row].invited != 0{
            let vcObj = self.storyboard?.instantiateViewController(withIdentifier: "InviteListViewController") as! InviteListViewController
            vcObj.levelStr = self.levelListArray[indexPath.row].level?.toString()
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
}

class LevelListTableViewCell: UITableViewCell {
    
    @IBOutlet var levelLbl : UILabel!
    @IBOutlet var invitedLbl : UILabel!
    @IBOutlet var earnLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Int{
    func toString() -> String{
        let myString = String(self)
        return myString
    }
}
