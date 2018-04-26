/*
Re-Stripped the Interface, no stacks
*/
protocol MapKhanDelegate {
  func didChangePerson(_ entity: KVPerson)
  func willAddPerson(_ deli: Any?)
  func willMakeMessageFromPerson(_ person: KVPerson?)
  func willMakeNewPlaceHere(_ deli: Any?)
  func willAddNewEvent( _ deli: Any?)
}

import MapKit
import UIKit

class KVMapViewCon: UIViewController, PhotoKhanDelegate, MKMapViewDelegate
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
  
//  var idc = KVItemsDataController()
//  var peoplePins = [KVPinItem]()
//  var placePins = [KVPinItem]()
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet var mapView: MKMapView!
//  @IBOutlet weak var personTitleLabel: UILabel!
//  @IBOutlet weak var editPersonButton: UIButton!

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
    setupMapView()
    configureView()
    
  }
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  // MARK: Segues:
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if (segue.identifier == "showPersonEd")
    {
      let e = segue.destination as! KVPersonEditorTableViewController
      e.currentPerson = currentPerson
    }
    else if (segue.identifier == "showPhotoEd")
    {
      let e = segue.destination as! KVCameraViewController
      e.delegate = self
      e.currentGFX = (currentPerson?.graphics)
    }
    else if (segue.identifier == "showCollection")
    {
      //      ADD seg-seqs
    }
    
  }
  func configureView()
  {
    if (UserDefaults.standard.appHasRunSetup()) {
      
    }
    if let p = currentPerson {
//      if let label = personTitleLabel {
//        label.text = p.qName
//      }
//      if let _pButton = editPersonButton {
//        _pButton.setTitle(("Edit " + p.firstName! + ":"), for: UIControlState.normal)
//      }
      if let _imgVue = imageView {
//        _imgVue.image = (p.graphics?.photoActual)// as! UIImage)
        let i = pdc.resizeImage(image: (p.graphics?.photoActual)!, newWidth: _imgVue.bounds.height)
        _imgVue.image = i
      }
      
      loadPinData()
      mapView.setNeedsDisplay()
      let objLocation = CLLocation(latitude: currentPerson?.location?.latitude as! Double, longitude: currentPerson?.location?.longitude as! Double)
      let region = MKCoordinateRegionMakeWithDistance(objLocation.coordinate, 500, 500)
      mapView.setRegion(region, animated: true)
    }
  }

  // NEW
  func setupButtonsForState() {
    if (!(UserDefaults.standard.appHasRunSetup())) {
      self.mapView.isHidden = true
      self.setupButton.isHidden = false
    }
    self.mapView.isHidden = false
    self.setupButton.isHidden = true
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
  // This used to be renderPeople replaces
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
  //
  // MARK: Protocol Conformance
  //
  func didChangeGraphicsOn(_ entity: KVRootEntityGraphics)
  {
    if currentPerson?.graphics != entity {
      currentPerson?.graphics = entity
    }
    configureView()
    // pass it to the other deli
    delegate?.didChangePerson(currentPerson!)
  }
  // Protocol Usage
  @IBAction func addPerson(_ sender: AnyObject)
  {
    delegate?.willAddPerson(delegate)
    currentPerson = pdc.getAllEntities()[0]
    configureView()
  }
  
  @IBAction func addMessage()
  {
    /**
    OK I had to clean this up in Both places
    */
   delegate?.willMakeMessageFromPerson(currentPerson!) //It needs to reload table data
  }
  @IBAction func AddPlace()
  {
    delegate?.willMakeNewPlaceHere(delegate)
    configureView()
  }
  @IBAction func addEvent()
  {
    delegate?.willAddNewEvent(self)
  }

}


