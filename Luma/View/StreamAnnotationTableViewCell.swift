//
//  StreamAnnotationTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/14/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import TTTAttributedLabel
class StreamAnnotationTableViewCell: UITableViewCell {

    var label:TTTAttributedLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label = TTTAttributedLabel(frame: CGRectZero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Annotation Text")
        label.font = UIFont.systemFontOfSize(13, weight: UIFontWeightMedium)
        label.textAlignment = .Center
        contentView.addSubview(label)
        
        let viewsDictionary = ["label":label]
        let metricsDictionary = ["sidePadding":15]
        let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[label]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[label]-20-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(constraintsH)
        contentView.addConstraints(constraintsV)
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
