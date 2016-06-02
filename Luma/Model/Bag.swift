//
//  Bag.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/18/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
class Bag: PFObject, PFSubclassing {

    @NSManaged var owner:LumaUser
    @NSManaged var items:[Product]

    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Bag"
    }
    
    
}
