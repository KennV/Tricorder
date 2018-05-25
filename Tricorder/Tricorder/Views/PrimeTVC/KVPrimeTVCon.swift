/**
  KVPrimeTVCon.swift
  Ares3

  Created by Kenn Villegas on 9/19/16.
  Copyright © 2016 K3nV. All rights reserved.

** Attrib: http://nshipster.com/core-location-in-ios-8/

I believe that i can customise the cells to have a custom scroll view
I should make a cutsom class for that
*/

import CoreLocation
import UIKit

class KVPrimeTVCon: UITableViewController, MapKhanDelegate
{

  var dvc: KVMapViewCon? = nil
  var pdc = KVPersonDataController()
  var eventsDC = KVEventDataController()
  var placesDC = KVPlaceDataController()
  var msgMODC = KVMessageDataController()
  var locationManager : CLLocationManager? = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCLManager() // I could set this in the AppDeli but I am not sure if that is best.
    UserDefaults.standard.setAppHasRunSetup(val: true)
//    if (!(pdc.getAllEntities().isEmpty)) {
//     UserDefaults.standard.setAppHasRunSetup(val: true)
//    }
//
    navigationItem.leftBarButtonItem = editButtonItem
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(KVPrimeTVCon.insertNewObject(sender :)))
    
    navigationItem.rightBarButtonItem = addButton
    if let split = splitViewController {
        let controllers = split.viewControllers
        dvc = (controllers[controllers.count-1] as! UINavigationController).topViewController as? KVMapViewCon
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
    print("App state for AppHasRunSetup = \(UserDefaults.standard.appHasRunSetup())")
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // I can really Easily crush the arrays no?
    // OR are they lightweight
  }

  func insertNewObject(sender: AnyObject)
  {
    insertNewPerson(sender: self)
  }
  // MARK: - Table View Setup
  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 4 //
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    var rowCount = 0
    
    switch section {
    case 0:
      rowCount = pdc.getAllEntities().count
    case 1:
      rowCount = msgMODC.getAllEntities().count
    case 2:
      rowCount = eventsDC.getAllEntities().count
    case 3:
      rowCount = placesDC.getAllEntities().count
    default:
      rowCount = 0
    }
    
    return rowCount
  }
  // MARK: Pulling section buttons for now
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    //Plus right add the
    //While Height 0 Override down thurr
    let headerVue = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.size.width, height: 0)))
    let sectionLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: view.frame.size.width, height: 21)))
    let sectionButton = UIButton(frame: CGRect(x: 80, y: 10, width: 88, height: 21))
    sectionButton.backgroundColor = UIColor.clear
        sectionButton.titleLabel?.textColor = UIColor.black
//        sectionButton.font = UIFont.systemFont(ofSize: 16)
    sectionLabel.backgroundColor = UIColor.clear
    sectionLabel.textColor = UIColor.yellow
    sectionLabel.font = UIFont.boldSystemFont(ofSize: 17)
    
    switch section
    {
    case 0:
      sectionLabel.text = NSLocalizedString("Person:", comment: "")
      sectionButton.setTitle("Person --", for: .normal)
    case 1:
      sectionLabel.text = NSLocalizedString("Message:", comment: "")
      sectionButton.setTitle("Msgs ++", for: .normal)
      sectionButton.addTarget(self, action: #selector(insertNewMsgMO(sender:)), for: .touchDown)
    case 2:
      sectionLabel.text = NSLocalizedString("Events:", comment: "")
      sectionButton.setTitle("Events ++", for: .normal)
      sectionButton.addTarget(self, action: #selector(insertNewEvent(sender:)), for: .touchDown)
    case 3:
      sectionLabel.text = NSLocalizedString("Places:", comment: "")
      sectionButton.addTarget(self, action: #selector(insertNewPlace(sender:)), for: .touchDown)
      sectionButton.setTitle("Places ++", for: .normal)
      
    default:
      return nil
    }
    headerVue.addSubview(sectionButton) //
    headerVue.addSubview(sectionLabel)
    return headerVue

  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return (40)
  }
  // Draw the cells
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    
    if (indexPath.section == 0)
    {
    let c = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! KVBasicCustomCell
      let p = pdc.getAllEntities()[(indexPath as NSIndexPath).row]
      c.nameLabel!.text = p.qName
// Use the 'real' resize ƒn
      c.photoImageView.image = pdc.resizeImage(image: (p.graphics?.photoActual)!, newWidth: 64)
      return c
    }
    if (indexPath.section == 1)
    {
      let f = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! KVBasicCustomCell
      let item = msgMODC.getAllEntities()[(indexPath as NSIndexPath).row]
      f.nameLabel!.text = item.qName
      return f
    }
    if (indexPath.section == 2)
    {
      let d = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! KVBasicCustomCell
      let item = eventsDC.getAllEntities()[(indexPath as NSIndexPath).row]
      d.nameLabel!.text = item.qName
      return d
    }
    if (indexPath.section == 3)
    {
      let e = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath) as! KVBasicCustomCell
      let item = placesDC.getAllEntities()[(indexPath as NSIndexPath).row]
      e.nameLabel!.text = item.qName
      return e
    }
    /*
    return cell c,d,e,f or return an empty one
    */
    return (UITableViewCell())//cell!
  }
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
  {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
  {
    //Don't delete from the array from the controller
    if editingStyle == .delete {

      switch indexPath.section
      {
      case 0:
        pdc.deleteEntityInContext(pdc.MOC!, entity: pdc.getAllEntities()[(indexPath as NSIndexPath).row])
        tableView.deleteRows(at: [indexPath], with: .fade)
        pdc.saveCurrentContext(pdc.MOC!)
      case 1:
        msgMODC.deleteEntityInContext(pdc.MOC!, entity: msgMODC.getAllEntities()[(indexPath as NSIndexPath).row])
        tableView.deleteRows(at: [indexPath], with: .fade)
        msgMODC.saveCurrentContext(msgMODC.MOC!)
      case 2:
        eventsDC.deleteEntityInContext(pdc.MOC!, entity: eventsDC.getAllEntities()[(indexPath as NSIndexPath).row])
        tableView.deleteRows(at: [indexPath], with: .fade)
        eventsDC.saveCurrentContext(eventsDC.MOC!)
      case 3:
        placesDC.deleteEntityInContext(pdc.MOC!, entity: placesDC.getAllEntities()[(indexPath as NSIndexPath).row])
        tableView.deleteRows(at: [indexPath], with: .fade)
        placesDC.saveCurrentContext(placesDC.MOC!)
      default:
        break
      }
      tableView.reloadData()
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
  
  

}

