/**
Re-Stripped the Interface, no stacks

Mind you this is buggy AF.
 the map view is visible prior to setup:
  [do I make it invisible or opaque]
  Is it suitable to make a blackout view to cover it and remove this view if etc
 Actually I bet that is a Massive Performance Hit See Option Three
  Or the Other way around and have the map view on top
  OR A THIRD WAY to have the background Black and the only draw the map view if hasSetup == true
 
 the setup button does not do anything
 The buttons do not have correct placement, or arrtibutes
  [Working this first]
  look into attributed strings;
  and IBInscpectable instance variables
 
 the buttons do not do anything
  [I suppose that this is second]
 There is no Progress indicator

THE PRIME TVC Needs to also be a DataSource(Delegate)
 
It does what it (was) is designed to do, but that sucks.
 :: The Primary reason to get to a setup window is to create a Primary User for the app.
 :: When I add any NonPrimaryEntity it *Must* have a
 
 OKAY SO:
I AM adding a requirement to the app that it ALWAYS has a CLLocation
 Hell; it IS a MKMap
And it is the first itenm in bugfix 
*/
protocol MapEditorDelegate {
  func didChangePerson(_ entity: KVPerson)
  func willAddPerson(_ deli: Any?)
  func willMakeMessageFromPerson(_ person: KVPerson?)
  func willMakeNewPlaceHere(_ deli: Any?)
  func willAddNewEvent( _ deli: Any?)
}

import MapKit
import UIKit

class KVMapViewCon: UIViewController
{
  /**

  */
  @IBOutlet weak var setupButton: UIButton! //Tag 10
  @IBOutlet weak var personButton: UIButton! //Tag 11
  @IBOutlet weak var eventButton: UIButton! //Tag 12
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  /**

   */
  var delegate: MapEditorDelegate?
  var pdc = KVPersonDataController()
  var plc = KVPlaceDataController()
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet var mapView: MKMapView!
//  var location: CLLocation! //note this and adjust properly in map

  let regionSmall = 1000
  let regionMedium = 3000
  var currentPerson: KVPerson?
    {
    didSet {
      // Update the view.
      //        configureView()
    }
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupButtonsForApplicationState()
    setupMapView()
    configureView()
    
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setupMapView()
  {
    
    mapView.delegate = self
    
    mapView.mapType = .hybridFlyover // .Hybrid - Has Scale; .Standard Has all Custom camera No Scale Bar
    
    mapView.showsScale = true
    mapView.showsUserLocation = true
    mapView.showsPointsOfInterest = true
    mapView.showsCompass = false
    
    let camera = MKMapCamera()
    camera.centerCoordinate = mapView.centerCoordinate
    camera.pitch = 70
    camera.altitude = 400
    camera.heading = 0
    
    mapView.camera = camera
    
  }
  
  func loadPinData()
  {
    //    well that is a good way to get all of these
    let AllDAT = TricorderDataController()
    AllDAT.MOC = pdc.MOC
    for object in (AllDAT.getAllEntities()) //as! [KVEntity]
    {
      // all pins
      let loc = object.location
      let cd = CLLocationCoordinate2DMake(loc?.latitude as! Double, loc?.longitude as! Double)
      let pin = KVPinItem()
      pin.pinColor = UIColor()
      pin.coordinate = cd
      pin.title = object.qName
      pin.subtitle = object.hexID
      
      if (object.isMember(of: KVPerson.self)) {
        pin.pinColor = UIColor.red
      }
      if (object.isMember(of: KVPlace.self)) {
        pin.pinColor = UIColor.purple
      }
      if (object.isMember(of: KVEvent.self)) {
        pin.pinColor = UIColor.yellow
      }
      if (object.isMember(of: KVMessageMO.self)) {
        pin.pinColor = UIColor.orange
      }
      mapView.addAnnotation(pin)
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
  {
    //http://stackoverflow.com/questions/31069802/error-could-not-cast-value-of-type-nskvonotifying-mkuserlocation-to-park-view-a
    if (annotation is MKUserLocation) {
      return nil
    }
    
    let reuseID = "kingPin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)  as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      
      let myPinItem = annotation as! KVPinItem
      pinView?.pinTintColor = myPinItem.pinColor
      pinView?.canShowCallout = true
      pinView?.calloutOffset = CGPoint(x: -5, y: 5)
      pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
      pinView?.detailCalloutAccessoryView = UIImageView(image:UIImage(named: "odyssey32"))
    }
    else {
      pinView?.annotation = annotation
    }
    
    return pinView
    
  }
}
