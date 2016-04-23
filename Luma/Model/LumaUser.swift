//
//  LumaUser.swift
//  Luma
//
//  Created by Chun-Wei Chen on 4/22/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import Foundation
import Parse
class LumaUser:PFObject, PFSubclassing {
    
    override class func initialize(){
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Luma User"
    }

}