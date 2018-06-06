/**
KVCameraViewController.swift
Tricorder

Created by Kenn Villegas on 8/11/16.
Copyright © 2016 K3nV. All rights reserved.
ACTIVATE
*/

protocol PhotoKhanDelegate {

  func didChangeEntityGraphics(_ gfx: KVRootEntityGraphics)
//  optional
//  func willChangeGFX(_ entity: KVRootEntityGraphics)
}

import UIKit

class KVCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  
  var currentGFX: KVRootEntityGraphics?
  {
    didSet {
      configureView()
    }
  }
  
//  var currentPerson: KVPerson?
//  {
//    didSet {
//      // Update the view.
//      configureView()
//    }
//  }

  var delegate: PhotoKhanDelegate?

  @IBOutlet weak var bigView: UIImageView!
  @IBOutlet weak var ratingView: UIView!
  @IBOutlet weak var useLibraryButton: UIButton!
  @IBOutlet weak var useCameraButton: UIButton!
  
  let picker = UIImagePickerController()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    picker.delegate = self
    configureView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func configureView() {

    if let aVue = bigView
    {
      print(currentGFX!.photoFileName!)
      aVue.image = currentGFX!.photoActual
    }
  }

/*
   Pick a photo
  
   - parameter picker: my Picker
   - parameter info:  # HEY take a trip to the Deli 
 */
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    var  chosenImage = UIImage()
    chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

    currentGFX?.photoActual = chosenImage
//    currentPerson?.graphics?.photoActual = currentGFX?.photoActual
    self.delegate?.didChangeEntityGraphics(self.currentGFX!)
    self.configureView()
    
    dismiss(animated:true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  //
  @IBAction func takeLibPhoto(_ sender: UIBarButtonItem) {
    picker.allowsEditing = false
    picker.sourceType = .photoLibrary
    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    picker.modalPresentationStyle = .popover
    present(picker, animated: true, completion: nil)
    picker.popoverPresentationController?.barButtonItem = sender
  }

  @IBAction func takeCamPhoto(_ sender: UIButton) {
//  @IBAction func shootPhoto(_ sender: UIBarButtonItem) {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.allowsEditing = false
      picker.sourceType = UIImagePickerControllerSourceType.camera
      picker.cameraCaptureMode = .photo
      picker.modalPresentationStyle = .fullScreen
      present(picker,animated: true,completion: nil)
    } else {
      killNilCamera()
    }
  }

  func killNilCamera() {
    let alertVC = UIAlertController(
      title: "No Camera",
      message: "Sorry, this device has no camera",
      preferredStyle: .alert)
    let okAction = UIAlertAction(
      title: "OK",
      style:.default,
      handler: nil)
    alertVC.addAction(okAction)
    present(
      alertVC,
      animated: true,
      completion: nil)
  }
// Compliance is Complicity
// tell the deli to update the image I just got.
// didChangeGraphicsOn(_ entity: KVPerson)
// is it the same current person and if not then just use thisP.currentP -> thatP.thisP
  
}
