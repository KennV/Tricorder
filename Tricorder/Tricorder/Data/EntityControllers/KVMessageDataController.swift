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


KVMessageDataController.swift
Ares

Created by Kenn Villegas on 9/5/16.
Copyright © 2016 K3nV. All rights reserved.

*/

import CoreData
import UIKit

class KVMessageDataController <T:KVMessageMO> : KVItemsDataController<T>
{
  override init() {
    super.init()
    self.dbName = "Tricorder"
    self.entityClassName = "KVMessageMO"
  }
  /**
   # Add to persons messageStack
  
   - parameter recieverID: other Person
   - parameter from:       the PERSON
  
   - returns: Natuarally a <T> of the Person */
  func makeMessageTo(_ recieverID: String, from: KVPerson) -> T
  {
    let msg = (makeEmptyMessage())
    setupMessageState(msg)
    msg.messageOwner = from
    msg.recieverID = recieverID
    msg.senderID = from.qName
//    this is Factually correct but not implemented
//    msg.location?.latitude = from.location?.latitude
//    msg.location?.longitude = from.location?.longitude
    _ = saveEntity(entity: msg)
    return(msg)
  }
  func makeEmptyMessage() -> T {
    let msg = createEntityInContext(MOC!, type: entityClassName!)
    msg.incepDate = NSDate()
    msg.sizes = makeSizesObj(MOC!)
    msg.location = makeLocationObj(MOC!)
    return(msg)
  }
  func setupMessageState(_ msg: T)
  {
    msg.sizes = makeSizesObj(MOC!)
    msg.cost = makeRandomNumberCurve(25, 10) as NSNumber?
    msg.price = (msg.cost!.floatValue * (1.75)) as NSNumber?
    msg.rating = (100)
    msg.stateOfItem = (1)
    msg.hexID = makeRandomHexQuad()
    msg.incepDate = NSDate()
    msg.type = "Message"
    msg.qName = "Pending Message"
    //_ = saveEntity(entity: msg)
  }
  
}
