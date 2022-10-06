//
//  ToppingViewController.swift
//  GogoFood
//
//  Created by MAC on 27/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class ToppingViewController: BaseTableViewController<OptionData> {

    private let repo = SettingRepository()
   
    var onSave: ((_ item:[OptionData]) -> Void)!
    
        override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodOptionCell
        cell.initView(withData: self.allItems[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.allItems[indexPath.row].isSelected = !self.allItems[indexPath.row].isSelected
        self.tableView.reloadData()
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        self.onSave(self.allItems)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

class FoodOptionCell: BaseTableViewCell<OptionData> {
    @IBOutlet weak var optionName: UIButton!
    @IBOutlet weak var toppings: UILabel!
      @IBOutlet weak var toppingsPrice: UILabel!
    
    override func initView(withData: OptionData) {
        super.initView(withData: withData)
        optionName.isSelected = withData.isSelected
        optionName.setTitle(withData.addonName, for: .normal)
        toppings.text = withData.toppings?.compactMap({$0.topping_name ?? ""}).joined(separator: "\n")
        toppingsPrice.text = withData.toppings?.compactMap({($0.price ?? 00).description}).joined(separator: "\n")
        
    }
    

    
    
}
