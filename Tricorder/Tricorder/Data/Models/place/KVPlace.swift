
// KVPlace

import CoreData
import Foundation

class KVPlace: KVEntity
{
  @NSManaged var numberOfSides: NSNumber?
  @NSManaged var privateIfTrue: Bool
  @NSManaged var radiusMeters: NSNumber?
  @NSManaged var rating: NSNumber?
  
}
