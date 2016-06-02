//
//  ImageCollectionViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/17/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var containerView:UIView!
    var collectionImageView:UIImageView!
    var isHeightCalculated = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView = UIView(frame: CGRectZero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        let containerViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["containerView":containerView])
        let containerViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["containerView":containerView])
        addConstraints(containerViewH + containerViewV)
        
        collectionImageView = UIImageView(frame: CGRectZero)
        collectionImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionImageView.contentMode = .ScaleAspectFill
        collectionImageView.clipsToBounds = true
        collectionImageView.image = UIImage(named: "galleryImagePlaceholder")
        containerView.addSubview(collectionImageView)
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["imageView":collectionImageView])
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["imageView":collectionImageView])
        
        containerView.addConstraints(hConstraints + vConstraints)
        
        
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
