//
//  SettingsSummaryTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/14/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse

class SettingsSummaryTableViewCell: UITableViewCell {

    var itemImageView:UIImageView!
    var itemTitleLabel:UILabel!
    var itemSubtitleLabel:UILabel!
    var itemAboutLabel:UILabel!
    var itemFootnoteLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        itemImageView = UIImageView(frame: CGRectZero)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.contentMode = .ScaleAspectFill
        itemImageView.backgroundColor = Colors.offWhite
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 55
        contentView.addSubview(itemImageView)
        
        itemTitleLabel = UILabel(frame: CGRectZero)
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        itemTitleLabel.text = "Item Title"
        itemTitleLabel.textAlignment = .Center
        contentView.addSubview(itemTitleLabel)
        
        itemSubtitleLabel = UILabel(frame: CGRectZero)
        itemSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemSubtitleLabel.font = UIFont.systemFontOfSize(14)
        itemSubtitleLabel.text = "Item Subtitle"
        itemSubtitleLabel.textAlignment = .Center
        contentView.addSubview(itemSubtitleLabel)
        
        itemAboutLabel = UILabel(frame: CGRectZero)
        itemAboutLabel.translatesAutoresizingMaskIntoConstraints = false
        itemAboutLabel.font = UIFont.systemFontOfSize(18).italic()
        itemAboutLabel.text = "Item About"
        itemAboutLabel.textAlignment = .Center
        contentView.addSubview(itemAboutLabel)

        itemFootnoteLabel = UILabel(frame: CGRectZero)
        itemFootnoteLabel.translatesAutoresizingMaskIntoConstraints = false
        itemFootnoteLabel.font = UIFont.systemFontOfSize(13, weight:UIFontWeightMedium).italic()
        itemFootnoteLabel.text = "Item Footnote"
        itemFootnoteLabel.textAlignment = .Center
        contentView.addSubview(itemFootnoteLabel)
        
        let viewsDictionary = ["itemImageView":itemImageView, "itemTitleLabel":itemTitleLabel, "itemSubtitleLabel":itemSubtitleLabel, "itemAboutLabel":itemAboutLabel, "itemFootnoteLabel":itemFootnoteLabel]
        let metricsDictionary = ["sidePadding":15, "topPadding":40]
        
        let itemImageViewCenterX = NSLayoutConstraint(item: itemImageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)
        contentView.addConstraint(itemImageViewCenterX)
        
        let itemImageViewWidth = NSLayoutConstraint.constraintsWithVisualFormat("H:[itemImageView(110)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let itemTitleLabelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[itemTitleLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let imageLabelV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topPadding-[itemImageView(110)]-13-[itemTitleLabel]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let labelsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[itemTitleLabel]-3-[itemSubtitleLabel]-26-[itemAboutLabel]-9-[itemFootnoteLabel]-30-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(itemImageViewWidth)
        contentView.addConstraints(itemTitleLabelH)
        contentView.addConstraints(imageLabelV)
        contentView.addConstraints(labelsV)
        
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
