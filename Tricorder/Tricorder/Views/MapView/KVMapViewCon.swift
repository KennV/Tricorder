/**
GUI - 15

In the current map and camera view I have what I guess are "business rules" and logic (for toggling GUI states) interleaved with code for rendering the GUI. ANd it is not piecemeal/busy work to fix. this actually reduces the technical debt in this module
 
 OK the simplest way to run setup is from a button
 
*/
protocol MapKhanDelegate {
  func didChangePerson(_ entity: KVPerson)
  func willAddPerson(_ deli: Any?)
  func willMakeMessageFromPerson(_ person: KVPerson?)
  func willMakeNewPlaceHere(_ deli: Any?)
  func willAddNewEvent( _ deli: Any?)
  //
  func willRunSetupFrom(delegate: Any?)
}

import MapKit
import UIKit

class KVMapViewCon: UIViewController, MKMapViewDelegate
{
  /**

  */
  @IBOutlet weak var setupButton: UIButton! //Tag 10
  @IBOutlet weak var personButton: UIButton! //Tag 11
  @IBOutlet weak var eventButton: UIButton! //Tag 12
  /**

   */
  var delegate: MapKhanDelegate?
  var pdc = KVPersonDataController()
  var plc = KVPlaceDataController()
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet var mapView: MKMapView!

  let regionSmall = 1000
  let regionMedium = 3000
  var currentPerson: KVPerson?
    {
    didSet {
      // Update the view.
      //configureView()
    }
  }
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupGUIForApplicationState()
    setupButtonsForApplicationState()
    setupMapView()
    configureView()
    
  }
  
  func configureView() {
    switch (UserDefaults.standard.appHasRunSetup()) {
    case true:
      if let p = currentPerson {
        if let _imgVue = imageView {
          let i = pdc.resizeImage(image: (p.graphics?.photoActual)!, newWidth: _imgVue.bounds.height)
          _imgVue.image = i
        }
        
        renderNotationPins()
        let objLocation = CLLocation(latitude: currentPerson?.location?.latitude as! Double, longitude: currentPerson?.location?.longitude as! Double)
        let region = MKCoordinateRegionMakeWithDistance(objLocation.coordinate, 500, 500)
        mapView.setNeedsDisplay()
        mapView.setRegion(region, animated: true)
      }
    case false:
      print("\n ### NEED TO RUN _SETUP_### \n");
      // Actually it just makes more sense to link it from code
      // BUT
    }
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setupMapView()
  {
    
    let camera = MKMapCamera()
    mapView.delegate = self
    /**
     Switch on Map type
    */
    mapView.mapType = .hybridFlyover // .Hybrid - Has Scale; .Standard Has all Custom camera No Scale Bar
    switch mapView.mapType {
    case .hybrid:
      mapView.showsScale = false
      mapView.showsUserLocation = true
      mapView.showsPointsOfInterest = true
      mapView.showsCompass = false
      //
      camera.centerCoordinate = mapView.centerCoordinate
      camera.pitch = 70
      camera.altitude = 400
      camera.heading = 0
    case .hybridFlyover:
      mapView.showsScale = false
      mapView.showsUserLocation = true
      mapView.showsPointsOfInterest = true
      mapView.showsCompass = false
      //
      camera.centerCoordinate = mapView.centerCoordinate
      camera.pitch = 70
      camera.altitude = 400
      camera.heading = 0
    case .standard:
      mapView.showsScale = false
      mapView.showsUserLocation = true
      mapView.showsPointsOfInterest = true
      mapView.showsCompass = false
      //
      camera.centerCoordinate = mapView.centerCoordinate
      camera.pitch = 70
      camera.altitude = 400
      camera.heading = 0
    case .satellite:
      //
      mapView.showsScale = false
      mapView.showsUserLocation = true
      mapView.showsPointsOfInterest = true
      mapView.showsCompass = false
      //
      camera.centerCoordinate = mapView.centerCoordinate
      camera.pitch = 70
      camera.altitude = 400
      camera.heading = 0
    default:
      
      mapView.showsScale = false
      mapView.showsUserLocation = true
      mapView.showsPointsOfInterest = true
      mapView.showsCompass = false
      
      
      camera.centerCoordinate = mapView.centerCoordinate
      camera.pitch = 70
      camera.altitude = 400
      camera.heading = 0
    }
    
    mapView.camera = camera
    
  }
  
  func renderNotationPins() {
    let AllDAT = TricorderDataController()
    AllDAT.MOC = pdc.MOC
    for object in (AllDAT.getAllEntities()) {
      let pin = KVPinItem()
      pin.pinColor = UIColor()
      pin.coordinate = CLLocationCoordinate2DMake(object.location?.latitude as! Double, object.location?.longitude as! Double)
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
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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


