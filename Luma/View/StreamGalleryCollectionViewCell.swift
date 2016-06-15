//
//  StreamGalleryCollectionViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 4/22/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class StreamGalleryCollectionViewCell: UICollectionViewCell {
    
    var containerView:UIView!
    var streamProfileImageView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        containerView = UIView(frame: CGRectZero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        streamProfileImageView = UIImageView(frame: CGRectZero)
        streamProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        streamProfileImageView.contentMode = .ScaleAspectFit
        containerView.addSubview(streamProfileImageView)
        
        let viewsDictionary = ["containerView":containerView, "streamProfileImageView":streamProfileImageView]
        
        let containerH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let containerV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        addConstraints(containerH)
        addConstraints(containerV)
        
        let imageViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[streamProfileImageView(50)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let imageViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[streamProfileImageView(50)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        containerView.addConstraints(imageViewH)
        containerView.addConstraints(imageViewV)
    }
    
}
