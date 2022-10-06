//
//  SettingViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 10/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import SBCardPopup


class SettingCellClass: UITableViewCell {
    
    override func awakeFromNib() {
        
    }
}

class SettingViewController: BaseViewController<BaseData>, UITableViewDelegate, UITableViewDataSource {
    
    private let repo = AuthenticationRepository()
    @IBOutlet weak var tableViewOutlet: UITableView!
    let userImageArray = ["credit","wallet", "changeLanguage", "support", "signout", "version"]
    let userTitleArray = ["Credit".localized(),"My Wallet".localized(), "Change Language".localized(), "Support Center".localized(), "Sign Out".localized(), "Version".localized()]
    let profile = CurrentSession.getI().localData.profile
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem = UITabBarItem(title: NavigationTitleString.setting.localized(), image: #imageLiteral(resourceName: "setting_unselected"), selectedImage: nil)

        tableViewOutlet.tableFooterView = UIView()
        setNavigationTitleTextColor(NavigationTitleString.setting.localized())
        
    }

    override func createNavigationLeftButton(_ withTitle: String?) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        imageView.image = UIImage(named: "backBtn")
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToBack))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
        let barBtn = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    @objc func navigateToBack() {
        print("Back")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userImageArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "cell") as! SettingCellClass
        if indexPath.row == 0 {
            cell = SettingCellClass(style: .subtitle, reuseIdentifier: "cell")
        }else {
            cell = SettingCellClass(style: .value1, reuseIdentifier: "cell")
        }
        
        if indexPath.row == 2 {
            cell.detailTextLabel?.text = getCurrentLanguage()
        }
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 5 {
            cell.detailTextLabel?.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            cell.detailTextLabel?.textColor = .blue
            cell.accessoryType = .none
        }
        if indexPath.row == 5 {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = userTitleArray[indexPath.row]
        cell.imageView?.image = UIImage(named: userImageArray[indexPath.row])

        cell.selectionStyle = .none
        return cell
    }
    
    func getCurrentLanguage()->String{
        if let lang = UserDefaults.standard.value(forKey: "savedLang") as? String{
            if lang == "en"{
                return "English"
            }else if lang == "km"{
                return "ខ្មែរ"
            }else if lang == "zh"{
                return "中文"
            }
        }else{
            return "English"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(indexPath)
    }
    
    func setForCell(_ at: IndexPath) {
        
    }
    
    func didSelect(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc: CreditViewController = self.getViewController(.credits, on: .setting)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc: MyWalletViewController = getViewController(.myWallet, on: .setting)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let storyObj = UIStoryboard(name: "Setting", bundle: nil)
            let vcObj = storyObj.instantiateViewController(withIdentifier: "ChangeLanguageViewController") as! ChangeLanguageViewController
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
        case 3:
            let vc: SupportCenterViewController = self.getViewController(.support, on: .setting)
            vc.setViewForRestaurant = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            createLogout()
            break
        default:
            break
        }
    }
    
    func createLogout() {
        
        let alert = UIAlertController(title: "Logout".localized(), message: "Are you sure you want to sign out?".localized(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { (_) in
            self.repo.logoutUser(){ data in
                print(data)
                CurrentSession.getI().onLogout()
                AppDelegate.sharedAppDelegate()?.setFireBaseDelegate()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
  
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

