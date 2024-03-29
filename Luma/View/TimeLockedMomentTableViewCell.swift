//
//  TimeLockedMomentTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/3/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import CountdownLabel

class TimeLockedMomentTableViewCell: UITableViewCell {

    var cardView:UIView!
    var userButton:UIButton!
    var moreButton:UIButton!
    var actionLabel:UILabel!
    var unlockCountdownLabel:CountdownLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        
        cardView = UIView(frame: CGRectZero)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 5
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(hexString: "ECECEC").CGColor
        cardView.clipsToBounds = true
        cardView.backgroundColor = Colors.white
        contentView.addSubview(cardView)
        
        
        userButton = UIButton(frame: CGRectZero)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.setImage(UIImage(named:"momentUserButtonIcon"), forState: .Normal)
        userButton.layer.cornerRadius = 25
        userButton.clipsToBounds = true
        cardView.addSubview(userButton)
        
        moreButton = UIButton(frame: CGRectZero)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(named:"momentMoreButtonIcon"), forState: .Normal)
        cardView.addSubview(moreButton)
        
        actionLabel = UILabel(frame: CGRectZero)
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.text = "Action label"
        actionLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold)
        actionLabel.numberOfLines = 0
        actionLabel.textAlignment = .Left
        cardView.addSubview(actionLabel)
        
        unlockCountdownLabel = CountdownLabel(frame: CGRectZero, date: NSDate(timeIntervalSinceNow: 30000))
        unlockCountdownLabel.translatesAutoresizingMaskIntoConstraints = false
        unlockCountdownLabel.textAlignment = .Right
        unlockCountdownLabel.animationType = .Evaporate
        unlockCountdownLabel.font = UIFont.systemFontOfSize(32, weight: UIFontWeightLight)
        cardView.addSubview(unlockCountdownLabel)
        
        let viewsDictionary = ["cardView":cardView, "userButton":userButton, "moreButton":moreButton, "actionLabel":actionLabel, "unlockCountdownLabel":unlockCountdownLabel]
        let metricsDictionary = ["cardPadding":10]
        
        let cardViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-cardPadding-[cardView]-cardPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let cardViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-cardPadding-[cardView]-cardPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(cardViewH)
        contentView.addConstraints(cardViewV)
        
        
        let topRowH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[userButton(50)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        cardView.addConstraints(topRowH)
        
        let topRowHRight = NSLayoutConstraint.constraintsWithVisualFormat("H:[moreButton(40)]-7.5-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        cardView.addConstraints(topRowHRight)
        
        let moreButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[moreButton(40)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        cardView.addConstraints(moreButtonV)
        
        let labelsH = NSLayoutConstraint.constraintsWithVisualFormat("H:[userButton(50)]-15-[actionLabel]-20-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        cardView.addConstraints(labelsH)
        
        let labelsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[actionLabel]->=14-[unlockCountdownLabel]->=20-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        cardView.addConstraints(labelsV)
        
        let leftColumnV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[userButton(50)]->=15-|", options: .AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        cardView.addConstraints(leftColumnV)
    }

}
