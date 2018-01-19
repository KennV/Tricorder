//
//  KVVehicle+CoreDataProperties.swift
//  Ares005
//
//  Created by Kenn Villegas on 10/13/15.
//  Copyright © 2015 K3nV. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension KVVehicle {

  @NSManaged var make: String?
  @NSManaged var model: String?
  @NSManaged var color: String?
  @NSManaged var numberOfWheels: NSNumber?
  @NSManaged var driver: KVPerson?

}
