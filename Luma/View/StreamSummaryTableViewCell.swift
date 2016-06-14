//
//  MomentStreamSummaryTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/2/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class StreamSummaryTableViewCell: UITableViewCell {

    var titleLabel:UILabel!
    var settingsButton:UIButton!
    var addParticipantButton:UIButton!
    var participantsStackView:UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Stream Title"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        contentView.addSubview(titleLabel)
        
        settingsButton = UIButton(frame: CGRectZero)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setImage(UIImage(named:"streamSettingsIcon" ), forState: .Normal)
        contentView.addSubview(settingsButton)
        
        addParticipantButton = UIButton(frame: CGRectZero)
        addParticipantButton.translatesAutoresizingMaskIntoConstraints = false
        addParticipantButton.setImage(UIImage(named:"streamAddParticipantIcon"), forState: .Normal)
        contentView.addSubview(addParticipantButton)
        
        participantsStackView = UIStackView(frame: CGRectZero)
        participantsStackView.translatesAutoresizingMaskIntoConstraints = false
        participantsStackView.axis = .Horizontal
        participantsStackView.spacing = 5
        contentView.addSubview(participantsStackView)
        
        let viewsDictionary = ["titleLabel":titleLabel, "settingsButton":settingsButton, "addParticipantButton":addParticipantButton, "participantsStackView":participantsStackView]
        let metricsDictionary = ["sidePadding":15, "topPadding":25, "bottomPadding":27, "buttonsPadding":12]
        
        let titleLabelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[titleLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topPadding-[titleLabel]-8-[participantsStackView(25)]-bottomPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(titleLabelH)
        contentView.addConstraints(vConstraints)
        
        let centerXStackView = NSLayoutConstraint(item: participantsStackView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)
        let buttonsH = NSLayoutConstraint.constraintsWithVisualFormat("H:[settingsButton(30)]-buttonsPadding-[participantsStackView]-buttonsPadding-[addParticipantButton(30)]", options: .AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let settingsButtonHeight = NSLayoutConstraint(item: settingsButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30)
        let addParticipantButtonHeight = NSLayoutConstraint(item: addParticipantButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30)
        
        contentView.addConstraints(buttonsH)
        contentView.addConstraint(centerXStackView)
        contentView.addConstraint(settingsButtonHeight)
        contentView.addConstraint(addParticipantButtonHeight)
        
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
