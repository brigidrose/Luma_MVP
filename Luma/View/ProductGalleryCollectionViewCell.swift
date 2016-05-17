//
//  ProductGalleryCollectionViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import MarqueeLabel
class ProductGalleryCollectionViewCell: UICollectionViewCell {

    var containerView:UIView!
    var imageView:UIImageView!
    var nameLabel:MarqueeLabel!
    var priceLabel:UILabel!
    
    var isHeightCalculated: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        let hContainerView = NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["containerView":containerView])
        let vContainerView = NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["containerView":containerView])
        
        contentView.addConstraints(hContainerView)
        contentView.addConstraints(vContainerView)
        
        imageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Colors.primary
        imageView.layer.cornerRadius = (UIScreen.mainScreen().bounds.width / 2 - (20 * 4.5)) / 2
        containerView.addSubview(imageView)
        
        nameLabel = MarqueeLabel(frame: CGRectZero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        nameLabel.text = "Product Name"
        nameLabel.textAlignment = .Center
        nameLabel.trailingBuffer = 50
        containerView.addSubview(nameLabel)
        
        priceLabel = UILabel(frame: CGRectZero)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.numberOfLines = 1
        priceLabel.font = UIFont.systemFontOfSize(14)
        priceLabel.text = "Price"
        priceLabel.textAlignment = .Center
        containerView.addSubview(priceLabel)
        
        let metricsDictionary = ["sidePadding":20, "verticalPadding":20, "imageWidth":UIScreen.mainScreen().bounds.width / 2 - (20 * 4.5)]
        let viewsDictionary = ["imageView":imageView, "nameLabel":nameLabel, "priceLabel":priceLabel]
        
        let imageViewHCenter = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1, constant: 0)
        let imageViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|->=0-[imageView(imageWidth)]->=0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let labelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[nameLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let labelV = NSLayoutConstraint.constraintsWithVisualFormat("V:[nameLabel]-2-[priceLabel]->=verticalPadding-|", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        let imageViewLabelV = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=20-[imageView(imageWidth)]-12-[nameLabel]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        containerView.addConstraint(imageViewHCenter)
        containerView.addConstraints(imageViewH + labelH + labelV + imageViewLabelV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = containerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = UIScreen.mainScreen().bounds.width
            newFrame.size.height = CGFloat(ceilf(Float(size.height)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
        
    }

}
