//
//  BTFetchDataPresenter.swift
//  Bicycle Tracker
//
//  Created by Konstantin Kolontay on 2/9/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

//import UIKit
import CoreLocation


//current data which is presenting to presenter for displaying on screen

struct BTFetchDataPresenter {
    var timeOfTracking: Double!
    var сurrentSpeed: Double!
    var travelPath: Double!
    var lastCoordinateLocation: CLLocationCoordinate2D?
    var newCoordinateLocation: CLLocationCoordinate2D?
}
