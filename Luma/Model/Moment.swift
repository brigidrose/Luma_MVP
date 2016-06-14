//
//  Moment.swift
//  Luma
//
//  Created by Chun-Wei Chen on 4/22/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import Foundation
import Parse

class Moment: PFObject, PFSubclassing {
    
    @NSManaged var narrative:String
    @NSManaged var author:PFUser
    @NSManaged var locked:Bool
    @NSManaged var unlockType:String
    @NSManaged var unlockDate:NSDate
    @NSManaged var unlockLocation:PFGeoPoint
    @NSManaged var inStream:Stream

    var medias:PFRelation!{
        return relationForKey("medias")
    }
    
    var comments: PFRelation! {
        return relationForKey("comments")
    }

    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Moment"
    }

}
