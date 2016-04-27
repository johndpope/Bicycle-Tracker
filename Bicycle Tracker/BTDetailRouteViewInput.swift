//
//  BTDetailRouteViewInput.swift
//  Bicycle Tracker
//
//  Created by imvimm on 2/19/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import MapKit

protocol BTDetailRouteViewInput {
   func setupDetailRouteViewWithRoute(route: BTDetailRouteUpcomingDisplayItem)
   func showShareActivityViewWithActivityItems(activityItems: [AnyObject]) 
}