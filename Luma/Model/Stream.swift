//
//  MomentStream.swift
//  Luma
//
//  Created by Chun-Wei Chen on 4/22/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import Foundation
import Parse

class Stream: PFObject, PFSubclassing {
    
    @NSManaged var title:String
    @NSManaged var author:PFUser
    
    var participants:PFRelation! {
        return relationForKey("participants")
    }
    
    var moments:PFRelation! {
        return relationForKey("moments")
    }
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Stream"
    }

}