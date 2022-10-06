//
//  NotificationViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 17/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class NotificationViewController: BaseTableViewController<BaseData> {
    
    @IBOutlet var noRecordView : UIView!
    private let repo = HomeRepository()
    var selectedIndexPath: IndexPath?
    var extraHeight: CGFloat = 90
    
    var notificationListArray : [NotificationList]!
    
    override func viewDidLoad() {
        nib = [TableViewCell.notificationTableViewCell.rawValue]
        super.viewDidLoad()
        self.setNavigationTitleTextColor(NavigationTitleString.notification.localized())
        self.tableView.tableFooterView = UIView()
        
        self.repo.notificationListAPI() { (data) in
            print(data)
            self.notificationListArray = data.notifications?.reversed()
            if self.notificationListArray.count == 0{
                self.noRecordView.isHidden = false
            }else{
                self.noRecordView.isHidden = true
            }
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.notificationListArray != nil{
            return self.notificationListArray.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCellNew") as! NotificationTableViewCellNew
        let cellDic = self.notificationListArray[indexPath.row]
        cell.titleLbl.text = cellDic.notificationId?.title ?? ""
        cell.subtitle.text = cellDic.notificationId?.descriptionField ?? ""
        cell.dateLbl.text = TimeDateUtils.getDateOnly(fromDate: cellDic.notificationId!.createdAt!)
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.selectedIndexPath = indexPath
        //tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndexPath == indexPath {
            return 60 + extraHeight
        }
        return UITableView.automaticDimension
    }
    
    func estimatedLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        return rectangleHeight
    }
}

class NotificationTableViewCellNew: UITableViewCell {
    
    @IBOutlet var titleLbl : UILabel!
    @IBOutlet var subtitle : UILabel!
    @IBOutlet var dateLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
