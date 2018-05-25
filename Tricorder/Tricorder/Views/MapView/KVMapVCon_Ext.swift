
import UIKit

extension KVMapViewCon: PhotoKhanDelegate {

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
  
  // NEW
  func setupButtonsForApplicationState() {
    if (UserDefaults.standard.appHasRunSetup() == false) {
      self.mapView.isHidden = true
      self.mapView.alpha = 00.00
      self.setupButton.isHidden = false
    } else {
      self.mapView.isHidden = false
      self.mapView.alpha = 01.00
      self.setupButton.isHidden = true
      self.personButton.isHidden = false
      self.eventButton.isHidden = false
    }
  }
  //
}
