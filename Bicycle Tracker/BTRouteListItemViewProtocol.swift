//
//  BTRouteListItemViewProtocol.swift
//  Bicycle Tracker
//
//  Created by Plumb on 2/27/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit

protocol BTRouteListItemViewProtocol {
   func setName(name: String)
   func setStartAddress(startAddress: String)
   func setFinishAddress(finishAddress: String)
   func setMiddleAddress(middleAddress: String)
   func setLength(length: String)
   func setDuration(duration: String)
   func setHeightDifference(heightDifference: String)
   func setScreenshot(screenshot: UIImage)
   func setDifficulty(level: String)
   func setCycleRoute(cycle: Bool)
}
