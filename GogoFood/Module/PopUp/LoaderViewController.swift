//
//  LoaderViewController.swift
//  GogoFood
//
//  Created by MAC on 13/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {

    @IBOutlet weak var loader: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateLayerInfinite()
        // Do any additional setup after loading the view.
    }
    
    
    
    func rotateLayerInfinite() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        loader?.layer.add(rotation, forKey: "rotationAnimation")
    }
  
}
