//
//  File.swift
//  GogoFood
//
//  Created by MAC on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func present(_ viewController: Controller, on storyBoard: StoryBoard) {
        let sb = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController.rawValue)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
}
