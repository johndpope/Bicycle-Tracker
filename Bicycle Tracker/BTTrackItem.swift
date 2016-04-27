//
//  BTTrackItem.swift
//  Bicycle Tracker
//
//  Created by Konstantin Kolontay on 2/9/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

// it's data which saving when cyclist is riding

struct BTTrackItem {
    var trackId: Int?
    var presenterData: BTGetDataFromPresenter?
    var listLocations = [BTGeolocationData]()
    var length: Double?
    var duration: Double?
    var heightDifference: Double?
    var startingLocation: String?
    var finishingLocation: String?
    var startingTime: NSDate?
    var finishingTime: NSDate?
    var nameFileScreenShotRoute: String?
    
}