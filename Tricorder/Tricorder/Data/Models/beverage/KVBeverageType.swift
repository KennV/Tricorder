//
//  KVBeverageType.swift
//  Ares3
//
//  Created by Kenn Villegas on 9/20/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import UIKit

class KVBeverageType: KVItem
{
  @NSManaged var doesContainAlcoholIfYes: Bool
  @NSManaged var isPartOfMealIfYes: Bool
  @NSManaged var isCurrentlyAvailableIfYes: Bool
  @NSManaged var beverageName: String
}
