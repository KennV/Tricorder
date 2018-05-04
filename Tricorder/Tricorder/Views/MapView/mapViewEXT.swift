import MapKit
import UIKit

extension KVMapViewCon: PhotoEditorDelegate, MKMapViewDelegate
{
	
  enum mapSegueName: String {
    case showEula
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
  
/**
   STRONG SIDENOTE TO SELF
   Conformance is Compliance, it is complicity
   
   The next series of bugfixes is to implement features in the system I have fairly strong belief in the code as it is implementd but, as it is also unfinished I have integration problems. But these are not so bad because I unit tests. And the db side of the app is strongly tested
*/
  
 //MARK: -  Protocol Conformance -
  func didChangeGraphicsOn(_ entity: KVRootEntityGraphics)
  {
    // PhotoEditorDelegate
    if currentPerson?.graphics != entity {
      currentPerson?.graphics = entity
    }
    configureView()
    // pass it to the other deli
    delegate?.didChangePerson(currentPerson!)
  }

  //MKMapViewDelegate
  @IBAction func addPerson(_ sender: AnyObject)
  {
    delegate?.willAddPerson(delegate)
    currentPerson = pdc.getAllEntities().first
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
  
  func configureView()
  {
    if (UserDefaults.standard.appHasRunSetup()) {
      
    }
    
      loadPinData()
      mapView.setNeedsDisplay()
      let objLocation = CLLocation(latitude: currentPerson?.location?.latitude as! Double, longitude: currentPerson?.location?.longitude as! Double)
      let region = MKCoordinateRegionMakeWithDistance(objLocation.coordinate, 500, 500)
      mapView.setRegion(region, animated: true)
    
  }
  
  func personAndViewSetup() {
    if let p = currentPerson {
      //      if let label = personTitleLabel {
      //        label.text = p.qName
      //      }
      //      if let _pButton = editPersonButton {
      //        _pButton.setTitle(("Edit " + p.firstName! + ":"), for: UIControlState.normal)
      //      }
      // }
      if let _imgVue = imageView {
        //        _imgVue.image = (p.graphics?.photoActual)// as! UIImage)
        let i = pdc.resizeImage(image: (p.graphics?.photoActual)!, newWidth: _imgVue.bounds.height)
        _imgVue.image = i
      }
    }
  }
  
  // NEW
    func setupButtonsForApplicationState() {
      if (UserDefaults.standard.appHasRunSetup() == false) {
        self.mapView.isHidden = true
        self.mapView.alpha = 00.00
        self.setupButton.isHidden = false
        
      } else {
        self.mapView.isHidden = false
        self.setupButton.isHidden = true
      }
      self.activityIndicator.isHidden = true
    }

}



