/**
  TricorderTests.swift
  TricorderTests

  Created by Kenn Villegas on 9/29/16.
  Copyright © 2016 K3nV. All rights reserved.


*/

/**
 Preposito:
 Put the test-mock on a background thread
 Put the view-con as dependent on the test state.
 do all of the tests from here.
 ;  This Is prototyped in Argent
*/
import CoreData
import CoreLocation
import XCTest

class MockEntityDataController <T : KVEntity> : TricorderDataController<T>
{
  
}

class MockItemsDataController <T : KVItem> : TricorderDataController<T>
{
  
}
@testable import Tricorder

class TricorderTests: XCTestCase {
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}
