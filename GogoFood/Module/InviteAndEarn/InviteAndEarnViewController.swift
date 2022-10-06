//
//  InviteAndEarnViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 17/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import MessageUI
import Branch

class InviteAndEarnViewController: BaseViewController<BaseData>, MFMessageComposeViewControllerDelegate {

    @IBOutlet var codeLblSocial : UILabel!
    @IBOutlet var codeLblSMS : UILabel!
    @IBOutlet weak var inviteWithQRCodeLbl: UILabel!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var inviteFriendSMSLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var inviteFriendLbl: UILabel!
    @IBOutlet weak var inviteDetailBtn: UIBarButtonItem!
    var shareLink = ""
    @IBOutlet weak var qr_Imga: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        generateLink { (link) in
            self.shareLink = link
            self.qr_Imga.image = self.generateQRCode(from: link)
        }
       // self.createNavigationLeftButton(NavigationTitleString.inviteAndEarn)
        self.codeLblSocial.text = CurrentSession.getI().localData.profile.referal_code ?? "N/A"
        self.codeLblSMS.text = CurrentSession.getI().localData.profile.referal_code ?? "N/A"
        setNavigationTitleTextColor(NavigationTitleString.inviteAndEarn.localized())
        inviteFriendLbl.text = "Invite Friend via social media".localized()
        inviteDetailBtn.title = "Invite Detail".localized()
        inviteFriendSMSLbl.text = "Invite Friend via SMSs".localized()
        inviteWithQRCodeLbl.text = "Invite with QR Code".localized()
        shareBtn.setTitle("SHARE".localized(), for: .normal)
    }
    @IBAction func showInviteDetail(_ sender: UIBarButtonItem) {
        let vc: InviteDetailViewController = self.getViewController(.inviteDetail, on: .inviteAndEarn)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func shareOnSocialMedia(_ sender: UIButton) {
        let items = [self.shareLink] as [Any]
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        navigationController?.present(controller, animated: true) {() -> Void in }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    
    @IBAction func shareOnSMS(_ sender: UIButton) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = self.shareLink
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    func generateLink(completion:@escaping (String) -> ()) {
        let buo = BranchUniversalObject(canonicalIdentifier: "GoGo Food")
        buo.title = "Gogo Partner"
        buo.contentDescription = "Food Delivery Expert"
        buo.publiclyIndex = false
        buo.locallyIndex = false
        let userLP: BranchLinkProperties =  BranchLinkProperties()
    //    userLP.addControlParam("referCode", withValue: CurrentSession.getI().localData.profile.referal_code ?? "")
        buo.getShortUrl(with: userLP) { (userURL, userError) in
            if userError == nil {
                completion(userURL ?? "")
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
