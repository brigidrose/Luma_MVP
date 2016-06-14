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
    
    @NSManaged var title:String
    @NSManaged var author:PFUser
    @NSManaged var medias:[Media]
    @NSManaged var comments:[Comment]

    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Moment"
    }

}
