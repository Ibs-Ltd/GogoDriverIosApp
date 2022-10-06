//
//  IntialViewController.swift
//  GogoFood
//
//  Created by MAC on 28/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import Foundation

class IntialViewController: BaseViewController<BaseData> {

    @IBOutlet weak var loader: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rotateLayerInfinite()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.setScreenAsPerUser()
        }
    }

    func showLoginScreen() {
        self.performSegue(withIdentifier: "start", sender: self)
    }
    
    #if User
    func setScreenAsPerUser() {
        if let user = CurrentSession.getI().localData.profile {
            if (user.userStatus ?? .exsisting) == .exsisting {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Controller.userTab.rawValue)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                showLoginScreen()
            }
        }else{
         showLoginScreen()
        }
    }
    
    #elseif Driver
    func setScreenAsPerUser() {
        if let user = CurrentSession.getI().localData.profile {
            if user.user_status == "existing" {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Controller.driverTab.rawValue)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                showLoginScreen()
            }
        }else{
            showLoginScreen()
        }
    }
    #endif
    
    func rotateLayerInfinite() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 2 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        loader?.layer.add(rotation, forKey: "rotationAnimation")
    }
    

}
