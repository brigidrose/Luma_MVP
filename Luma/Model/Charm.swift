//
//  Charm.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/13/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
class Charm: PFObject, PFSubclassing{
    
    @NSManaged var model:Model
    @NSManaged var title:String
    @NSManaged var about:String
    @NSManaged var gifter:PFUser
    @NSManaged var owner:PFUser
    
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Charm"
    }

}
