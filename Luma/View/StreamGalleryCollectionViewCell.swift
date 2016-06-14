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
        
        streamProfileImageView = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        streamProfileImageView.contentMode = .ScaleAspectFit
//        streamProfileImageView.backgroundColor = Colors.offWhite
        contentView.addSubview(streamProfileImageView)
    }
    
}
