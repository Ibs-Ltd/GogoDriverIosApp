//
//  RateDriverScreeenViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 15/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class RateDriverScreeenViewController: BaseViewController<BaseData>, UITextViewDelegate {

    @IBOutlet weak var commentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self
        commentTextView.layer.borderColor = UIColor.darkGray.cgColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.text = AppStrings.enterCommentHere
        commentTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.textColor == UIColor.lightGray {
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.isEmpty {
            commentTextView.text = AppStrings.enterCommentHere
            commentTextView.textColor = UIColor.lightGray
        }
    }

}
