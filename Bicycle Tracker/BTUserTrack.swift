//
//  BTUserTrack.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/28/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

struct BTUserTrack {
    var trackId: Int?
    var durationTracking: Double?
    var distanceTraveled: Double?
    
    var traveledPoints = [BTGeolocationDataUser]()
}

struct BTGeolocationDataUser {
    var onWay: Bool = false
    var location: BTGeolocationData = BTGeolocationData()
}