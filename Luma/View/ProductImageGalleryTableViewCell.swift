//
//  ProductImageGalleryTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/17/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import KRLCollectionViewGridLayout
class ProductImageGalleryTableViewCell: UITableViewCell {

    var galleryCollectionView:UICollectionView!
    var pageControl:UIPageControl!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = KRLCollectionViewGridLayout()
        layout.numberOfItemsPerLine = 1
        layout.aspectRatio = 16/9
        layout.scrollDirection = .Horizontal
        layout.interitemSpacing = 0
        layout.lineSpacing = 0

        galleryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        galleryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        galleryCollectionView.pagingEnabled = true
        galleryCollectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        galleryCollectionView.showsHorizontalScrollIndicator = false
        galleryCollectionView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(galleryCollectionView)
        
        pageControl = UIPageControl(frame: CGRectZero)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.userInteractionEnabled = false
        pageControl.pageIndicatorTintColor = UIColor.grayColor().lighterColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        contentView.addSubview(pageControl)
        
        let metricsDictionary = ["sidePadding":15, "galleryCollectionViewHeight":Int(UIScreen.mainScreen().bounds.width / 16 * 9)]
        let viewsDictionary = ["galleryCollectionView":galleryCollectionView, "pageControl":pageControl]
        
        let galleryCollectionViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[galleryCollectionView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let pageControlH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[pageControl]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[galleryCollectionView(galleryCollectionViewHeight)]-2-[pageControl]-5-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        contentView.addConstraints(galleryCollectionViewH + pageControlH + vConstraints)
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
