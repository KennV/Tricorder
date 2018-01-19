/**
	KVPersonTableViewCell.swift
	Ares005

	Created by Kenn Villegas on 10/14/15.
	Copyright © 2015 K3nV. All rights reserved.
*/


import UIKit

class KVBasicCustomCell: UITableViewCell
{
  // MARK: Properties
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var photoImageView: UIImageView!
  //need a slider and a label
  //  @IBOutlet weak var tinyLabel: UILabel!
  @IBOutlet weak var ratingControl: UIView! //KVRatingView!
  override func awakeFromNib()
  {
    super.awakeFromNib()
    // Initialization code
  }
  override func setSelected(_ selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
