//
//  RouteCell.swift
//  Bicycle Tracker
//
//  Created by Plumb on 2/26/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {
   
   @IBOutlet weak var screenshotImageView: UIImageView!
   @IBOutlet weak var cycleRouteIcon: UIImageView!
   @IBOutlet weak var routeNameLabel: UILabel!
   @IBOutlet weak var startAddressLabel: UILabel!
   @IBOutlet weak var finishAddressLabel: UILabel!
   @IBOutlet weak var middleAddressLabel: UILabel!
   @IBOutlet weak var lengthLabel: UILabel!
   @IBOutlet weak var durationLabel: UILabel!
   @IBOutlet weak var heightDifferenceLabel: UILabel!
   @IBOutlet weak var difficultyView: UIView!

   // MARK: - Lifecycle
   override func awakeFromNib() {
      super.awakeFromNib()
//      screenshotImageView.layer.cornerRadius = screenshotImageView.bounds.size.width / 2
//      screenshotImageView.clipsToBounds = true
      separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
   }
   
   override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
}

// MARK: - BTRouteListItemViewProtocol
extension RouteCell: BTRouteListItemViewProtocol {
   func setName(name: String) {
//      routeNameLabel.text = name
   }
   
   func setStartAddress(startAddress: String) {
      print("setStartAddress")
      print(startAddress)
      startAddressLabel.text = startAddress
   }
   
   func setFinishAddress(finishAddress: String) {
      print("setFinishAddress")
      print(finishAddress)
      finishAddressLabel.text = finishAddress
   }
   
   func setMiddleAddress(middleAddress: String) {
      print("setMiddleAddress")
      print(middleAddress)
      middleAddressLabel.text = middleAddress
   }
   
   func setLength(length: String) {
      lengthLabel.text = length
   }
   
   func setDuration(duration: String) {
      durationLabel.text = duration
   }
   
   func setHeightDifference(heightDifference: String) {
      print("setHeightDifference")
      print(heightDifference)
      heightDifferenceLabel.text = heightDifference
   }
   
   func setScreenshot(screenshot: UIImage) {
      screenshotImageView.image = screenshot
   }
   
   func setDifficulty(level: String) {
      switch level {
      case "easy":
         self.difficultyView.backgroundColor = Constants.greenCustomColor
         break
      case "medium":
         self.difficultyView.backgroundColor = Constants.orangeCustomColor
         break
      case "hard":
         self.difficultyView.backgroundColor = Constants.redCustomColor
         break
      default:
         self.difficultyView.backgroundColor = UIColor.clearColor()
         break
      }
   }
   
   func setCycleRoute(cycle: Bool) {
      if cycle {
         self.cycleRouteIcon.hidden = true
         self.middleAddressLabel.hidden = true
      } else {
         self.cycleRouteIcon.hidden = false
         self.middleAddressLabel.hidden = false
      }
   }
}
