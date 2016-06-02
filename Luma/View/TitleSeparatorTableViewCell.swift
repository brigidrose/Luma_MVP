//
//  TitleSeparatorTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/19/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class TitleSeparatorTableViewCell: UITableViewCell {

    var leftLineView:UIView!
    var rightLineView:UIView!
    var titleLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        leftLineView = UIView(frame: CGRectZero)
        rightLineView = UIView(frame: CGRectZero)
        titleLabel = UILabel(frame: CGRectZero)
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLineView)
        contentView.addSubview(rightLineView)
        contentView.addSubview(titleLabel)
        
        leftLineView.backgroundColor = UIColor.blackColor()
        rightLineView.backgroundColor = UIColor.blackColor()
        titleLabel.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightMedium).italic()
        titleLabel.text = "Prompt Title"
        titleLabel.textAlignment = .Center
        
        let metricsDictionary = ["sidePadding":15, "titleLabelBuffer":7.5]
        let viewsDictionary = ["leftLineView":leftLineView, "rightLineView":rightLineView, "titleLabel":titleLabel]
        
        let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)
        let titleAndLinesH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[leftLineView]-titleLabelBuffer-[titleLabel]-titleLabelBuffer-[rightLineView]-sidePadding-|", options: .AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let allV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-titleLabelBuffer-[titleLabel]-titleLabelBuffer-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let leftLineViewHeight = NSLayoutConstraint(item: leftLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
        let rightLineViewHeight = NSLayoutConstraint(item: rightLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
        contentView.addConstraints(titleAndLinesH + allV)
        contentView.addConstraints([titleLabelCenterX, leftLineViewHeight, rightLineViewHeight])

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
