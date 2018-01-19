//
//  KVBeverageDataController.swift
//  Ares
//
//  Created by Kenn Villegas on 9/5/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import CoreData
import UIKit

class KVBeverageDataController <T:KVBeverageType> :KVItemsDataController<T>
{
  override init() {
    super.init()
    self.dbName = "Tricorder"
    self.entityClassName = "KVBeverageType"
  }
//  func makeBeverage(ctx: NSManagedObjectContext) -> KVBeverageType
//  {
//    let b = createEntityInContext(ctx, type: EntityTypes.Beverage)
//    self.saveEntity(b)
//    return(b)
//  }
  
  
}
