/*
  KVRootEntityLocation+CoreDataProperties.swift
  Ares005

  Created by Kenn Villegas on 10/13/15.
  Copyright © 2015 K3nV. All rights reserved.
*/

import Foundation
import CoreData

extension KVRootEntityLocation {

  @NSManaged var altitude: NSNumber?
  @NSManaged var heading: NSNumber?
  @NSManaged var latitude: NSNumber?
  @NSManaged var longitude: NSNumber?
  
  @NSManaged var address: String?
  @NSManaged var city: String?
  @NSManaged var state: String?
  @NSManaged var zipCode: String?

  @NSManaged var owner: KVRootEntity?
}
