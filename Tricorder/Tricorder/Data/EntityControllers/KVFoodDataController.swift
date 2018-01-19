//
//  KVFoodDataController.swift
//  Ares
//
//  Created by Kenn Villegas on 9/5/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import CoreData
import UIKit

class KVFoodDataController <T:KVFoodType> :KVItemsDataController<T>
{
  override init() {
    super.init()
    self.dbName = "Tricorder"
    self.entityClassName = "KVFoodType"
  }
//  func makeFoodType(ctx: NSManagedObjectContext) -> KVFoodType
//  {
//      let f = createEntityInContext(ctx, type: EntityTypes.Food)
//    saveEntity(f)
//    return (f)
//  }
}
