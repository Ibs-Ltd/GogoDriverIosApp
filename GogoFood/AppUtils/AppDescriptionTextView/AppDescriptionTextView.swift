//
//  AppDescriptionTextView.swift
//  GogoFood
//
//  Created by MAC on 29/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

@IBDesignable
class AppDescriptionTextView: BaseAppView, UITextViewDelegate {

    @IBOutlet weak private var descriptionText: UILabel!
    @IBOutlet weak private var textCount: UILabel!
    @IBOutlet weak private var textView: UITextView!
    
    private let maxText = 160
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSet()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSet()
    }
    
    

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
       commonSet()
    }
    
    func commonSet() {
         commonSetup("AppDescriptionTextView")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.text = AppStrings.enterDescription
        textView.delegate = self
        self.textCount.text = maxText.description
    }
    
    
    func setText(_ text: String) {
        self.textView.text = text
        setTextCount(text)
    }
    
    
   internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == AppStrings.enterDescription {
            textView.text = ""
        }
    }
    
   internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = AppStrings.enterDescription
        }
    }
    
    func getText() -> String {
        return textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        setTextCount(textView.text)
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        return (textView.text.count < 160)
    }
    
    func setTextCount(_ text: String) {
        self.textCount.text = "\(maxText - text.count) / \(maxText)"
        
        
    }

}
