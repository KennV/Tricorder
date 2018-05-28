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



KVPersonDataController.swift
Ares

Created by Kenn Villegas on 9/5/16.
Copyright © 2016 K3nV. All rights reserved.
*/

import MapKit
import CoreData
import UIKit

protocol PersonActionDelegate  {
  func mkReport()
}
//MARK: protocols
/**
 ## Protocol to do Render Functions
 
 Important Zesty
 ```
 func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
 ```
 Parameters: position: CGPoint
 */
protocol Renderer
{
  //   Moves the pen to `position` without drawing anything.
  func moveTo(position: CGPoint)
  // Draws a line from the pen's current position to `position`, updating the pen position.
  func lineTo(position: CGPoint)
  // Draws the fragment of the circle centered at `c` having the given `radius`, that lies between `startAngle` and `endAngle`, measured in radians.
  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}
// http://iosunittesting.com/testing-swift-protocol-delegates/
protocol Drawable : class
{
  //  Issues drawing commands to `renderer` to represent `self`.
  func draw(renderer: Renderer)
}
//MARK: Dark
struct TestRenderer : Renderer
{ // If this is IDK how to say it but it seems to make more sense as a class
  //It still comes up correctly in test
  //class TestRenderer : Renderer {
  func moveTo(position p: CGPoint)
  {
    print("moveTo: (\(p.x), \(p.y))")
  }
  func lineTo(position p: CGPoint)
  {
    print("lineTo: (\(p.x), \(p.y))")
  }
  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
  {
    print("arcAt: (\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
  }
}

/** # Contoller for KVPerson
 
- returns: <T : KVPerson> */
class KVPersonDataController <T : KVPerson> : KVEntityDataController<T>
{
  
  override init()
  {
    super.init()
    entityClassName = EntityTypes.Person
  }
  // I was getting an edge case where it was returning a .Entity not a .Person
  convenience init(_ ctx: NSManagedObjectContext)
  {
    self.init()
    self.entityClassName = EntityTypes.Person
    self.MOC = ctx
  }
  
  /**
  ## make person
   
  - parameter ctx: a MOC
   
  - returns: Person as T 
  */
  func makePerson(_ ctx: NSManagedObjectContext) -> T
  {
    let p = createEntityInContext(ctx, type: entityClassName!)
    p.graphics = makeGraphicsObj(ctx)
    p.sizes = makeSizesObj(ctx)
    p.location = makeLocationObj(ctx)
    
    p.vehicle = makeVehicleObj(ctx)
    setupDefaultVehicle(p.vehicle!)
    _ = saveEntity(entity: p)
    return(p)
  }
  /**
  ## Using makePerson() init all required state
  
  - parameter ctx: a MOC
   
  - returns: Person as T
   */
  func makePersonAllUp(_ ctx: NSManagedObjectContext) -> T
  {
    let p = makePerson(ctx)
    setupPersonData(p)
    setupGraphicsObj(p)
    setupSizesObj(p)
    makeRandomName(p)
    makeEmailAndTextID(p)
    p.phoneNumber = makeRandomPhoneNumber()
    p.hexID = mkRandomHexQuad()
    _ = saveEntity(entity: p)
    return(p)
  }
  /**
  # person data defaults
  
  - parameter p: a Valid Person */
  func setupPersonData(_ p: T)
  {
    // I Suppose that it is possible to do them all as T but not this commit
    p.status = 100
    p.incepDate = NSDate()
    p.type = "Person"

  }
  /**
  # Name randomizer
  
  - parameter p: vaild P */
  func makeRandomName(_ p: KVPerson)
  {
    if (makeRandomNumber(100) <= 50)
    {  //Half of P get male names
      p.firstName = maleNames[makeRandomNumber(20)]
    }
    else
    {  //Half of P get female names
      p.firstName = femaleNames[makeRandomNumber(20)]
    }
    // all get a similar last name
    p.lastName = lastNames[makeRandomNumber(20)]
    let m = makeRandomNumber(100)
    if ( m >= 25)
    {  //75% of p get middle names
      if (makeRandomNumber(100) <= 80)
      {
        p.middleName = femaleNames[makeRandomNumber(20)]
      }
      else
      {
        p.middleName = maleNames[makeRandomNumber(20)]
      } //the rest get an empty non nil String
    }
    else
    {
      p.middleName = ""
    }
    p.qName = p.lastName! + ", " + p.firstName! + " " + p.middleName!
  }
  /**
  # email and textID
  
  - parameter p: p */
  func makeEmailAndTextID(_ p: KVPerson)
  {
    /**
     It almost made sense to have the firstInitialLastName
     but that would clash sooner rather than later
     let _ = p.firstName?[(p.firstName?.startIndex)!]
     */
//    p.ema
    p.emailID = (p.firstName! + "." + p.lastName! + "@" + "test.edu")
    p.textID =  (p.firstName! + mkRandomHexQuad() + "@" + "test.edu")
  }
  /**
  # Vehicle Class
  
  - parameter ctx: this MOC
  
  - returns: KVVehicle */
  func makeVehicleObj(_ ctx: NSManagedObjectContext) -> KVVehicle
  {
    let vd = NSEntityDescription.entity(forEntityName: EntityTypes.Vehicle, in: ctx) // Don't use a literal here
    let vV = KVVehicle(entity: vd!, insertInto: ctx)
  
    return(vV)
  }
  /**
  # RANDOMIZE ME PLEASE 
   
  - parameter: KVVehicle
  */
  func setupDefaultVehicle(_ v: KVVehicle) {
    let carBrands: [String] = ["Audi", "Porsche", "Ford", "Volvo", "Toyota", "BMW", "Ferrari", "GM", "Cheverolet"]
    let bikeBrands: [String] = ["Trek", "GT", "Wilkerson Airlines", "Canondale", "Schwinn", "Standard", "RiBCO", "Haro"]

    let vColor: [String] = ["Red", "Gold", "Silver", "Black", "Yellow" ]
    let vModel: [String] = ["Base", "Medium", "High", "Custom ", "Competition"]

    let mode = makeRandomNumber(2)
    switch mode {
    case 1:
      v.make = bikeBrands[makeRandomNumber(UInt32(bikeBrands.count))]
      v.model = vModel[makeRandomNumber(UInt32(vModel.count))]
      v.color = vColor[makeRandomNumber(UInt32(vColor.count))]
      v.numberOfWheels = 2
    default:
      v.make = carBrands[makeRandomNumber(UInt32(carBrands.count))]
      v.model = vModel[makeRandomNumber(UInt32(vModel.count))]
      v.color = vColor[makeRandomNumber(UInt32(vColor.count))]
      //    v.Typ
      v.numberOfWheels = 4
    }
  }

}
