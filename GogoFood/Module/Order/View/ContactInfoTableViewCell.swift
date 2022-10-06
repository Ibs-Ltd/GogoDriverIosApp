//
//  ContactInfoTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 04/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: BaseTableViewCell<ProfileData> {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func initView(withData: ProfileData) {
        super.initView(withData: withData)
        if withData.profile_picture != nil{
            ServerImageFetcher.i.loadProfileImageIn(userImage, url: withData.profile_picture ?? "")
        }
        nameLabel.text = withData.name
        emailLabel.text = withData.email ?? "Email not exist!"
        phoneNoLabel.text = withData.mobile
    }
    

}
