//
//  KVMealDataController.swift
//  Ares
//
//  Created by Kenn Villegas on 9/5/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import CoreData
import UIKit

class KVMealDataController <T:KVMeal> :KVItemsDataController<T>
{
  override init() {
    super.init()
    self.dbName = "Tricorder"
    self.entityClassName = "KVMeal"
  }
//  func makeMeal(context: NSManagedObjectContext) -> KVMeal
//  {
//    let meal = createEntityInContext(context, type: EntityTypes.Meal)
//    saveEntity(meal)
//    return (meal)
//  }
  
}
