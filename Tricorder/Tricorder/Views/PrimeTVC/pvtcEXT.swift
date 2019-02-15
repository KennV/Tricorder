/**
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

extension KVPrimeTVCon: CLLocationManagerDelegate, KVMapActionsProtocol
{
  enum viewSegueName: String {
    case showEULA
    case showDetail
  }

  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    
    guard let identifier = segue.identifier, let identifierCase = KVPrimeTVCon.viewSegueName(rawValue: identifier) else {
      assertionFailure("Nopal")
      return
    }
    switch identifierCase {
    case .showEULA:
      print("App state for AppHasRunSetup = \(UserDefaults.standard.appHasRunSetup())")
      print("License")
      let eulaCon = (segue.destination as! UINavigationController).topViewController as! KDVEULAViewController
      eulaCon.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
      eulaCon.navigationItem.leftItemsSupplementBackButton = true
    case .showDetail:

      if let indexPath = tableView.indexPathForSelectedRow {
        let p = pdc.getAllEntities()[(indexPath as NSIndexPath).row]
        let mapC = (segue.destination as! UINavigationController).topViewController as! KVMapViewCon
        mapC.delegate = self
        mapC.currentPerson = p
        mapC.pdc = pdc
        mapC.plc = placesDC

//        mapC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//        mapC.navigationItem.leftItemsSupplementBackButton = true
//    default: //unused
      }

    }
  }
  
  // : :
  func setupViewDataLogic () {
    /** OK this is flawed.
     but the reasoning is sort of sound for now
     SEE Without it I have this really nice bug where I have the map view loading without an entity - with the Obvious effect that there is nobody to center the map on BUT
     WITH THE CRASHER BUG
     Of what happens if you try to edit the person or persons photo when person is nil, well that is again an obvious fix - but it is _still_ the wrong implementation.
     • First of all. I might not want getAll…[0]
     I probably do but let's assume that is not an absolute
     • Second if I do then I want it to be clear in the interface
     • The reason that I didn't really see it was in iPhone view, the detail is not visible until person is selected - but in the iPad it is some BS Location.
     •This is also a stop-gap fix: It is not as important how or what is selected, just as long as it is not nil
     */
    self.title = "Tri-Ed"
    dvc?.pdc = KVPersonDataController(self.pdc.MOC!)
    dvc?.currentPerson = dvc?.pdc.getAllEntities()[0]
    dvc?.title = (dvc?.pdc.getAllEntities()[0])!.firstName
    
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
  // TODO: Is this is AppDeli or a queue?
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
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
    pdc.saveContext() // This is to fix the photo not persisting in HW Bug
    pdc.saveCurrentContext(pdc.MOC!)
    tableView.reloadData()
  }
  
  func willAddPerson(_ deli: Any?) {
    /**
     NOW MOVE THIS TO THE CONTROLLER _NOT_ THE MAP VIEW!!!
     AAMOF it could even be in an superclass of person and or item
     */
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
  
  func willMakeNewPlaceHere(_ deli: Any?)
  {
    findLocation()
    insertNewPlace(sender: self)
  }
  
  func willAddNewEvent( _ deli: Any?)
  {
    findLocation()
    insertNewEvent(sender: self)
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
   IBOutlet insted
   */
  //IBAction insted
  @IBAction func insertNewPlace(sender: AnyObject)
  {
    let pl = placesDC.makePlaceWithLocation(placesDC.MOC!, loc: (locationManager?.location?.coordinate)!)
    placesDC.getAddressOfLocation(pl.location!)
    
    _ = placesDC.saveEntity(entity: pl)
    placesDC.saveCurrentContext(placesDC.MOC!)
    tableView.reloadData()
    foundLocation()
  }
  //IBAction insted
  @IBAction func insertNewEvent(sender: AnyObject)
  {
    _ = eventsDC.makeEvent(eventsDC.MOC!, loc: (locationManager?.location?.coordinate)!)

    _ = eventsDC.saveEntities()
    let indexPath = IndexPath(row: 0, section: 2)
    tableView.insertRows(at: [indexPath], with: .automatic)
    eventsDC.saveCurrentContext(eventsDC.MOC!)
    dvc!.configureView()
  }
  //IBAction insted
  @IBAction func insertNewMsgMO(sender: AnyObject)
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
  func mkPersonForDelegate(deli: Any?) {
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
  
/**
   OKAY, I have a question;
   What do I really create when I @addPerson:?
   Does that Person Have a real list of tasks or items?
   The Active Code is 
   This is best answered in TEST and popped back over here.
   
   
*/
}
