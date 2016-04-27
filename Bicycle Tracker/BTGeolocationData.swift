//
//  BTGeolocationData.swift
//  Bicycle Tracker
//
//  Created by Konstantin Kolontay on 2/9/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation
import CoreLocation


// geolocation 

struct BTGeolocationData {
    var latitude: Double?
    var longitude: Double?
    var altitude: Double?
    var speed: Double?
    var timeStamp: NSDate?
    var floor: Int?
    var distanceFromLocation: Double?
    var listPOI = [BTPoiItem]()
    
}