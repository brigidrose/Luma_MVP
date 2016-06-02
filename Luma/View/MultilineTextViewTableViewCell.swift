//
//  MultilineTextViewTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/19/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import SZTextView

class MultilineTextViewTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var textView:SZTextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        textView = SZTextView(frame: CGRectZero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeholder = "Placeholder"
        textView.placeholderTextColor = UIColor.lightGrayColor()
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.returnKeyType = .Done
        textView.delegate = self
        contentView.addSubview(textView)

        let viewsDictionary = ["textView":textView]
        let metricsDictionary = ["sidePadding":11]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[textView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[textView(100)]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(hConstraints + vConstraints)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        else{
            return true
        }
    }

}
