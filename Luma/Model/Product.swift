//
//  CharmProduct.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse

class Product: PFObject, PFSubclassing {
    
    @NSManaged var name:String
    @NSManaged var line:String
    @NSManaged var image:PFFile
    @NSManaged var price:Float
    @NSManaged var deliveryDays:Int
    @NSManaged var images:PFRelation
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "CharmProduct"
    }

}
