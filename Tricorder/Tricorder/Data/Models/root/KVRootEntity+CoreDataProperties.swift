
import Foundation
import CoreData

extension KVRootEntity {

  @NSManaged var incepDate: NSDate?
  @NSManaged var type: String?
  @NSManaged var status: NSNumber?
  //
  @NSManaged var hexID: String?
  @NSManaged var qName: String?
  
  @NSManaged var location: KVRootEntityLocation?
  @NSManaged var graphics: KVRootEntityGraphics?
  @NSManaged var sizes: KVRootEntitySizes?

}
