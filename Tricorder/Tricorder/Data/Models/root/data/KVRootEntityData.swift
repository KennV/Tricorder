//
//  KVRootEntityData.swift
//  Ares005
//
//  Created by Kenn Villegas on 10/13/15.
//  Copyright © 2015 K3nV. All rights reserved.
//

import Foundation
import CoreData


class KVRootEntityData: NSManagedObject {
    func mkDefaultData()
    {
        self.type = "defaultType"
        self.status = 100.00
        self.incepDate = NSDate()
    }
}
