//
//  CommentTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    var commentCardView:UIView!
    var commentLabel:UILabel!
    var authorButton:UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        commentCardView = UIView(frame: CGRectZero)
        commentCardView.translatesAutoresizingMaskIntoConstraints = false
        commentCardView.backgroundColor = UIColor(hexString: "979797")
        commentCardView.layer.cornerRadius = 5
        commentCardView.clipsToBounds = true
        contentView.addSubview(commentCardView)
        
        commentLabel = UILabel(frame: CGRectZero)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.textAlignment = .Left
        commentLabel.font = UIFont.systemFontOfSize(17).italic()
        commentLabel.text = "Title Label Title Label Title Label Title Label Title Label Title Label Title Label"
        commentLabel.textColor = Colors.white
        commentLabel.numberOfLines = 0
        commentCardView.addSubview(commentLabel)
        
        authorButton = UIButton(frame: CGRectZero)
        authorButton.translatesAutoresizingMaskIntoConstraints = false
        authorButton.setImage(UIImage(named: "momentauthorButtonIcon"), forState: .Normal)
        authorButton.backgroundColor = Colors.white
        authorButton.layer.cornerRadius = 25
        authorButton.clipsToBounds = true
        contentView.addSubview(authorButton)
        
        let viewsDictionary = ["commentCardView":commentCardView, "commentLabel":commentLabel, "authorButton":authorButton]
        let metricsDictionary = ["cardLeftPadding":31.5, "cardRightPadding":7.5, "cardTopPadding":36, "cardBottomPadding":25]
        
        let cardHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-cardLeftPadding-[commentCardView]-cardRightPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let cardVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-cardTopPadding-[commentCardView]-cardBottomPadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(cardHConstraints)
        contentView.addConstraints(cardVConstraints)
        
        let authorButtonWidth = NSLayoutConstraint(item: authorButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
        
        let authorButtonHeight = NSLayoutConstraint(item: authorButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
        
        let authorButtonCenterX = NSLayoutConstraint(item: authorButton, attribute: .CenterX, relatedBy: .Equal, toItem: commentCardView, attribute: .Left, multiplier: 1, constant: 0)
        
        let authorButtonCenterY = NSLayoutConstraint(item: authorButton, attribute: .CenterY, relatedBy: .Equal, toItem: commentCardView, attribute: .Top, multiplier: 1, constant: 5)
        
        contentView.addConstraints([authorButtonWidth, authorButtonHeight, authorButtonCenterX, authorButtonCenterY])
        
        let commentLabelHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-34-[commentLabel]-12-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let commentLabelVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[commentLabel]-12-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        commentCardView.addConstraints(commentLabelHConstraints)
        commentCardView.addConstraints(commentLabelVConstraints)
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
