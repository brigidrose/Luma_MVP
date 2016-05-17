//
//  UIFontExtension.swift
//  Instakhabr
//
//  Created by Chun-Wei Chen on 4/18/16.
//  Copyright © 2016 Instakhabr. All rights reserved.
//

import Foundation
import UIKit
extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor()
            .fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func withFamily(family:String) -> UIFont {
        let descriptor = self.fontDescriptor()
            .fontDescriptorWithFamily(family)
        return UIFont(descriptor: descriptor, size: 0)
    }

    
    func heavyItalic() -> UIFont {
        return withTraits(.TraitBold, .TraitCondensed, .TraitItalic)
    }
    
    func semiBold() -> UIFont{
        return withTraits(.TraitExpanded)
    }
    
    func lightItalic() -> UIFont{
        return withTraits(.TraitItalic, .TraitMonoSpace)
    }
    
    func italic() -> UIFont{
        return withTraits(.TraitItalic)
    }

    
    func heavy() -> UIFont{
        return withFamily(".SFUIText-HeavyItalic")
    }
    
    func bold() -> UIFont{
        return withTraits(.TraitBold)
    }
    
    
}
