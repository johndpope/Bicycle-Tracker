//
//  BTDetailRouteUpcomingDisplayItem.swift
//  Bicycle Tracker
//
//  Created by imvimm on 2/22/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation
import MapKit

struct BTDetailRouteUpcomingDisplayItem {
   var name: String?
   var length: String?
   var duration: String?
   var screenShot: String?
   var heightDifference: String?
   var listOfPoints: [CLLocationCoordinate2D] = Array()
}