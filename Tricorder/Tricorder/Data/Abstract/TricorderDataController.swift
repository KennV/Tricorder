/**
 // https://en.wikipedia.org/wiki/BSD_licenses
 // BSD Style-License
 // Copyright © 2015, Kenneth Villegas
 // Copyright © 2015 K3nV. All rights reserved.
 // All rights reserved.
 
 // Redistribution and use in source and binary forms, with or without
 // modification, are permitted provided that the following conditions are met:
 
 // 1. Redistributions of source code must retain the above copyright notice, this
 //    list of conditions and the following disclaimer.
 // 2. Redistributions in binary form must reproduce the above copyright notice,
 //    this list of conditions and the following disclaimer in the documentation
 //    and/or other materials provided with the distribution.
 
 // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 // ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 // WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 // DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 // ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 // (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 // LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 // ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 // (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 // SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 //
 // The views and conclusions contained in the software and documentation are those
 // of the authors and should not be interpreted as representing official policies,
 // either expressed or implied, of the FreeBSD Project.

 
 KVAresDataController.swift
 AresX
 
 Created by Kenn Villegas on 9/15/16.
 Copyright © 2016 K3nV. All rights reserved.

 */

import CoreLocation
import CoreData
import UIKit

let hexDigits: [String] = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]

enum saveState {
  case Error, RulesBroken, SaveComplete
}

class TricorderDataController<T : KVRootEntity > : AbstractDataController<T>
{

  var MOC : NSManagedObjectContext? = nil
  
  override init()
  {
    super.init()
    self.entityClassName = EntityTypes.Entity
    self.MOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }
  convenience init(_ ctx: NSManagedObjectContext)
  {
    self.init()
    self.entityClassName = EntityTypes.Entity
    self.MOC = ctx
  }

  //MARK: -
  // Data Accessors
  /**
  # Workhorse01
   
  - returns: All with sort (key: "incepDate", ascending: false)
  */
  func getAllEntities() -> Array<T>
  {
    let todosFetch : NSFetchRequest = NSFetchRequest<T>(entityName: entityClassName!)
    let sortDescriptor = NSSortDescriptor(key: "incepDate", ascending: false)
    
    todosFetch.fetchBatchSize = 20
    todosFetch.sortDescriptors = [sortDescriptor]
    
    do {
//      let r = try PSK.viewContext.fetch(todosFetch)
      let r = try MOC?.fetch(todosFetch)
      
      return r!
    } catch { fatalError("bitched\(error)") }
  }
  /**
   # Workhorse02
   
   - returns: Typed Array with sort (key: "incepDate", ascending: false)
   */
  func getEntities(sortedBy sortDescriptor:NSSortDescriptor?, matchingPredicate predicate:NSPredicate?) -> Array <T>
  {
    let todosFetch : NSFetchRequest = NSFetchRequest<T>(entityName: entityClassName!)
    todosFetch.fetchBatchSize = 20
    //
    if predicate != nil {
      todosFetch.predicate = predicate
    }
    if sortDescriptor != nil {
      todosFetch.sortDescriptors = [] as Array<NSSortDescriptor>
    }
    do { let r = try PSK.viewContext.fetch(todosFetch)
      return r } catch { fatalError("bitched\(error)")
    }
  }
  /**
  ## Get entities of the default type matching the predicate
   
  - returns: Typed Array
   */
  func getEntitiesMatchingPredicate(predicate: NSPredicate) -> Array<T>
  {
    return getEntities(sortedBy: nil, matchingPredicate: predicate)
  }
  /**
  Get entities of the default type sorted by descriptor and matching the predicate
   
  - returns: Typed Array
  */
  func getEntitiesSortedBy(sortDescriptor: NSSortDescriptor, matchingPredicate predicate:NSPredicate) -> Array<T>?
  {
    return getEntities(sortedBy: sortDescriptor, matchingPredicate: predicate)
  }
  
