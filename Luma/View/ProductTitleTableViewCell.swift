//
//  ProductTitleTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/17/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class ProductTitleTableViewCell: UITableViewCell {

    var productTitleLabel:UILabel!
    var productSubtitleLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        productTitleLabel = UILabel(frame: CGRectZero)
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        productTitleLabel.numberOfLines = 0
        productTitleLabel.textAlignment = .Center
        productTitleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        productTitleLabel.text = "Product Title"
        contentView.addSubview(productTitleLabel)
        
        productSubtitleLabel = UILabel(frame: CGRectZero)
        productSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        productSubtitleLabel.numberOfLines = 0
        productSubtitleLabel.textAlignment = .Center
        productSubtitleLabel.font = UIFont.systemFontOfSize(14).italic()
        productSubtitleLabel.text = "Product Subtitle"
        contentView.addSubview(productSubtitleLabel)
        
        let metricsDictionary = ["sidePadding":15, "topPadding":20, "bottomPadding":25]
        let viewsDictionary = ["productTitleLabel":productTitleLabel, "productSubtitleLabel":productSubtitleLabel]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[productTitleLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topPadding-[productTitleLabel]-3-[productSubtitleLabel]-bottomPadding-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        
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
