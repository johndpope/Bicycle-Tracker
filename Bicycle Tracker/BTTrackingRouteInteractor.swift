//
//  BTTrackingRouteInteractor.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/25/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation
import MapKit

protocol BTTrackingRouteInteractorOutput: class {
    
    func fetchTrack(item: BTTrackItem)
    
    func fetchCurrentData(currentData: BTFetchDataPresenter, course: Double)
    
    // set region for map view
    func setStartCoordinate(location: CLLocation, course: Double)
    
    // alert signal of poor connection with satelites
    func fetchingAlertPoorSignal(alert: Bool)
}

protocol  BTTrackingRouteInteractorInput {
    func startStopAction(actionName: String)
}

class BTTrackingRouteInteractor: NSObject {
   private weak var presenter: BTTrackingRouteInteractorOutput?
    private var itemTrack: BTTrackItem
    private var locationManagerItem: BTLocationManagerInput?
    private var startTime: NSDate?
    private var trackDistance = 0.0
    private var userTrack: BTUserTrack?
    private var locationPoints: [CLLocation]?
    private var dataPresenter: BTFetchDataPresenter?
    private var checkTreckingPoint: BTCheckTrakingLocation?
    var locationManager: BTLocationManagerInput {
        get {
            return locationManagerItem!
        }
        set {
            locationManagerItem = newValue
        }
    }
    
    init(item: BTTrackItem) {
        itemTrack = item
        super.init()
        locationPoints = [CLLocation]()
         locationManager = BTLocationManager.sharedInstances
        checkTreckingPoint = BTCheckTrakingLocation(locations: itemTrack.listLocations)
        locationManager.startLocation()
       
    }
    
    func setIteractorOutputProtocol(item: BTTrackingRouteInteractorOutput) {
        presenter = item
        presenter?.fetchTrack(itemTrack)
       
    }
}

extension BTTrackingRouteInteractor: BTTrackingRouteInteractorInput {
    func startStopAction(actionName: String) {
        switch actionName  {
        case "Stop":
            locationManager.startLocation()
           userTrack = BTUserTrack()
           locationPoints = [CLLocation]()
            startTime = NSDate()
            trackDistance = 0.0
            checkTreckingPoint = BTCheckTrakingLocation(locations: itemTrack.listLocations)
        case "Start":
            userTrack?.trackId = itemTrack.usersTracks?.count
            userTrack?.durationTracking = abs((startTime?.timeIntervalSinceNow)!)
            userTrack?.distanceTraveled = trackDistance
            itemTrack.usersTracks?.append(userTrack!)
            locationManager.startLocation()
            locationManager.stopLocation()
            saveNewUserTrack()
            checkTreckingPoint = nil 
        default:
            break
        }
        
    }
    func saveNewUserTrack() {
        let parser = BTXMLParser(nameFile: nil)
        let documentWriter = BTXMLDocumentWriter(nameFile: nil)
        let itemsTrack = parser.parserDocument()
        var newItemsTrack = [BTTrackItem]()
        for item in itemsTrack {
            if item.trackId == userTrack?.trackId {
                newItemsTrack.append(itemTrack)
            } else {
                newItemsTrack.append(item)
            }
        }
        documentWriter.saveTracks(newItemsTrack)
    }
}
extension BTTrackingRouteInteractor: BTLocationManagerOutput {
    func fetchLocationsInteractor(locations:[CLLocation], alert: Bool) {
        dataPresenter = BTFetchDataPresenter()
        presenter?.fetchingAlertPoorSignal(alert)
        for location in locations {
            //stopTimer()
            if location.horizontalAccuracy < 20 {
                if locationPoints!.count > 0 {
                    trackDistance = trackDistance + location.distanceFromLocation(locationPoints!.last!)
                }
                let lastLocation = locationPoints?.last
                locationPoints?.append(location)
                var locationPoint = BTGeolocationDataUser()
                locationPoint.location.altitude = location.altitude
                locationPoint.location.speed = location.speed
                locationPoint.location.longitude = location.coordinate.longitude
                locationPoint.location.latitude = location.coordinate.latitude
                locationPoint.location.floor = location.floor?.level
                locationPoint.location.course = location.course
                if lastLocation != nil {
                    locationPoint.location.distanceFromLocation = location.distanceFromLocation(lastLocation!)
                }
                locationPoint.location.timeStamp = location.timestamp
                locationPoint.onWay = (checkTreckingPoint?.fetchCurrentLocation(locationPoint))!
                userTrack?.traveledPoints.append(locationPoint)
                dataPresenter?.сurrentSpeed = locationPoint.location.speed
                if startTime != nil {
                dataPresenter?.timeOfTracking = abs((startTime?.timeIntervalSinceNow)!)
                }
                dataPresenter?.travelPath = trackDistance
                dataPresenter?.newCoordinateLocation = locationPoints?.last?.coordinate
                dataPresenter?.lastCoordinateLocation = lastLocation?.coordinate
                
            }
        }
        if dataPresenter?.newCoordinateLocation == nil && dataPresenter?.lastCoordinateLocation == nil {
            presenter?.setStartCoordinate(locations.last!,course: 0.0)
        } else {
            if userTrack != nil {
             presenter?.fetchCurrentData(dataPresenter!, course: (userTrack?.traveledPoints.last?.location.course)!)
            }
        }
    }
}
