//
//  BagItemTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/1/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class BagItemTableViewCell: UITableViewCell {

    var thumbnailImageView:UIImageView!
    var titleLabel:UILabel!
    var deliveryTimeframeLabel:UILabel!
    var recipientLabel:UILabel!
    var priceLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        thumbnailImageView = UIImageView(frame: CGRectZero)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.contentMode = .ScaleAspectFill
        thumbnailImageView.backgroundColor = Colors.primary.lighterColor()
        thumbnailImageView.layer.cornerRadius = 35
        thumbnailImageView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Left
        titleLabel.text = "Title"
        contentView.addSubview(titleLabel)
        
        deliveryTimeframeLabel = UILabel(frame: CGRectZero)
        deliveryTimeframeLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryTimeframeLabel.font = UIFont.systemFontOfSize(12)
        deliveryTimeframeLabel.numberOfLines = 0
        deliveryTimeframeLabel.textAlignment = .Left
        deliveryTimeframeLabel.text = "Delivery Timeframe"
        contentView.addSubview(deliveryTimeframeLabel)
        
        recipientLabel = UILabel(frame: CGRectZero)
        recipientLabel.translatesAutoresizingMaskIntoConstraints = false
        recipientLabel.font = UIFont.systemFontOfSize(12)
        recipientLabel.numberOfLines = 0
        recipientLabel.textAlignment = .Left
        recipientLabel.text = "Recipient"
        contentView.addSubview(recipientLabel)
        
        priceLabel = UILabel(frame: CGRectZero)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFontOfSize(26)
        priceLabel.numberOfLines = 0
        priceLabel.textAlignment = .Right
        priceLabel.text = "$49"
        contentView.addSubview(priceLabel)
        
        
        let viewsDictionary = ["thumbnailImageView":thumbnailImageView, "titleLabel":titleLabel, "deliveryTimeframeLabel":deliveryTimeframeLabel, "recipientLabel":recipientLabel, "priceLabel":priceLabel]
        let metricsDictionary = ["sidePadding":20]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[thumbnailImageView(70)]-sidePadding-[titleLabel]-20-[priceLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let thumbnailVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-sidePadding-[thumbnailImageView(70)]->=sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let productLabelsVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-28-[titleLabel]-2-[deliveryTimeframeLabel]-2-[recipientLabel]->=sidePadding-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        let priceLabelVConstraint = NSLayoutConstraint(item: priceLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        contentView.addConstraints(hConstraints)
        contentView.addConstraints(thumbnailVConstraints)
        contentView.addConstraints(productLabelsVConstraints)
        contentView.addConstraint(priceLabelVConstraint)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }

}
