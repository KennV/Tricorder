//
//  KVItem.swift
//  Ares3
//
//  Created by Kenn Villegas on 9/20/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import CoreData
import UIKit
// cant go to NSMO without breaking the controller so i won't for now
class KVItem: KVRootEntity
{
  @NSManaged var stateOfItem: NSNumber?
  @NSManaged var cost: NSNumber?  
  @NSManaged var price: NSNumber?
  @NSManaged var rating: NSNumber?
  @NSManaged var recieverID: String?
  @NSManaged var senderID: String?
}
