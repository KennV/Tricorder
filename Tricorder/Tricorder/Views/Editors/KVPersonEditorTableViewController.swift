/*
 KVPersonEditorTableViewController.swift
 Ares005
 
 Created by Kenn Villegas on 10/22/15.
 Copyright © 2015 K3nV. All rights reserved.

I was having some issues with the TVCells, it was because I tried to dequue PhoneCell as 'phoneCell'  However I am becoming intrigued by the addition of a second TVSection
*/

import UIKit
enum PersonSections: Int {
  //This makes the TVCells setup more readable AND Less Error Prone
  case NameCell, AddressCell, PhoneCell, TextIDCell, HexIDCell, StatusCell
  static let allValues = [NameCell, AddressCell, PhoneCell, TextIDCell, HexIDCell, StatusCell]
}
//MARK: ATHENA
class KVPersonEditorTableViewController: UITableViewController {
  var currentPerson : KVPerson!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Person-Ed"
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 2 //
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int
  {
    var rowCount = 0
    if (section == 0) {
      rowCount = PersonSections.allValues.count
    }
    if (section == 1) {
      rowCount = 4
    }
    return rowCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    var cell : UITableViewCell!
    //        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    ///Please note that it is not procedurally necessary to test for the current Person but in the sake of true safety I am going to leave it there.
    if (indexPath.section == 0)
    {
        if let p = currentPerson
        {
        switch indexPath.row
          {

          case PersonSections.NameCell.rawValue:
            //I just threw an exception on GUI testing fix GUI then come HERE
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
            cell.textLabel?.text = p.firstName! + " " + p.lastName!
            
          case PersonSections.AddressCell.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
            cell.textLabel?.text = p.location?.address!
            cell.detailTextLabel?.text = (p.location?.state)! + " " + (p.location?.zipCode)!
          
          case PersonSections.PhoneCell.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath)
            cell.textLabel?.text = p.phoneNumber!
            cell.detailTextLabel?.text = "Cell Number:"
            
          case PersonSections.TextIDCell.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "textIDCell", for: indexPath)
            cell.textLabel?.text = p.textID!
            cell.detailTextLabel?.text = "Text ID:"
            
          case PersonSections.HexIDCell.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "hexIDCell", for: indexPath)
            cell.textLabel?.text = p.hexID
            
          case PersonSections.StatusCell.rawValue:
            //Data seems to need optional
            cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath)
            cell.textLabel?.text = (p.type!)  + " " + (p.incepDate?.description)!
          default:
            break
          }
      } //person
    } //section 01
    else if (indexPath.section == 1) //Vehicle?
    {
      if let v = (currentPerson.vehicle)// as! KVVehicle)
      {
        switch indexPath.row
        {
        case 0:
          cell = tableView.dequeueReusableCell(withIdentifier: "brandCell", for: indexPath)
          cell.textLabel?.text = v.make!
        case 1:
          cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath)
          cell.textLabel?.text = v.model
        case 2:
          cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
          cell.textLabel?.text = v.color //.stringValue
        case 3:
          cell = tableView.dequeueReusableCell(withIdentifier: "wheelsCell", for: indexPath)
          cell.textLabel?.text = v.numberOfWheels?.stringValue
        default:
          break
          
        }
      }
      
    }
    return cell
  }
  
}
