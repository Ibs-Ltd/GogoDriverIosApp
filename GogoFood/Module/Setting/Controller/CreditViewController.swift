//
//  CreditViewController.swift
//  Driver
//
//  Created by MAC on 30/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class CreditViewController: BaseTableViewController<BaseData> {

    @IBOutlet weak var topUpHistoryLbl: UILabel!
    @IBOutlet weak var addCreditBtn: UIButton!
    @IBOutlet weak var currentBalancrLbl: UILabel!
    
    @IBOutlet weak var lbl_amnt: UILabel!
    private let repo = OrderRepository()

    private var creditsOfDriver = CreditData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationLeftButton(NavigationTitleString.credit.localized())
        currentBalancrLbl.text = "Current Balance".localized()
        addCreditBtn.setTitle("Add Credit".localized(), for: .normal)
        topUpHistoryLbl.text = "Top up history".localized()
        getCredit()
        // Do any additional setup after loading the view.
    }
    
    fileprivate  func getCredit(){
        repo.creditHistory { (data) in
            self.creditsOfDriver = data
            let total = data.credit.compactMap({($0.amount ?? 0)}).reduce(0,+)
            let totalStr =    String(format: "%.2f", total)
            self.lbl_amnt.text = "$\(totalStr)"
            //self.allItems = data.newOrder
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CreditListCell
        cell.topUpLbl.text = "Top Up".localized()
        cell.agentALbl.text = "Top Up From Agent A".localized()
        cell.initWith(creditsOfDriver.credit[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditsOfDriver.credit.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
