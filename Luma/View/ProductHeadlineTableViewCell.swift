//
//  ProductHeadlineTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class ProductHeadlineTableViewCell: UITableViewCell {

    var productImageView:UIImageView!
    var productNameLabel:UILabel!
    var productInfoLabel:UILabel!
    var productSummaryLabel:UILabel!
    var separatorView:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        productImageView = UIImageView(frame: CGRectZero)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.backgroundColor = Colors.primary
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 40
        contentView.addSubview(productImageView)
        
        productNameLabel = UILabel(frame: CGRectZero)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.numberOfLines = 0
        productNameLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        contentView.addSubview(productNameLabel)
        
        productInfoLabel = UILabel(frame: CGRectZero)
        productInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        productInfoLabel.numberOfLines = 2
        productInfoLabel.font = UIFont.systemFontOfSize(14).italic()
        contentView.addSubview(productInfoLabel)
        
        productSummaryLabel = UILabel(frame: CGRectZero)
        productSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        productSummaryLabel.numberOfLines = 0
        productSummaryLabel.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(productSummaryLabel)
        
        separatorView = UIView(frame: CGRectZero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = Colors.separatorGray
        contentView.addSubview(separatorView)
        
        let viewsDictionary = ["productImageView":productImageView, "productNameLabel":productNameLabel, "productInfoLabel":productInfoLabel, "productSummaryLabel":productSummaryLabel, "separatorView":separatorView]
        let metricsDictionary = ["sidePadding":15]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[productImageView(80)]-sidePadding-[productNameLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        contentView.addConstraints(hConstraints)
        
        let productImageViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[productImageView(80)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        contentView.addConstraints(productImageViewV)
        
        let labelsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-28-[productNameLabel]-2-[productInfoLabel]-10-[productSummaryLabel]->=20-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        contentView.addConstraints(labelsV)
        
        let separatorViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:[separatorView(0.5)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let separatorViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        contentView.addConstraints(separatorViewH + separatorViewV)
        
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
