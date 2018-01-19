/**
  KVRatingView.swift
  Ares005

  Created by Kenn Villegas on 10/14/15.
  Copyright © 2015 K3nV. All rights reserved.
*/

import UIKit


class KVRatingView: UIView
{
  
  // MARK: Properties
  var rating = 0 {
    didSet {
      setNeedsLayout()
    }
  }
  var ratingButtons = [UIButton]()
  var spacing = 5
  var stars = 5
  
  // MARK: Initialization

  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    
    let filledStarImage = UIImage(named: "filledStar")
    let emptyStarImage = UIImage(named: "emptyStar")
    
    for _ in 0..<5 {
      let button = UIButton()
      
      button.setImage(emptyStarImage, for: .normal)
      button.setImage(filledStarImage, for: .selected)
      button.setImage(filledStarImage, for: [.highlighted, .selected])
      
      button.adjustsImageWhenHighlighted = false
      // Fixes AGAIN!
      button.addTarget(self, action: #selector(self.ratingButtonTapped(_ :)), for: .touchDown)
      ratingButtons += [button]
      addSubview(button)
    }
  }
  override func layoutSubviews()
  {
    // Set the button's width and height to a square the size of the frame's height.
    let buttonSize = Int(frame.size.height)
    var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
    // Offset each button's origin by the length of the button plus spacing.
    for (index, button) in ratingButtons.enumerated() {
      buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
      button.frame = buttonFrame
    }
    updateButtonSelectionStates()
  }
  // MARK: Button Action
  func ratingButtonTapped(_ button: UIButton)
  {
    rating = ratingButtons.index(of: button)! + 1
    
    updateButtonSelectionStates()
  }
  func updateButtonSelectionStates()
  {
    for (index, button) in ratingButtons.enumerated() {
      // If the index of a button is less than the rating, that button should be selected.
      button.isSelected = index < rating
    }
  }
}
