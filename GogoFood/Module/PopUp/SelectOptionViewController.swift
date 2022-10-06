//
//  SelectOptionViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 15/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import SBCardPopup

class SelectOptionCellClass: BaseTableViewCell<Toppings> {
    
    @IBOutlet weak var toppingName: UIButton!
    var onSelectToping: ((_ toping: Toppings) -> Void)!
    
    
    override func awakeFromNib() {
        
    }
    
    override func initView(withData: Toppings) {
        super.initView(withData: withData)
        let topingName = (withData.topping_name ?? "") + " $" + (withData.price ?? 0.0).description
        
        
        toppingName.setTitle(topingName , for: .normal)
        self.toppingName.isSelected = withData.isSelected
        
    }
    
    
    func setCheckBox(_ addOn: OptionData!) {
        toppingName.setImage(UIImage(named: "circle"), for: .selected)
        toppingName.setImage(UIImage(named: "Ellipse 35"), for: .normal)
        if addOn.addonType == "multiple" {
            toppingName.setImage(UIImage(named: "ic_rectangualrCheck"), for: .selected)
            toppingName.setImage(UIImage(named: "ic_rectangualrUnCheck"), for: .normal)
        }
        
    }
    
    
    
    
    
    @IBAction func onSelectToping(_ sender: UIButton) {
      
        
    }
}



class SelectOptionViewController: BaseTableViewController<OptionData> {
    
    
    
    
    @IBOutlet weak var takeBtnOutlet: UIButton!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    private var selectedToping: [Toppings] = []
    var onSelectToping: ((_ topping: [Toppings])-> Void)!
    var showFromCart = false
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableViewHeight.constant = CGFloat(min(allItems.count * 120, 240))
        
        
        
//        if allItems.count == 1 {
//             self.preferredContentSize = CGSize(width: self.view.frame.width, height: 250)
//         tableViewHeight.constant = 150
//
//        }else{
//             self.preferredContentSize = CGSize(width: self.view.frame.width, height: 350)
//
//        }
        takeBtnOutlet.layer.cornerRadius = 15
        cancelBtnOutlet.layer.cornerRadius = 15
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell2")
        cell?.textLabel?.text = self.allItems[section].addonName
        cell?.textLabel?.textColor = AppConstant.primaryColor
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    
    
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! SelectOptionCellClass
        cell.setCheckBox(self.allItems[indexPath.section])
        cell.initView(withData: self.allItems[indexPath.section].toppings![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.allItems[indexPath.section].addonType != "multiple"  {
        self.allItems[indexPath.section].toppings?.forEach({$0.isSelected = false})
        }
        self.allItems[indexPath.section].toppings![indexPath.row].isSelected = !self.allItems[indexPath.section].toppings![indexPath.row].isSelected
      
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allItems[section].toppings!.count
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        onDismiss(sender)
     }
    
    @IBAction func takeBtnAction(_ sender: Any) {
        
        let toping = Array(self.allItems.compactMap({$0.toppings?.filter({$0.isSelected == true})}).joined())
        onSelectToping(toping)
    
        
        //        let vc = storyboard?.instantiateViewController(withIdentifier: "ApplyCoupenViewController") as! ApplyCoupenViewController
        //        let cardPopup = SBCardPopupViewController(contentViewController: vc)
        //        cardPopup.show(onViewController: self)
        
        
        
    }
    
}
