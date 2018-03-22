/**
  TC_DBTests.swift
  Tricorder

  Created by Kenn Villegas on 10/1/16.
  Copyright © 2016 K3nV. All rights reserved.

It is _IMPOSSIBLE_ to overstate just how easy it was to implement test in here
It is the smae code as the production BUT I set the StoreType: NSInMemoryStoreType
Then I simply make a nil moc and set it to a new inMemPSK / SUT_PSK and nil 
it again in the teardown and it is *Done*
This allows me to put this into test (And work this project like a sane human being)
 
The other Fun thing is that I am not even init'g the test controllers. ther really is no reason to
*/

import CoreData
import CoreLocation
import XCTest
@testable import Tricorder

class TC_DBTests: XCTestCase
{
  var SUT_PSK : NSPersistentContainer? = nil
  
  func setupPSK() -> NSPersistentContainer  {
//    let st = "NSInMemoryStoreType" // storeType
    let container = NSPersistentContainer(name: "Tricorder")
    container.loadPersistentStores(completionHandler: { (NSInMemoryStoreType, error) in
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
//    container.NSS
    return container
  }
  
  var MOC : NSManagedObjectContext? = nil

  func LIVEsetUpInMemoryManagedObjectContext()  {
    SUT_PSK = setupPSK()
    MOC = SUT_PSK?.viewContext
  }
  
  func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext
  {
    //
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    do {
      try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
      print("Adding in-memory persistent store coordinator failed")
    }
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    return managedObjectContext
  }
  
  override func setUp() {
    super.setUp()
    MOC = setUpInMemoryManagedObjectContext()
  }
  
  override func tearDown() {
    MOC = nil
//    SUT_PSK = nil
    super.tearDown()
  }
  
  func testPersonController() {
    let pCon = KVPersonDataController()
    pCon.MOC = self.MOC
    XCTAssertNotNil(pCon.MOC, "Must have TestMOC to proceed")
    let jiveJoe = pCon.makePerson(pCon.MOC!)
    XCTAssertNotNil(jiveJoe, "ust be able to make JJ to proceed")
    XCTAssertNotNil(pCon.getAllEntities())
    pCon.deleteEntityInContext(pCon.MOC!, entity: jiveJoe)
//    XCTAssertEqual(1, pCon.getAllEntities().count)
  }
  
  func testPersonAllUp()
  {
    let pCon = KVPersonDataController()
    pCon.MOC = self.MOC
    let pp = pCon.makePersonAllUp(pCon.MOC!)
    pCon.makeRandomName(pp)
    XCTAssertNotNil(pp.location, "Need Location Obj")
    pCon.deleteEntityInContext(pCon.MOC!, entity: pp)
  }
  
  func testTVCon()
  {
    let AllDataController = TricorderDataController()
    AllDataController.MOC = MOC

    let SUT = KVPrimeTVCon()
    SUT.dvc = KVMapViewCon()
    SUT.pdc.MOC = MOC
    SUT.placesDC.MOC = MOC
    for _ in 1...20 {
      SUT.willAddPerson(self)
      _ = SUT.placesDC.makePlace(SUT.placesDC.MOC!)
    }
  
    XCTAssertNotNil(SUT.viewDidLoad())
  }  
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  /** REFACTOR TEST CASES
   */
  //New testCases
  
  //
  func testSaveState() {
    /** Ok
     I fully expect this to burn up, except that it currently works; So the desired effect is to see the what, when and how it performs save */
  }
  
  func testMockPersonController()
  {
    /**
     OK Jajaja,haha haaa Ha Bitches I am already wicked Close
     What happens, compile wise if I inject the dependency?
     - if it does not work fix and document it
     What happens when I init it?
     - what is the Optimal Init-Chain
     Can I pop that over to a background queue?
    */
  }

  func testPhotoEditState()
  {
    /** Given a PhotoProtocol
     I should return two true states
     one for the imageWillChange/DidChange
     and a second for the entityDidSave[- saveEntity]
     I can set it as an observer
    */
  }
  
  func testPhotoWasSentNonPhotoItem()
  {
    /**
     What happens if I take the object
     init & set;
     changeAndSave;
     changeToNil;
     changeToMovieItem;
    */
  }
  
  // New Protocol
  func testPersonMakesItem()
  {
    /**
     Attempt to make a new person (p) and have P's controller
     initItemWithOwner:<T>
     Expected Result.
    */
    
  }
  func testPersonHasMultpileItems()
  {
    /**
     Okay, if this is true then I should be able to add a list of items
    */
  }
  
  func testPesronCanTensferItem()
  {
    /**
     P's controller needs two <T> person and set ownership of item to P2
     func treanferItem(_ item : KVItem, _ p1 : KVPerson, _ p2)

    */
  }
  //
  
  /**
   Given a working Mock can I make another for a different Type of Item
   Can I make a mockSubclass here first?
   
   */
  // test another thing
  /**
   Given a ::items:message _message:<T> can I make one again?
   can I mutate it here?
   does the itemsTopDataController? See all of the
   */
}
