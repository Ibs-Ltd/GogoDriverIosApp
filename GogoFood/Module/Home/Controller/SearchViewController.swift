//
//  SearchViewController.swift
//  GogoFood
//
//  Created by MAC on 19/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    


}
