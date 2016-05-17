//
//  ProductFeatureTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class ProductFeatureTableViewCell: UITableViewCell {

    var featureTitleLabel:UILabel!
    var featureBodyLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        featureTitleLabel = UILabel(frame: CGRectZero)
        featureTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        featureTitleLabel.numberOfLines = 3
        featureTitleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        contentView.addSubview(featureTitleLabel)
        
        featureBodyLabel = UILabel(frame: CGRectZero)
        featureBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        featureBodyLabel.numberOfLines = 0
        featureBodyLabel.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(featureBodyLabel)
        
        let metricsDictionary = ["sidePadding":20, "topPadding":20, "bottomPadding":25]
        let viewsDictionary = ["featureTitleLabel":featureTitleLabel, "featureBodyLabel":featureBodyLabel]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[featureTitleLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topPadding-[featureTitleLabel]-5-[featureBodyLabel]-bottomPadding-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
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
