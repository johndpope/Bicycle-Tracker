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
   @IBOutlet weak var routeNameLabel: UILabel!
   @IBOutlet weak var lengthLabel: UILabel!
   @IBOutlet weak var durationLabel: UILabel!
   
   // MARK: - Lifecycle
   override func awakeFromNib() {
      super.awakeFromNib()
      screenshotImageView.layer.cornerRadius = screenshotImageView.bounds.size.width / 2
      screenshotImageView.clipsToBounds = true
      separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
   }
   
   override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
}

// MARK: - BTRouteListItemViewProtocol
extension RouteCell: BTRouteListItemViewProtocol {
   func setName(name: String) {
      routeNameLabel.text = name
   }
   
   func setLength(length: String) {
      lengthLabel.text = length
   }
   
   func setDuration(duration: String) {
      durationLabel.text = duration
   }
   
   func setScreenshot(screenshot: UIImage) {
      screenshotImageView.image = screenshot
   }
}
