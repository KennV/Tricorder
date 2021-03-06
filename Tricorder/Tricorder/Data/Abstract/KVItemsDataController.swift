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
 
 KVItemsDataController.swift



 */

/**
 OK New Notes:
 I Need A Protocol Here
 I will Add (2)
*/

protocol KVItemsDelegate {
  func mkItemForOwner(_ entity: KVEntity)
}

protocol KVItemsDataSource {
  
}


import CoreData
import Foundation
let ItemStates: [String] = ["pending", "sent", "in-transit", "delivered", "recieved"]
let ItemTypes: [String] = ["food-bev", "msg-pkg"]

class KVItemsDataController <T : KVItem> : TricorderDataController<T>
{
  
  override init()
  {
    super.init()
    self.entityClassName = EntityTypes.Item
  }
  func makeItem(_ ctx: NSManagedObjectContext) -> T
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: entityClassName!, in: MOC!)
    let item = KVItem(entity: entityDescription!, insertInto: MOC) as! T
    _ = saveEntity(entity: item)
    saveCurrentContext(MOC!)
    return(item)
  }
  func makeItemAllUp(_ ctx: NSManagedObjectContext) -> T
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: entityClassName!, in: ctx)
    let item = KVItem(entity: entityDescription!, insertInto: MOC) as! T
    _ = saveEntity(entity: item)
    saveCurrentContext(ctx)
    return(item)
  }
}
