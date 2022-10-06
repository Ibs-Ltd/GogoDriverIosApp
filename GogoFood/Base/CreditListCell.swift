//
//  CreditListCell.swift
//  User
//
//  Created by Apple on 09/08/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class CreditListCell: UITableViewCell {

    @IBOutlet weak var agentALbl: UILabel!
    @IBOutlet weak var topUpLbl: UILabel!
    @IBOutlet weak var amntLbl: UILabel!
      @IBOutlet weak var createdLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func initWith(_ withData: CreditInfo)  {
        agentALbl.text = "By \(withData.credited_by?.capitalized ?? "")"
        createdLbl.text = TimeDateUtils.getDateOnly(fromDate: withData.created_at ?? "")
        let totalStr =    String(format: "%.2f", withData.amount ?? 0.0)
        amntLbl.text =  "$\(totalStr)"
        topUpLbl.text =  "\(withData.type?.uppercased() ?? "")"
    }
}
