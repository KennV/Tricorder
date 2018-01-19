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


KVEventDataController.swift
Ares

Created by Kenn Villegas on 9/7/16.
Copyright © 2016 K3nV. All rights reserved.

*/

import MapKit
import CoreData
import UIKit

class KVEventDataController <T:KVEvent> : KVEntityDataController<T>
{
  override init() {
    super.init()
    self.dbName = "Tricorder"
    self.entityClassName = "KVEvent"
  }
  func makeEvent(_ ctx: NSManagedObjectContext) -> T
  {
    let event = createEntityInContext(ctx, type: entityClassName!)
    event.incepDate = NSDate()
    event.graphics = makeGraphicsObj(ctx)
    event.sizes = makeSizesObj(ctx)
    event.location = makeLocationObj(ctx)
    event.graphics?.photoActual = UIImage(named: "10" )
    _ = self.saveEntity(entity: event)
    return(event)
  }
  func makeEvent(_ ctx: NSManagedObjectContext, loc: CLLocationCoordinate2D) -> T
  {
    let event = makeEvent(ctx)
    event.incepDate = NSDate()
    
    event.location?.latitude = loc.latitude as NSNumber?
    event.location?.longitude = loc.longitude as NSNumber?
    setupEvent(event)
   
    _ = self.saveEntity(entity: event)
    
    return(event)
  }
  func setupEvent(_ e: T)
  {
    let eTypes : [String] = ["Meeting", "Study", "Dance", "Chill", "Appointment", "Movie"]
    
    e.type =  eTypes[makeRandomNumber(UInt32(eTypes.count))]
    e.status = (makeRandomNumberCurve(10, 10)as NSNumber)
    e.hexID = makeRandomHexQuad()
    e.qName = "Event: "
    
    e.duration = 1800 // half an hour
    e.startTime = e.incepDate
    e.endTime = e.startTime?.addingTimeInterval((e.duration?.doubleValue)!)
    e.label = (makeRandomNumber(5)as NSNumber)
    e.priority = (makeRandomNumber(5)as NSNumber)
    e.title = "New "
    
  }
  
}
