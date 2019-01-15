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
 
The other Fun thing is that I am not even init'g the test controllers. there really is no reason to
 
** Re-Ignition Revision ##
OK Based on testMockPersonController() and Similar. It looks like I could do this without the container, _per se_: It could be done with only the MOC, So I will have to be able to
 
¿Qué?
 Okay; I have a New Notes.App-List BUGLIST;
 Several of the important things Are [in a _hopefully_ :]
 - Map might use a location
 - current VueMight
¿OK?
*/

import CoreData
import CoreLocation
import XCTest
@testable import Tricorder

//
class MockPersonDataController <T : KVPerson> : KVPersonDataController<T>
{
  
}
//
class MockTricorderDataController<T : KVRootEntity > : TricorderDataController<T> {
  
}
class TC_DBTests: XCTestCase
{
  var container : NSPersistentContainer? = nil
  var inMemoryContext : NSManagedObjectContext? = nil
  
  func createInMemoryContainer() -> NSPersistentContainer  {
//    let st = "NSInMemoryStoreType" // storeType
    let container = NSPersistentContainer(name: "Tricorder")
    container.loadPersistentStores(completionHandler: { (NSInMemoryStoreType, error) in
      if let error = error as NSError?
      {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
//    container.NSS
    return container
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
//    container = createInMemoryContainer() // Not redundant and not super necessary
    inMemoryContext = setUpInMemoryManagedObjectContext()
  }
  
  override func tearDown() {
    inMemoryContext = nil
    super.tearDown()
  }
  
  func testPersonController() {
    let pCon = MockPersonDataController()
    pCon.MOC = self.inMemoryContext
    XCTAssertNotNil(pCon.MOC, "Must have TestMOC to proceed")
    let jiveJoe = pCon.makePerson(pCon.MOC!)
    XCTAssertNotNil(jiveJoe, "Must be able to make JJ to proceed")
    XCTAssertNotNil(pCon.getAllEntities())
    pCon.deleteEntityInContext(pCon.MOC!, entity: jiveJoe)
//    XCTAssertEqual(1, pCon.getAllEntities().count)
  }
  
  func testPersonAllUp()
  {
    let pCon = MockPersonDataController()
    pCon.MOC = self.inMemoryContext
    let pp = pCon.makePersonAllUp(pCon.MOC!)
    pCon.makeRandomName(pp)
    XCTAssertNotNil(pp.location, "Need Location Obj")
    pCon.deleteEntityInContext(pCon.MOC!, entity: pp)
  }
  
  func testTVCon()
  {
    let AllDataController = MockTricorderDataController()
    AllDataController.MOC = inMemoryContext
    // OR I can test this from the other testCase
    // and get the Test-Rig-MainWindow()
    let SUT = KVPrimeTVCon()
    SUT.dvc = KVMapViewCon()
    SUT.pdc.MOC = inMemoryContext
    SUT.placesDC.MOC = inMemoryContext
    for _ in 1...200 {
      SUT.willAddPerson(self)
      _ = SUT.placesDC.makePlace(SUT.placesDC.MOC!)
    }
    XCTAssertNotNil(SUT.viewDidLoad())
  }  

  
  /** REFACTOR TEST CASES
   */
  //New testCases
  
  //
  func testSaveState()
  {
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
     - does that fail?, How?
    */
    let tCon = MockTricorderDataController()
    tCon.MOC = inMemoryContext
    XCTAssertNotNil(tCon.createEntityInContext(tCon.MOC!, type: "KVRootEntity"), "thing")
  }

  func testPhotoEditState()
  {
    /** Given a PhotoProtocol
     I should return two true states
     one for the imageWillChange/DidChange
     and a second for the entityDidSave[- saveEntity]
     I can set it as an observer
     NOTE: I actually do this from a protocol
     AND it works, the bugfix is documented.
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
  
  func testPersonMakesMultpileItems()
  {
    /**
     Okay, if this is true then I should be able to add a list of items
    */
  }
  
  func testPesronCanTransferItem()
  {
    /**
     P's controller needs two <T> person and set ownership of item to P2
     func treanferItem(_ item : KVItem, _ p1 : KVPerson, _ p2)

    */
  }
  
  func testPersonCanTransferAllItems()
  {
    /**
     Like above but sexier. for every item in P1's.Items setOwner -> P2
    */
  }
  
  //
  
  /**
   Given a working Mock can I make another for a different Type of Item
   Can I make a mockSubclass here first?
   ANSWER: Yup
   */
  // test another thing
  /**
   Given a ::items:message _message:<T> can I make one again?
   can I mutate it here?
   does the itemsTopDataController? See all of the
   */
  /**
   YEAH THIS _OTHER THING_ Protocols
   Or a better question could be if the tests actually run through the protocol. [which has not been implemented] 
  */
}
