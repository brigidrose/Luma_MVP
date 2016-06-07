
//
//  MomentMediaTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/6/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class MomentMediaTableViewCell: UITableViewCell {

    var thumbnailImageView:UIImageView!
    var captionLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        thumbnailImageView = UIImageView(frame: CGRectZero)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.contentMode = .ScaleAspectFill
        thumbnailImageView.backgroundColor = UIColor(hexString: "F3F3F3")
        contentView.addSubview(thumbnailImageView)
        
        captionLabel = UILabel(frame: CGRectZero)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.numberOfLines = 0
        captionLabel.text = "Caption..."
        captionLabel.font = UIFont.systemFontOfSize(17)
        contentView.addSubview(captionLabel)
        
        let viewsDictionary = ["thumbnailImageView":thumbnailImageView, "captionLabel":captionLabel]
        let metricsDictionary = ["sidePadding":15, "topPadding":10, "bottomPadding":40, "thumbnailWidth":UIScreen.mainScreen().bounds.width]
        
        let imageHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[thumbnailImageView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[thumbnailImageView(thumbnailWidth)]-topPadding-[captionLabel]-bottomPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let captionHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[captionLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)

        contentView.addConstraints(imageHConstraints)
        contentView.addConstraints(verticalConstraints)
        contentView.addConstraints(captionHConstraints)
        
        
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
