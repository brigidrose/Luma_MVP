//
//  LumaNavigationControllerTitleView.swift
//  Luma
//
//  Created by Chun-Wei Chen on 4/22/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class LumaNavigationControllerTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let logoImageView = UIImageView(frame: CGRectZero)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "LumaLogo")
        addSubview(logoImageView)
        
        let hLogoImageView = NSLayoutConstraint.constraintsWithVisualFormat("H:|[logoImageView(30)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["logoImageView":logoImageView])
        let vLogoImageView = NSLayoutConstraint.constraintsWithVisualFormat("V:|[logoImageView(25)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["logoImageView":logoImageView])
        addConstraints(hLogoImageView + vLogoImageView)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
