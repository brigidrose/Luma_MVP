//
//  Item_Order.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/13/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
class Item_Order: PFObject, PFSubclassing {

    @NSManaged var model:Model
    @NSManaged var placeholderTitle:String
    @NSManaged var placeholderAbout:String
    
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Item_Order"
    }

}