  func saveCurrentContext(_ ctx: NSManagedObjectContext)
  {
    if ctx.hasChanges {
      do {
        try ctx.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  /**
  Save changes to the specified entity
  ## Read these in test and for errors
  - returns: (saveState, saveMessage)
  */
  func saveEntity(entity: T) -> (state: saveState, message: String?)
  {
    var ss: saveState
    var saveMessage: String?
// Check the business rules
    saveMessage = checkRulesForEntity(entity: entity)
    if saveMessage == nil
    {
      let result = saveEntities()
      ss = saveState.SaveComplete
      saveMessage = result.message
    }
    else
    {
      ss = saveState.RulesBroken
    }
    return (state: ss, message: saveMessage)
  }
  /** 
   ## Saves changes to all entities

  - returns:  (saveState, saveMessage) 
   */
  func saveEntities() -> (state: saveState, message: String?)
  {
    var ss: saveState
    var saveMessage: String?
    //let context = persistentContainer.viewContext
    if let moc : NSManagedObjectContext = MOC
    {
      if moc.hasChanges {
        ss = saveState.Error
        saveMessage = error?.description
      }
      else
      {
        ss = saveState.SaveComplete
        saveMessage = "Good"
      }
    }
    else
    {
      ss = saveState.Error
      saveMessage = "Database error"
    }
    return (ss, saveMessage)
 
  }
  func checkRulesForEntity(entity: T) -> String?
  {
    return nil
  }
  /**
   ## Should be set to Default
   
   - Returns: \<T\> in ctx
   */
  override func createEntityInContext(_ context: NSManagedObjectContext, type: String) -> T {
    ///Also interesting this could just init a bare NSManaged Obj. I'll take teh errors I got b/c the app works better if this fails when I hit it
    return NSEntityDescription.insertNewObject(forEntityName: type, into: context) as! T
  }
  
  // MARK: Use objectID
  /**
   Mark the specified entity for deletion
   */
  func deleteEntityInContext(_ context: NSManagedObjectContext, entity: T)
  {
    //                    NSLog("Powa:: %@ !",object .objectID);
    //          I bp here if it breaks
    context.delete(entity)
  }
// MARK: NEATO
  
  func makeLocationObj(_ ctx: NSManagedObjectContext) -> KVRootEntityLocation
  {
    let ld = NSEntityDescription.entity(forEntityName: "KVRootEntityLocation", in: ctx)
    let loc = KVRootEntityLocation(entity: ld!, insertInto: ctx)
    
    return(loc)
  }
  func makeSizesObj(_ ctx: NSManagedObjectContext) -> KVRootEntitySizes
  {
    let sD = NSEntityDescription.entity(forEntityName: "KVRootEntitySizes", in: ctx)
    let sz = KVRootEntitySizes(entity: sD!, insertInto: ctx)
    return(sz)
  }
  //KVRootEntityGraphics
  func makeGraphicsObj(_ ctx: NSManagedObjectContext) -> KVRootEntityGraphics
  {
    let ed = NSEntityDescription.entity(forEntityName: "KVRootEntityGraphics", in: ctx)
    let g = KVRootEntityGraphics(entity: ed!, insertInto: ctx)
    return(g)
  }
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage
  {
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
    //    UIGraphicsBeginImageContextWithOptions(size: , <#T##opaque: Bool##Bool#>, <#T##scale: CGFloat##CGFloat#>)
    //image.drawInRect(0, 0, newWidth, newWidth)
    image.draw(in: (CGRect(x: 0, y: 0, width: newWidth, height: newWidth)))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
  /// ### flat random number gen
  func makeRandomNumber(_ range: UInt32) ->Int
  {
    return Int(arc4random_uniform(range))
  }
  /**
   ## DnD Style Random Number Generator.
   
   - parameter rolls: Numer of rolls of range
   - parameter range: range of the random number
   
   - returns: a bell shaped random curve
   */
  func makeRandomNumberCurve(_ rolls: Int,_ range: UInt32) ->Int
  {
    var dwell = 0
    for _ in 1...rolls {
      dwell += makeRandomNumber(range)
    }
    return dwell
  }
  func makeRandomHexQuad() -> String
  {
    var hex = String()
    for _ in 1...4 {
      let x = hexDigits[makeRandomNumber(16)]
      hex.append(x)
    }
    return hex
  }
  func mkRandomHexQuad() -> String
  {
    var hex = String()
    for _ in 1...4 {
      hex.append(hexDigits[makeRandomNumber(16)])
    }
    return hex
  }
  /**
  ## returns the address of a location
  Uses a ?? to prevent nil. it would put the pin in downtown Baltimore IIRC
   
  - parameter loc: a Loction Entity:
  */
  func getAddressOfLocation(loc: KVRootEntityLocation)
  {
    
    let locLat : Double = (loc.latitude?.doubleValue) ?? 39.283333
    let locLon : Double = (loc.longitude?.doubleValue) ?? -76.616667
    let location = CLLocation(latitude: locLat, longitude: locLon)
    let geocoder = CLGeocoder()
    
//    print("-> Finding user address...")
    
    geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
      var placemark:CLPlacemark!
      
      if error == nil && (placemarks?.count)! > 0 {
        placemark = (placemarks?[0])! as CLPlacemark

        var locAddressString:String = ""
        var addressString:String = ""

        if placemark.isoCountryCode == "US"
        {
          if placemark.country != nil {
            addressString = placemark.country!
          }

          if placemark.administrativeArea != nil {
            loc.state = placemark.administrativeArea!
            addressString = addressString + placemark.administrativeArea! + ", "
          }

          if placemark.subAdministrativeArea != nil {
            loc.city = placemark.subAdministrativeArea!
            addressString = addressString + placemark.subAdministrativeArea! + ", "
          }
          
          if placemark.postalCode != nil {
            loc.zipCode = placemark.postalCode!
            addressString = addressString + placemark.postalCode! + " "
          }

          if placemark.locality != nil {
            loc.city = placemark.locality!
            addressString = addressString + placemark.locality!
          }
          
          if placemark.subThoroughfare != nil {
            addressString = addressString + placemark.subThoroughfare!
            locAddressString = (placemark.subThoroughfare! + " ")
            loc.address = placemark.subThoroughfare!
          }
          
          if placemark.thoroughfare != nil {
            addressString = addressString + placemark.thoroughfare!
            locAddressString.append(placemark.thoroughfare!)
          }
          
          loc.address = locAddressString

        }
        else {
          if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
          }
          
          if placemark.thoroughfare != nil {
            addressString = addressString + placemark.thoroughfare! + ", "
          }

          if placemark.postalCode != nil {
            addressString = addressString + placemark.postalCode! + " "
          }

          if placemark.locality != nil {
            addressString = addressString + placemark.locality! + ", "
          }

          if placemark.administrativeArea != nil {
            addressString = addressString + placemark.administrativeArea! + " "
          }

          if placemark.country != nil {
            addressString = addressString + placemark.country!
          }

        }
        print(addressString)
      }
    })
    
  }
}

