/*
  KVRootEntityLocation.swift
  Ares005

  Created by Kenn Villegas on 10/10/15.
  Copyright © 2015 K3nV. All rights reserved.
*/

import Foundation
import CoreData
//TODO: Add CoreLocation and make a var/struct for coordinate

class KVRootEntityLocation: NSManagedObject {
//   p.altitude = 0
//   p.latitude = 39.283333
//   p.longitude = -76.616667
//   39.283333, -76.616667 BALTIMORE
    func mkDefaultLocation() {
        self.latitude = 39.283333
        self.longitude = -76.616667
        self.altitude = 1
    }
    func reportLocation() -> String {
        return ("At \(self.latitude!) by \(self.longitude!)")
    }

    
}
