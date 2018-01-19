/*
    KVPerson+CoreDataProperties.swift
    Ares005

    Created by Kenn Villegas on 10/13/15.
    Copyright © 2015 K3nV. All rights reserved.

*/

import Foundation
import CoreData

extension KVPerson {

  @NSManaged var emailID: String?
  @NSManaged var firstName: String?
  @NSManaged var lastName: String?
  @NSManaged var middleName: String?
  @NSManaged var phoneNumber: String?
  @NSManaged var textID: String?
  @NSManaged var vehicle: KVVehicle?
  @NSManaged var mealStack: NSSet?
  @NSManaged var messageStack: NSSet?
  @NSManaged var packageStack: NSSet?

}
