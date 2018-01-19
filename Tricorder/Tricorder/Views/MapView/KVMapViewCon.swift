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

 
KVMapViewCon.swift
Ares3

Created by Kenn Villegas on 9/19/16.
Copyright © 2016 K3nV. All rights reserved.

*/
/*
Ok I ripped out a lot of GUI that just sucked and I have added four buttons in two stacks. to be able to make a Place, or Event. on the map.
FIXED -sort-of- GeoCoding
Well I think it works now I have not ~~
Rather lets go in a different direction. To make it Person centric, not people instead of pulling up a map of 29 people
why not <= 06?
 
Also with the app chugging if I have a bunch of data in it. It does not seem to be pulling a lot of mem, but it could clling some utility funtion too often
Profiler Time
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
  var delegate: MapKhanDelegate?
  var pdc = KVPersonDataController()
  var plc = KVPlaceDataController()
  
//  var idc = KVItemsDataController()
//  var peoplePins = [KVPinItem]()
//  var placePins = [KVPinItem]()
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet weak var personTitleLabel: UILabel!
  @IBOutlet weak var editPersonButton: UIButton!

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
    
    if let p = currentPerson {
      if let label = personTitleLabel {
        label.text = p.qName
      }
      if let _pButton = editPersonButton {
        _pButton.setTitle(("Edit " + p.firstName! + ":"), for: UIControlState.normal)
      }
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
  /*
  @IBOutlet var mapView: MKMapView! // Does not fall out of scope
  @IBOutlet weak var mapView: MKMapView! // falls out
  let mapView = MKMapView() // is not linked
  */
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


