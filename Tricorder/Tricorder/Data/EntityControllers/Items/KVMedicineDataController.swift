//
//  KVEventDataController.swift
//  Ares
//
//  Created by Kenn Villegas on 9/7/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import CoreData
import UIKit

class KVMedicineDataController <T : KVMedicine> : KVItemsDataController<T>
{
  override init() {
    super.init()
    self.dbName = "Tricorder"
    self.entityClassName = "KVMedicine"
  }
  func makeMedicine(_ ctx: NSManagedObjectContext) // -> KVEvent
  {
    //
    // let event = createEntityInContext(context, type: "KVPlace")
    // event.data = makeRootData(context)
    // event.graphics = makeRootGraphics(context)
    // event.location = makeEntityLocation(context)
    // event.size = makeRootSizes(context)
    // saveEntities()
    // saveEntity(event)
    //
    // return event
  }
}
