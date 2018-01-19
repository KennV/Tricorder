//KVEvent

import CoreData
import Foundation

class KVEvent: KVEntity 
{
  @NSManaged var duration: NSNumber?
  @NSManaged var endTime: NSDate?
  @NSManaged var label: NSNumber?
  @NSManaged var priority: NSNumber?
  @NSManaged var startTime: NSDate?
  @NSManaged var title: String?
}
