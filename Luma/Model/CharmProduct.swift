//
//  CharmProduct.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
class CharmProduct: PFObject, PFSubclassing {
    
    @NSManaged var name:String
    @NSManaged var image:PFFile
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "CharmProduct"
    }

}
