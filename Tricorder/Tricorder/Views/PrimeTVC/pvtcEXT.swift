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

 KVPrimeTVCon.swift
 Ares3
 
 Created by Kenn Villegas on 9/19/16.
 Copyright © 2016 K3nV. All rights reserved.
 
*/

import CoreLocation
import CoreData
import UIKit
import Foundation

extension KVPrimeTVCon: CLLocationManagerDelegate
{
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "showDetail"
    {
      if let indexPath = tableView.indexPathForSelectedRow {
        let p = pdc.getAllEntities()[(indexPath as NSIndexPath).row]
        let mapC = (segue.destination as! UINavigationController).topViewController as! KVMapViewCon
        mapC.delegate = self
        mapC.currentPerson = p
        mapC.pdc = pdc
        mapC.plc = placesDC
        //          mapC.idc = idc
        mapC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        mapC.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
  func setupCLManager ()
  {
    locationManager?.delegate = self
    setupCLAuthState()
    locationManager?.distanceFilter = kCLDistanceFilterNone
    // According to BestPractices I was OK but now I am modern
    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    //looking into a no-init bug
//    locationManager?.activityType = .otherNavigation
    locationManager?.startUpdatingLocation()
    findLocation()
  }
  func setupCLAuthState()
  {
    if (CLLocationManager.authorizationStatus() == .notDetermined) {
      locationManager?.requestAlwaysAuthorization() // then set energy states
    }
    
  }
  // TODO: Update the RSRC string/URL in here
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus)
  {
    switch status {
    case .authorizedAlways:
      break
    case .notDetermined:
      manager.requestAlwaysAuthorization()
    case .authorizedWhenInUse, .restricted, .denied:
      
      let alertVC = UIAlertController(
        title: "Background Location Services are Not Enabled",
        message: "In order to better determine usage and data patterns, please open this app's settings and set location access to 'Always'.",
        preferredStyle: .alert)
//      let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
      alertVC.addAction(UIAlertAction (title: "Cancel", style: .cancel, handler: nil))
      
      let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
        UIApplication.shared.open((URL(string:UIApplicationOpenSettingsURLString)!), options: [ : ], completionHandler: (nil))
      }
      alertVC.addAction(openAction)

      present(
        alertVC,
        animated: true,
        completion: nil)
    }
   
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
  {
    print("No-Loc")
  }
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation])
  {
    foundLocation()
  }
  func findLocation()
  {
    let defLat : Double = 37.33115792
    let defLon : Double = -122.03076853
    ///These locations are from gdb output,
    // They should be revised to reflect "home"
    print(locationManager?.location?.coordinate.latitude ?? defLat)
    print(locationManager?.location?.coordinate.longitude ?? defLon)
  }
  func foundLocation()
  {
    locationManager?.stopUpdatingLocation()
  }
  // moved the coder to the AresDataController
  func forwardGeocoding(address: String)
  {
    CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
      if error != nil
      {
        print(error!) //force unwrapped
        return
      }
      if (placemarks?.count)! > 0
      {
        let placemark = placemarks?[0]
        let location = placemark?.location
        let coordinate = location?.coordinate
        print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
        if (placemark?.areasOfInterest?.count)! > 0
        {
          let areaOfInterest = placemark!.areasOfInterest![0]
          print(areaOfInterest)
        }
        else
        {
          print("No area of interest found.")
        }
      }
    })

  } // OK it is not what I want (YET)
  
  
  //
  // MARK: Delegate Conformance
  //
  func didChangePerson(_ entity: KVPerson)
  {
    _ = pdc.saveEntity(entity: entity)
//    pdc.saveContext() // This is to fix the photo not persisting in HW Bug
    pdc.saveCurrentContext(pdc.MOC!)
    tableView.reloadData()
  }
  
  func willAddPerson(_ deli: Any?) {
    findLocation()
    insertNewPerson(self)
  }
  func willMakeNewPlaceHere(_ deli: Any?)
  {
    findLocation()
    insertNewPlace(self)
  }
  func willAddNewEvent( _ deli: Any?)
  {
    findLocation()
    insertNewEvent(self)
    tableView.reloadData()
    eventsDC.saveContext()
    dvc?.configureView() // Added to test event synx did not
  }
  func willMakeMessageFromPerson(_ person: KVPerson?)
  {
    let md = msgMODC.makeMessageTo("Nobody", from: (person)!)
    // If I set the location THERE it is 'stacked'
    md.location?.latitude = locationManager?.location?.coordinate.latitude as NSNumber?
    md.location?.longitude = locationManager?.location?.coordinate.longitude as NSNumber?
    msgMODC.saveContext()
//    allMessages.insert(md, at: 0)
    tableView.reloadData()
  }
  /**
   Buttons in the TVC header sections
   ::Taking this out of the insertNew Object
   ADDING IT BACK
   
   These are called from the 
   */
  func insertNewPerson(_ sender: AnyObject)
  {
    findLocation()
    let p = pdc.makePersonAllUp(pdc.MOC!)
    pdc.updateLocationFor(p, loc: (locationManager?.location?.coordinate)!)
    pdc.getAddressOfLocation(p.location!)
    _ = pdc.saveEntity(entity: p)

    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    pdc.saveCurrentContext(pdc.MOC!)
    dvc!.configureView()
    
  }
  func insertNewPlace(_ sender: AnyObject)
  {
    let pl = placesDC.makePlaceWithLocation(placesDC.MOC!, loc: (locationManager?.location?.coordinate)!)
    placesDC.getAddressOfLocation(pl.location!)
    
    _ = placesDC.saveEntity(entity: pl)
    placesDC.saveCurrentContext(placesDC.MOC!)
    tableView.reloadData()
    foundLocation()
  }
  func insertNewEvent(_ sender: AnyObject)
  {
    _ = eventsDC.makeEvent(eventsDC.MOC!, loc: (locationManager?.location?.coordinate)!)

    _ = eventsDC.saveEntities()
    let indexPath = IndexPath(row: 0, section: 2)
    tableView.insertRows(at: [indexPath], with: .automatic)
    eventsDC.saveCurrentContext(eventsDC.MOC!)
    dvc!.configureView()
  }
  func insertNewMsgMO(_ sender: AnyObject)
  {
    let md = msgMODC.makeEmptyMessage()
    md.incepDate = NSDate()
    // location for the event is the same as for the person
//    allMessages.insert(md, at: 0)
    _ = msgMODC.saveEntity(entity: md)
    msgMODC.saveCurrentContext(msgMODC.MOC!)
    let indexPath = IndexPath(row: 0, section: 1)
    tableView.insertRows(at: [indexPath], with: .automatic)
    tableView.reloadData()
    dvc!.configureView()
  }
}
