//
//  BTDetailRouteViewPresenter.swift
//  Bicycle Tracker
//
//  Created by Plumb on 2/21/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import MapKit

class BTDetailRouteViewPresenter: NSObject {
    var view: BTDetailRouteViewInput?
    var interactor: BTDetailRouteViewInteractorInput?
    var trackId: Int?
    private var trackItem: BTTrackItem?
    var displayData: BTDetailRouteUpcomingDisplayItem?
}

// MARK: - BTDetailRouteViewOutput
extension BTDetailRouteViewPresenter: BTDetailRouteViewOutput {
    func setupView() {
        //  query route with current id
        interactor!.queryDetailTrack(trackId!)
    }
    
    func didTriggerShareButtonTapped() {
        // prepare content for sharing
        var itemsToShare: Array = [AnyObject]()
        
        let routeName: String = String("Route: \((displayData?.name)!)")
        let routeLength: String = String("\((displayData?.length)!) miles")
        let routeDuration: String = String("\((displayData?.duration)!) min")
        
        itemsToShare.append(routeName)
        itemsToShare.append(routeLength)
        itemsToShare.append(routeDuration)
        
        let routeScreenShot: String = String("\((displayData?.screenShot)!)")
        if !routeScreenShot.isEmpty {
            let path = String.screenshotDataFilePath(routeScreenShot)
            let screenShotImage: UIImage = UIImage(contentsOfFile: path)!
            itemsToShare.append(screenShotImage)
        } else {
            itemsToShare.append(Constants.noContentImage!)
        }
        
        view?.showShareActivityViewWithActivityItems(itemsToShare)
    }
}

// MARK: - BTDetailRouteViewInteractorOutput
extension BTDetailRouteViewPresenter: BTDetailRouteViewInteractorOutput {
    func getDetailTrack(item: BTTrackItem) {
        // convert data from interactor into appropriate format
        var displayItem = BTDetailRouteUpcomingDisplayItem()
        
        trackItem = item
        
        if let optionalValue = item.presenterData?.nameTracking {
            displayItem.name = optionalValue
        }
        if let optionalValue = item.length {
            displayItem.length = String.formattedDistance(optionalValue)
        }
        if let optionalValue = item.duration {
            displayItem.duration = String.formattedDuration(optionalValue)
        }
        if let optionalValue = item.nameFileScreenShotRoute {
            displayItem.screenShot = optionalValue
        }
        
        var locationPointsArray = [CLLocationCoordinate2D]()
        
        if item.listLocations.count > 0 {
            for location in item.listLocations {
                if ((location.latitude != nil) || location.longitude != nil) {
                    let point = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
                    locationPointsArray.append(point)
                }
            }
            displayItem.listOfPoints = locationPointsArray
        }
        if item.heightDifference != nil {
        displayItem.heightDifference = String(item.heightDifference!)
        
        displayData = displayItem
        view?.setupDetailRouteViewWithRoute(displayItem)
        }
    }
    func startTracking() {
        weak var _ = BTTrackingRoutefPresenter(item: trackItem!, view: self.view as! BTDetailRouteViewController)
            }
}