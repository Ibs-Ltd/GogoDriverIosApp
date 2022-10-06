//
//  ChangeLanguageViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 08/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import Localize_Swift




class ChangeLanguageCellClass: UITableViewCell {
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var selectBtnOutlet: UIButton!

    override func awakeFromNib() {
        selectBtnOutlet.layer.cornerRadius = selectBtnOutlet.frame.height / 2
        selectBtnOutlet.layer.borderColor = UIColor.red.cgColor
        selectBtnOutlet.layer.borderWidth = 0.8
    }
}

class ChangeLanguageViewController: BaseViewController<BaseData>, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    
    var countryArray: [String]!
    var flagCountryArray: [String]!
    var isSelected: Int!
    private var selectedLanguage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationLeftButton(NavigationTitleString.changeLangauges.localized())
        countryArray = ["Khmer".localized(), "English".localized(), "Chinese".localized()]
        flagCountryArray = ["khmer-flag", "english-flag", "chinese-flag"]
        tableViewOutlet.tableFooterView = UIView()
        saveBtnOutlet.layer.cornerRadius = saveBtnOutlet.frame.height / 2
        saveBtnOutlet.setTitle("SAVE".localized(), for: .normal)
        tableViewOutlet.separatorColor = .black
        getSavedLanguagePreference()
    }
    
    
    private func getSavedLanguagePreference(){
        if let lang = UserDefaults.standard.value(forKey: "savedLang") as? String{
            selectedLanguage = lang
            getSavedLangIndex(lang: lang)
        }else{
            selectedLanguage = "en"
            isSelected = 1
        }
    }
    
    private func getSavedLangIndex(lang: String){
        if lang == "en"{
            isSelected = 1
        }else if lang == "km"{
            isSelected = 0
        }else if lang == "zh"{
            isSelected = 2
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "cell") as! ChangeLanguageCellClass
        cell.countryNameLabel.text = countryArray[indexPath.row]
        cell.imageViewOutlet.image = UIImage(named: flagCountryArray[indexPath.row])
        if isSelected == indexPath.row {
            cell.selectBtnOutlet.setImage(UIImage(named: "circle"), for: .normal)
        } else {
            cell.selectBtnOutlet.setImage(nil, for: .normal)
        }
        cell.selectBtnOutlet.tag = indexPath.row
        cell.selectBtnOutlet.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func selectImage(sender: UIButton) {
        print("called", sender.tag)
        isSelected = sender.tag
        selectLanguage(sender: sender)
        tableViewOutlet.reloadData()
        print(self.selectedLanguage)
    }
    
    private func selectLanguage(sender: UIButton){
        switch sender.tag {
        case 0:
            self.selectedLanguage = "km"
        case 1:
            self.selectedLanguage = "en"
        case 2:
            self.selectedLanguage = "zh"
        default:
            break;
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        UserDefaults.standard.set(selectedLanguage, forKey: "savedLang")
        Localize.setCurrentLanguage(selectedLanguage)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "inital")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
