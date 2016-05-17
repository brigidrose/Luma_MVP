//
//  ProductReviewTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class ProductReviewTableViewCell: UITableViewCell {

    var reviewAuthorLabel:UILabel!
    var reviewContentLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        reviewAuthorLabel = UILabel(frame: CGRectZero)
        reviewAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewAuthorLabel.numberOfLines = 3
        reviewAuthorLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        reviewAuthorLabel.text = "Author"
        contentView.addSubview(reviewAuthorLabel)
        
        reviewContentLabel = UILabel(frame: CGRectZero)
        reviewContentLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewContentLabel.numberOfLines = 0
        reviewContentLabel.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(reviewContentLabel)
        
        let metricsDictionary = ["sidePadding":20, "topPadding":20, "bottomPadding":25]
        let viewsDictionary = ["reviewAuthorLabel":reviewAuthorLabel, "reviewContentLabel":reviewContentLabel]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[reviewAuthorLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topPadding-[reviewAuthorLabel]-5-[reviewContentLabel]-bottomPadding-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        contentView.addConstraints(hConstraints + vConstraints)
        
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
