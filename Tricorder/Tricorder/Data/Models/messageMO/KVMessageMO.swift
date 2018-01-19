//
//  KVMessageMO.swift
//  Ares3
//
//  Created by Kenn Villegas on 9/20/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import UIKit

class KVMessageMO: KVItem {
  @NSManaged var hasAttachmentIfYES: Bool
  @NSManaged var fullDataString: String
  @NSManaged var shortLabel: String
  @NSManaged var messageOwner: KVPerson
}
