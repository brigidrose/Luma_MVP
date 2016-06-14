//
//  TextViewTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/10/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import SZTextView
class TextViewTableViewCell: UITableViewCell {

    var textView:SZTextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        textView = SZTextView(frame: CGRectZero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFontOfSize(17)
        textView.placeholder = "What's this moment about?"
        contentView.addSubview(textView)
        
        let viewsDictionary = ["textView":textView]
        let metricsDictionary = ["sidePadding":15]
        
        let textViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[textView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let textViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-sidePadding-[textView(>=150)]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(textViewH)
        contentView.addConstraints(textViewV)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
