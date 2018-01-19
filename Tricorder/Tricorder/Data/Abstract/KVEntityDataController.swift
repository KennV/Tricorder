/**
https:en.wikipedia.org/wiki/BSD_licenses
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

 KVEntityDataController

*/


struct EntityTypes {
  static let Graphics = "KVRootEntityGraphics"
  static let Sizes = "KVRootEntitySizes"
  static let Place = "KVPlace"

  static let Person = "KVPerson"
  static let Vehicle = "KVVehicle"
  static let Item = "KVItem"
  static let Message = "KVMessageMO"
  static let Package = "KVPackage"

//  static let Message = "KVMessageMO"

  static let Medicine = "KVMedicine"
  static let Meal = "KVMeal"
  static let Food = "KVFoodType"
  static let Event = "KVEvent"
  static let Entity = "KVEntity"
  static let Beverage = "KVBeverageType"
}

let femaleNames: [String] = ["Jessica","Ashley","Amanda","Sarah","Jennifer","Brittany","Stephanie","Samantha","Nicole","Elizabeth","Lauren","Megan","Tiffany","Heather","Amber","Melissa","Danielle","Emily","Rachel","Kayla"]
let maleNames: [String] = ["Michael","Christopher","Matthew","Joshua","Andrew","David","Justin","Daniel","James","Robert","John","Joseph","Ryan","Nicholas","Jonathan","William","Brandon","Anthony","Kevin","Eric"]
let lastNames: [String] = ["Cero","Uno","Dos","Tres","Quatro","Cinco","Seis",   "Siete","Ocho","Nueve","Diez","Once","Doce","Triece","Catorce","Quince","Diesiseis","Dies y Siete","Diez y Ochco","Diez y Nueve"]

import MapKit
import UIKit
import CoreData

class KVEntityDataController <T : KVEntity> : TricorderDataController<T>
{

  override init()
  {
    super.init()
    self.entityClassName = EntityTypes.Entity
  }
  /**
  # update loc
   
  - parameter p: Entity
  - parameter loc: loc 
  */
  func updateLocationFor(_ t: T, loc: CLLocationCoordinate2D)
  {
    t.location?.latitude = loc.latitude as NSNumber?
    t.location?.longitude = loc.longitude as NSNumber?
  }
  /**
  # Graphics Setup
  ## this binary data is required
  - parameter p: valid person 
  */
  func setupGraphicsObj(_ t : T)
  {
    t.graphics?.photoActual = UIImage(named: "0" + hexDigits[self.makeRandomNumber(9)])
    
  }
  /**
  # setup the sizeMO
   
  - parameter p: valid Entity */
  func setupSizesObj(_ t: T)
  {
    //    p.sizes?.massKG = NSNumber(42 + (makeRandomNumber(3) * 4))
    t.sizes?.massKG = 13
    t.sizes?.xLong = 1.50
    t.sizes?.yWide = 0.75
    t.sizes?.zTall = 0.50
  }
  /**
  # Makes a TenDigit
  in the least surprising way
  - returns: TenDigit 
   */
  func makeRandomPhoneNumber() -> String
  {
    let areaCodes : [String : NSNumber] = ["Philadelphia1" : 217 , "Philadelphia2" : 267 , "Bronx1" : 718 , "Bronx2" : 347 , "Bronx3" : 929 , "Connecticut1" : 203 , "Connecticut2" : 860 , "Connecticut3" : 475 , "Portland1" : 503 , "Portland2" : 541 , "Portland3" : 971 , "Portland4" : 458 , "Manhattan1" : 212 , "Manhattan2" : 646 , "Manhattan3" : 332 , "Baltimore1" : 410 , "Baltimore2" : 443 , "Austin1" : 512 , "Austin2" : 737 , "Phoenix1" : 602 , "Phoenix2" : 480 , "Phoenix3" : 520 , "Phoenix4" : 928 , "Phoenix5" : 623 , "Chicago1" : 312 , "Chicago2" : 847 , "Chicago3" : 773 , "Chicago4" : 630 , "Chicago5" : 815 ]
    // there was a 2 line situation but I Have a Randomizer
    let zone = Array(areaCodes.values)[self.makeRandomNumber(UInt32(areaCodes.count))]
    
    var pnum = ("(" + zone.stringValue + ") " ) //Trailing Space
    
    pnum.append(hexDigits[self.makeRandomNumber(4) + 4]) //first digit
    for _ in 1...2 // tirst Triplet
    {
      pnum.append(hexDigits[self.makeRandomNumber(8) + 1])
    }
    pnum.append("-")
    for _ in 1...4
    {
      pnum.append(hexDigits[self.makeRandomNumber(9)])
    }
    return (pnum)
    
  }
}
