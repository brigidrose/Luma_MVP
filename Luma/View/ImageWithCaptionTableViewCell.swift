//
//  ImageWithCaptionTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/10/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import SZTextView

class ImageWithCaptionTableViewCell: UITableViewCell {

    var momentImageView:UIImageView!
    var momentImageCaptionTextView:SZTextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        momentImageView = UIImageView(frame: CGRectZero)
        momentImageView.translatesAutoresizingMaskIntoConstraints = false
        momentImageView.contentMode = .ScaleAspectFill
        momentImageView.backgroundColor = Colors.offWhite
        momentImageView.clipsToBounds = true
        contentView.addSubview(momentImageView)
        
        momentImageCaptionTextView = SZTextView(frame: CGRectZero)
        momentImageCaptionTextView.translatesAutoresizingMaskIntoConstraints = false
        momentImageCaptionTextView.placeholder = "Caption..."
        momentImageCaptionTextView.font = UIFont.systemFontOfSize(17)
        momentImageCaptionTextView.returnKeyType = .Done
        contentView.addSubview(momentImageCaptionTextView)
        
        let viewsDictionary = ["momentImageView":momentImageView, "momentImageCaptionTextView":momentImageCaptionTextView]
        let metricsDictionary = ["sidePadding":15, "bottomPadding":25, "imageSide":UIScreen.mainScreen().bounds.width]
        let imageViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[momentImageView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let contentViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[momentImageView(imageSide)]-[momentImageCaptionTextView(>=50)]-bottomPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let captionTextViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[momentImageCaptionTextView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(imageViewH)
        contentView.addConstraints(contentViewV)
        contentView.addConstraints(captionTextViewH)
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
