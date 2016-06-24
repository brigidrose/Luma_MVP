//
//  MomentDetailSummaryTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/3/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class MomentDetailSummaryTableViewCell: UITableViewCell {

    
    var titleCardView:UIView!
    var titleLabel:UILabel!
    var userButton:UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        titleCardView = UIView(frame: CGRectZero)
        titleCardView.translatesAutoresizingMaskIntoConstraints = false
        titleCardView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        titleCardView.layer.cornerRadius = 5
        titleCardView.clipsToBounds = true
        contentView.addSubview(titleCardView)
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Left
        titleLabel.font = UIFont.systemFontOfSize(17).italic()
        titleLabel.text = "Title Label Title Label Title Label Title Label Title Label Title Label Title Label"
        titleLabel.numberOfLines = 0
        titleCardView.addSubview(titleLabel)
        
        userButton = UIButton(frame: CGRectZero)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.setImage(UIImage(named: "momentUserButtonIcon"), forState: .Normal)
        userButton.backgroundColor = Colors.white
        userButton.layer.cornerRadius = 25
        userButton.clipsToBounds = true
        contentView.addSubview(userButton)
        
        let viewsDictionary = ["titleCardView":titleCardView, "titleLabel":titleLabel, "userButton":userButton]
        let metricsDictionary = ["cardLeftPadding":31.5, "cardRightPadding":7.5, "cardTopPadding":36, "cardBottomPadding":25]
        
        let cardHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-cardLeftPadding-[titleCardView]->=cardRightPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let cardVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-cardTopPadding-[titleCardView]-cardBottomPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(cardHConstraints)
        contentView.addConstraints(cardVConstraints)
        
        let userButtonWidth = NSLayoutConstraint(item: userButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
        
        let userButtonHeight = NSLayoutConstraint(item: userButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
        
        let userButtonCenterX = NSLayoutConstraint(item: userButton, attribute: .CenterX, relatedBy: .Equal, toItem: titleCardView, attribute: .Left, multiplier: 1, constant: 0)
        
        let userButtonCenterY = NSLayoutConstraint(item: userButton, attribute: .CenterY, relatedBy: .Equal, toItem: titleCardView, attribute: .Top, multiplier: 1, constant: 5)
        
        contentView.addConstraints([userButtonWidth, userButtonHeight, userButtonCenterX, userButtonCenterY])
        
        let titleLabelHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-34-[titleLabel]-17-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let titleLabelVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[titleLabel]-12-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        titleCardView.addConstraints(titleLabelHConstraints)
        titleCardView.addConstraints(titleLabelVConstraints)
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
