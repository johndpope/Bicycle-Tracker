//
//  BTGetDataFromPresenterRequest.swift
//  Bicycle Tracker
//
//  Created by Konstantin Kolontay on 2/9/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation
import CoreLocation


// it's data which we recieved from presenter for search track. Searching will be with name of city or geolocation coordinates which get from click on the map or have from GPS on the IPhon or IPad

struct BTGetDataFromPresenterRequest {
    var namePlace: String?
    var location: CLLocation?
    var nameTrack: String?
    var dateTracking: NSDate?
    
}