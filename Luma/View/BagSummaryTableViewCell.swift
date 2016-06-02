//
//  BagSummaryTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/1/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class BagSummaryTableViewCell: UITableViewCell {

    var stackView:UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        stackView = UIStackView(frame: CGRectZero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.spacing = 3
        contentView.addSubview(stackView)
        
        let viewsDictionary = ["stackView":stackView]
        let metricsDictionary = ["sidePadding":15]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[stackView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-sidePadding-[stackView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
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

}
