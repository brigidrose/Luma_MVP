//
//  ActionRowTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/14/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class ActionRowTableViewCell: UITableViewCell {

    var actionLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        actionLabel = UILabel(frame: CGRectZero)
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.font = UIFont.systemFontOfSize(18)
        actionLabel.text = "Action Row..."
        actionLabel.textAlignment = .Left
        contentView.addSubview(actionLabel)
        
        let viewsDictionary = ["actionLabel":actionLabel]
        let metricsDictionary = ["sidePadding":15, "verticalPadding":17]
        
        let actionLabelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[actionLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let actionLabelV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[actionLabel]-verticalPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(actionLabelH)
        contentView.addConstraints(actionLabelV)
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
