
import UIKit

extension KVMapViewCon: PhotoEditorProtocol {

  //MARK: -  Protocol Conformance -

  func didChangeGraphicsOn(_ entity: KVRootEntityGraphics)
  {
    if currentPerson?.graphics != entity {
      currentPerson?.graphics = entity
    }
    configureView()
    // pass it to the other deli
    delegate?.didChangePerson(currentPerson!)
  }
  
  // MARK: Segues:
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if (segue.identifier == "showPersonVue")
    {
      let e = segue.destination as! KVPersonVueTVC
      
      e.currentPerson = currentPerson
    }
    else if (segue.identifier == "showPhotoEd")
    {
      /**
       BUGFIX: showPhotoEd became unlinked in the XIB
       with disasterous results. The Deli is not set and the GFX is nil
       _Obviously_ this is sub-optimal
      */
      let e = segue.destination as! KVCameraViewController
      e.delegate = self
      e.currentGFX = (currentPerson?.graphics)
    }
    else if (segue.identifier == "showCollection")
    {
      //      ADD seg-seqs
    }
  }
  
  // NEW
  func setupButtonsForApplicationState() {
    if (UserDefaults.standard.appHasRunSetup() == false) {

      self.mapView.isHidden = true
      self.mapView.alpha = 00.00
      self.setupButton.isHidden = false
      self.personButton.isHidden = true
      self.eventButton.isHidden = true
    } else {
      self.mapView.isHidden = false
      self.mapView.alpha = 01.00
      self.setupButton.isHidden = true
      self.personButton.isHidden = false
      self.eventButton.isHidden = false
    }
  }
    
  @IBAction func addPerson(sender: AnyObject)
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
  
  @IBAction func runSetup(_ sender: UIButton)
  {
    
  }
  
  @IBAction func addEvent(_ sender: UIButton)
  {
    
  }

}
