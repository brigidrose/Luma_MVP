//
//  Comment.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/13/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
class Comment: PFObject, PFSubclassing {
    
    @NSManaged var author:PFUser
    @NSManaged var content:String
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Comment"
    }

}
