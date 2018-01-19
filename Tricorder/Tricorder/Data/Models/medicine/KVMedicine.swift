//KVMedicine
/*






*/ 
import CoreData
import Foundation

class KVMedicine: KVItem
{
  @NSManaged var dailyFrequency: NSNumber?
  @NSManaged var dosageMG: NSNumber?
  @NSManaged var dosageString: String?
  @NSManaged var duration: NSNumber?
  @NSManaged var productName: String?
  @NSManaged var timeDue: NSDate?
}
