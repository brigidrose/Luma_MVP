//
//  ParticipantTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/14/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {

    var thumbnailImageView:UIImageView!
    var participantNameLabel:UILabel!
    var joinedDateLabel:UILabel!
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
        thumbnailImageView.contentMode = .ScaleAspectFill
        thumbnailImageView.image = UIImage(named: "streamParticipantIcon")
        thumbnailImageView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        
        participantNameLabel = UILabel(frame: CGRectZero)
        participantNameLabel.translatesAutoresizingMaskIntoConstraints = false
        participantNameLabel.text = "Participant Name"
        participantNameLabel.textAlignment = .Left
        participantNameLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        contentView.addSubview(participantNameLabel)
        
        joinedDateLabel = UILabel(frame: CGRectZero)
        joinedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        joinedDateLabel.text = "Joined Date"
        joinedDateLabel.textAlignment = .Left
        joinedDateLabel.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(joinedDateLabel)
        
        separatorView = UIView(frame: CGRectZero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = Colors.separatorGray
        contentView.addSubview(separatorView)
        
        let viewsDictionary = ["thumbnailImageView":thumbnailImageView, "participantNameLabel":participantNameLabel, "joinedDateLabel":joinedDateLabel, "separatorView":separatorView]
        let metricsDictionary = ["sidePadding":10]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[thumbnailImageView(44)]-sidePadding-[participantNameLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vImageViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-sidePadding-[thumbnailImageView(44)]-9.5-[separatorView(0.5)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vLabelsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[participantNameLabel][joinedDateLabel]", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        let participantNameLabelBottom = NSLayoutConstraint(item: participantNameLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        let separatorH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(hConstraints)
        contentView.addConstraints(vImageViewConstraints)
        contentView.addConstraints(vLabelsV)
        contentView.addConstraint(participantNameLabelBottom)
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
