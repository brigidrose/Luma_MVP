//
//  Media.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/13/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse

class Media: PFObject, PFSubclassing {
    
    @NSManaged var file:PFFile
    @NSManaged var caption:String
    @NSManaged var type:String
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Media"
    }
    
}