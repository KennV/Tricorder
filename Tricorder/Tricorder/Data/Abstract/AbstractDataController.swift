/**
https://en.wikipedia.org/wiki/BSD_licenses
BSD Style-License
Copyright © 2015, Kenneth Villegas
Copyright © 2015 K3nV. All rights reserved.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the FreeBSD Project.


KVAbstractDataController.swift
AresED-V

Created by Kenn Villegas on 11/23/15.
Copyright © 2015 K3nV. All rights reserved.



this gets called from the App Deli
let controller = masterNavigationController.topViewController as! MasterViewController
OR A NavKhan!!!
controller.managedObjectContext = self.persistentContainer.viewContext

Which I need to make in the vue
*/

import UIKit
import CoreData

class AbstractDataController<T : NSManagedObject> : NSObject
{
  // I made this optional Then set it in the init and then force-unwrap it in _.managedObjectModel
  var dbName : String = "Ares"
  var entityClassName : String?
  var error : NSError?
  // var copyDatabaseIfNotPresent : Bool = false
  var appName: String?  = "Tricorder"
  //PSK is the Container for this
  lazy var PSK: NSPersistentContainer = {
    /*
     This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     Like if I change the type or other things
     */
    let container = NSPersistentContainer(name: self.appName!)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }() //Returns a MOC as PSK.viewContext
  
  func saveContext () {
    let context = PSK.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  /// MARK: Baseline init() works in r\t & Test
  /**
  
  */
  func createEntityInContext(_ context: NSManagedObjectContext, type: String) -> T
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: type, in: context)
    let e = NSManagedObject(entity: entityDescription!, insertInto: context) as! T
    return e
  }
  // MARK: - Fetched results controller
  var _fetchedResultsController: NSFetchedResultsController<T>? = nil
  
  var fetchedResultsController: NSFetchedResultsController<T> {
    if _fetchedResultsController != nil {
      return _fetchedResultsController!
    }
    
    // Set the batch size to a suitable number.
    let fetchRequest = NSFetchRequest<T>(entityName: "KVRootEntity")
    fetchRequest.fetchBatchSize = 20
    
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "incepDate", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.PSK.viewContext,
                                                               sectionNameKeyPath: nil, cacheName: "Master")
    _fetchedResultsController = aFetchedResultsController
    
    do {
      try _fetchedResultsController!.performFetch()
    } catch {
      //Never seen it happen in millions of tests
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return _fetchedResultsController!
  }
  
  
  
}
