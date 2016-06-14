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
    @NSManaged var participants:[PFUser]
    @NSManaged var moments:[Moment]
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Moment Stream"
    }

}