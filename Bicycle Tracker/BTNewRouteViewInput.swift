//
//  BTNewRouteViewInput.swift
//  Bicycle Tracker
//
//  Created by imvimm on 2/17/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import MapKit

protocol BTNewRouteViewInput {
   func setSpeedText(text: NSString)
   func setTimeText(text: NSString)
   func setDistanceText(text: NSString)
   func setCurrentCoordinate(currentCoordinate: CLLocationCoordinate2D)
   func makePolynileWithCoordinates(lastPosition: CLLocationCoordinate2D, currentPosition: CLLocationCoordinate2D)
   func setRegionForStartPoin(region: MKCoordinateRegion)
   func fetchingAlertPoorSatelitsSignal(signal: Bool)
}
