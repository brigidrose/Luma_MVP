//
//  StreamWithParticipantsTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/9/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class StreamWithParticipantsTableViewCell: UITableViewCell {

    var thumbnailImageView:UIImageView!
    var streamTitleLabel:UILabel!
    var streamParticipantsLabel:UILabel!
    var separatorView:UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        thumbnailImageView = UIImageView(frame: CGRectZero)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.backgroundColor = Colors.offWhite
        thumbnailImageView.layer.cornerRadius = 22
        contentView.addSubview(thumbnailImageView)
        
        streamTitleLabel = UILabel(frame: CGRectZero)
        streamTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        streamTitleLabel.text = "Stream Title"
        streamTitleLabel.textAlignment = .Left
        streamTitleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        contentView.addSubview(streamTitleLabel)
        
        streamParticipantsLabel = UILabel(frame: CGRectZero)
        streamParticipantsLabel.translatesAutoresizingMaskIntoConstraints = false
        streamParticipantsLabel.text = "Stream Participant"
        streamParticipantsLabel.textAlignment = .Left
        streamParticipantsLabel.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(streamParticipantsLabel)
        
        separatorView = UIView(frame: CGRectZero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = Colors.separatorGray
        contentView.addSubview(separatorView)
        
        let viewsDictionary = ["thumbnailImageView":thumbnailImageView, "streamTitleLabel":streamTitleLabel, "streamParticipantsLabel":streamParticipantsLabel, "separatorView":separatorView]
        let metricsDictionary = ["sidePadding":10]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[thumbnailImageView(44)]-sidePadding-[streamTitleLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vImageViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-sidePadding-[thumbnailImageView(44)]-9.5-[separatorView(0.5)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vLabelsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[streamTitleLabel][streamParticipantsLabel]", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        let streamTitleLabelBottom = NSLayoutConstraint(item: streamTitleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        let separatorH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(hConstraints)
        contentView.addConstraints(vImageViewConstraints)
        contentView.addConstraints(vLabelsV)
        contentView.addConstraint(streamTitleLabelBottom)
        contentView.addConstraints(separatorH)
        
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
