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

  KVPlaceDataController.swift
  Ares

  Created by Kenn Villegas on 9/7/16.
  Copyright © 2016 K3nV. All rights reserved.

 
 
did this in LoadPinData to geocode existing pins
plc.getAddressOfLocation(kve.location!) Added this to geocode the ones that are already in the iPhone
*/

//Current Product Module must be set in the xcdm
import CoreLocation
import MapKit
import CoreData
import UIKit

class KVPlaceDataController <T : KVPlace> : KVEntityDataController<T>
{
  override init()
  {
    super.init()
    self.dbName = "Tricorder"
    self.entityClassName = "KVPlace" 
  }
  func makePlaceWithLocation(_ ctx: NSManagedObjectContext, loc: CLLocationCoordinate2D) -> T
  {
    let place = makePlace(ctx)
    place.location?.latitude = loc.latitude as NSNumber?
    place.location?.longitude = loc.longitude as NSNumber?
    setupRandomPlace(place)
    return place
  }
  func makePlace(_ ctx: NSManagedObjectContext) -> T
  {
    let place = createEntityInContext(ctx, type: entityClassName!)
    place.graphics = makeGraphicsObj(ctx)
    place.sizes = makeSizesObj(ctx)
    place.location = makeLocationObj(ctx)
    //NEED GFX
    place.graphics?.photoActual = UIImage(named: "0" + hexDigits[makeRandomNumber(9)])
    _ = saveEntity(entity: place)
    return(place)
  }
  //
  func setupRandomPlace(_ p: T)
  {
    // place level
    p.numberOfSides = 4
    p.privateIfTrue = true // changed in the xcdm
    p.radiusMeters = 10
    p.rating = 50
    //
    let types : [String] = ["street", "BusStop", "MiniMart", "Tag01", "Tag02"]
    p.type = types[makeRandomNumber(UInt32(types.count))]
    p.status = 100
    p.hexID = makeRandomHexQuad()
    p.qName = types[makeRandomNumber(UInt32(types.count))]
    // Call the coder for location
//    getAddressOfLocation(p.location!)
    //moving past blocked locationGeoC on p
    
  }
}
