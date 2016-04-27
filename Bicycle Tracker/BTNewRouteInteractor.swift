//
//  BTNewRouteInteractor.swift
//  Bicycle Tracker
//
//  Created by Konstantin Kolontay on 2/8/16.
//  Copyright © 2016 imvimm. All rights reserved.
//


import UIKit
import CoreLocation
import QuartzCore
import MapKit

protocol BTNewRouteInteractorOutput: class {
    
    //get data for map and current value
    func didUpdateDataToPresenter(fetchDataDidUpdata: BTFetchDataPresenter)
    
    // get current data to presenter
    func fetchItemForDetailListController(idItemTrack: Int)
    
    // set region for map view
    func setRegionForStart(region: MKCoordinateRegion)
    
    // alert signal of poor connection with satelites
    func fetchingAlertPoorSignal(alert: Bool)
}

protocol BTNewRouteInteractorInput {
    
    //starting or stoping of tracking
    func startStopTracking(actionName: String, dataToStartTracking: BTGetDataFromPresenter?)
    
    //add POI
    func addPOIItem(item: BTPoiItem)
}

class BTNewRouteInteractor: NSObject {
    private var totalDistanceCycling = 0.0
    private var totalTimeCycling = 0.0
    private var startCycling: NSDate?
    private var itemData: BTXMLDocumentWriterModuleIncoming?
    private var itemTrack: BTTrackItem
    private weak var presenter: BTNewRouteInteractorOutput?
    private var dataPresenter: BTFetchDataPresenter
    private var nameOfPlace: String?
    private var lastSpeed: Double = 0
    private var locationManager: BTLocationManagerInput
    private var timer: NSTimer?
    lazy var locationPoints = [CLLocation]()
    
    override init() {
        itemTrack = BTTrackItem()
        locationManager = BTLocationManager.sharedInstances
        dataPresenter = BTFetchDataPresenter()
        super.init()
        lastSpeed = 0.0
        setFetchDataToItem(BTXMLDocumentWriter(nameFile: nil))
        locationManager.setPresenterProtocol(self)
        locationManager.startLocation()
    }
    
    //send signal about power of connection
    func getAlertPoorSignal (location: CLLocation) {
        if (location.horizontalAccuracy < BTHorizontalAccuracy.NoSignal.rawValue)
        {
            presenter?.fetchingAlertPoorSignal(true)
            // No Signal
        }
        else if (location.horizontalAccuracy > BTHorizontalAccuracy.PoorSingnal.rawValue)
        {
            presenter?.fetchingAlertPoorSignal(true)
            // Poor Signal
        }
        else if (location.horizontalAccuracy > BTHorizontalAccuracy.AverageSignal.rawValue)
        {
            presenter?.fetchingAlertPoorSignal(false)
            // Average Signal
        }
        else
        {
            presenter?.fetchingAlertPoorSignal(false)
            // Full Signal
        }
    }
    
    //start timer checked paused muving
    func startTimer() {
        if timer != nil {
            timer!.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("didPause"), userInfo: NSDate(), repeats: true)
    }
    
    //stop timer
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    // set speed 0 if not update location more than 4 second
    func didPause() {
        if abs(NSDate().timeIntervalSinceDate((locationPoints.last?.timestamp)!)) > 4 {
            dataPresenter.сurrentSpeed = 0.0
            presenter?.didUpdateDataToPresenter(dataPresenter)
        }
    }
    
    
    //fetch data to write in the file "Items.xml"
    func setFetchDataToItem(item: BTXMLDocumentWriterModuleIncoming)
    {
        itemData = item
    }
    
    // set interface to send data to presenter
    func setPresenterDelegate(presenter: BTNewRouteInteractorOutput) {
        self.presenter = presenter
    }
    
    //this function sets size of region depends of speed
    func setRegion(speed: Double, locationCenter: CLLocation) -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: locationCenter.coordinate.latitude, longitude: locationCenter.coordinate.longitude)
        var region: MKCoordinateRegion
        if speed < BTNewRoute.MinSpeedZooming.rawValue {
            region = MKCoordinateRegionMakeWithDistance(center, BTDistanceZoom.ZoomUptoMinSpeed.rawValue, BTDistanceZoom.ZoomUptoMinSpeed.rawValue)
            return region
        } else if speed < BTNewRoute.AverageSpeedZooming.rawValue {
            region = MKCoordinateRegionMakeWithDistance(center, BTDistanceZoom.ZoomUptoAverageSpeed.rawValue, BTDistanceZoom.ZoomUptoAverageSpeed.rawValue)
            return region
        } else if speed < BTNewRoute.MaxSpeedZooming.rawValue {
            region = MKCoordinateRegionMakeWithDistance(center, BTDistanceZoom.ZoomUptoMaxSpeed.rawValue, BTDistanceZoom.ZoomUptoMaxSpeed.rawValue)
            return region
        }
        region = MKCoordinateRegionMakeWithDistance(center, BTDistanceZoom.ZoomOverMaxSpeed.rawValue, BTDistanceZoom.ZoomOverMaxSpeed.rawValue)
        return region
    }
    
    //definition zooming depends of speed
    private func checkChengingCurrentSpeedForChangingZoom(location:CLLocation) {
        let  currentSpeed = location.speed
        // speed was less min naw speed is between min and average
        if lastSpeed  <  BTNewRoute.MinSpeedZooming.rawValue  && (currentSpeed > BTNewRoute.MinSpeedZooming.rawValue && currentSpeed < BTNewRoute.AverageSpeedZooming.rawValue) {
            lastSpeed = currentSpeed
            presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
        } else
            // speed was less min naw speed is between average and max
            if lastSpeed < BTNewRoute.MinSpeedZooming.rawValue && (currentSpeed > BTNewRoute.AverageSpeedZooming.rawValue && currentSpeed < BTNewRoute.MaxSpeedZooming.rawValue) {
                lastSpeed = currentSpeed
                presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
            } else
                // speed was less min naw speed is bigger max
                if lastSpeed < BTNewRoute.MinSpeedZooming.rawValue && currentSpeed > BTNewRoute.MaxSpeedZooming.rawValue   {
                    lastSpeed = currentSpeed
                    presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                } else
                    // speed was between min and average, than has stayed less min
                    if lastSpeed > BTNewRoute.MinSpeedZooming.rawValue && lastSpeed < BTNewRoute.AverageSpeedZooming.rawValue && currentSpeed < BTNewRoute.MinSpeedZooming.rawValue {
                        lastSpeed = currentSpeed
                        presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                    } else
                        // speed was between min and average, than has stayed between average and max
                        if lastSpeed > BTNewRoute.MinSpeedZooming.rawValue && lastSpeed < BTNewRoute.AverageSpeedZooming.rawValue && currentSpeed > BTNewRoute.AverageSpeedZooming.rawValue && currentSpeed < BTNewRoute.MaxSpeedZooming.rawValue {
                            lastSpeed = currentSpeed
                            presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                        } else
                            // speed was between min and average, than has stayed biger max
                            if lastSpeed > BTNewRoute.MinSpeedZooming.rawValue && lastSpeed < BTNewRoute.AverageSpeedZooming.rawValue && currentSpeed > BTNewRoute.MaxSpeedZooming.rawValue   {
                                lastSpeed = currentSpeed
                                presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                            } else
                                // speed was between average and max, than has stayed less min
                                if lastSpeed > BTNewRoute.AverageSpeedZooming.rawValue && lastSpeed < BTNewRoute.MaxSpeedZooming.rawValue && currentSpeed < BTNewRoute.MinSpeedZooming.rawValue {
                                    lastSpeed = currentSpeed
                                    presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                                } else
                                    // speed was between average and max, than has stayed between min and average
                                    if lastSpeed > BTNewRoute.AverageSpeedZooming.rawValue && lastSpeed < BTNewRoute.MaxSpeedZooming.rawValue && currentSpeed > BTNewRoute.MinSpeedZooming.rawValue && currentSpeed < BTNewRoute.AverageSpeedZooming.rawValue {
                                        lastSpeed = currentSpeed
                                        presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                                    }else
                                        // speed was between average and max, than has bigger max
                                        if lastSpeed > BTNewRoute.AverageSpeedZooming.rawValue && lastSpeed < BTNewRoute.MaxSpeedZooming.rawValue && currentSpeed > BTNewRoute.MaxSpeedZooming.rawValue   {
                                            lastSpeed = currentSpeed
                                            presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                                        } else
                                            // speed was bigger max, than has stayed less min
                                            if lastSpeed > BTNewRoute.MaxSpeedZooming.rawValue && currentSpeed < BTNewRoute.MinSpeedZooming.rawValue {
                                                lastSpeed = currentSpeed
                                                presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                                            } else
                                                // speed was bigger max, than has stayed between min and average
                                                if lastSpeed > BTNewRoute.MaxSpeedZooming.rawValue  && (currentSpeed > BTNewRoute.MinSpeedZooming.rawValue && currentSpeed < BTNewRoute.AverageSpeedZooming.rawValue) {
                                                    lastSpeed = currentSpeed
                                                    presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
                                                } else
                                                    // speed was bigger max, than has stayed between max and average
                                                    if lastSpeed > BTNewRoute.MaxSpeedZooming.rawValue && currentSpeed > BTNewRoute.AverageSpeedZooming.rawValue && currentSpeed < BTNewRoute.MaxSpeedZooming.rawValue   {
                                                        lastSpeed = currentSpeed
                                                        presenter?.setRegionForStart(setRegion(currentSpeed, locationCenter: location))
        }
    }
}

extension BTNewRouteInteractor: BTLocationManagerOutput {
    
    //update location data
    func  fetchLocationsInteractor(locations: [CLLocation]) {
        if startCycling != nil {
            totalTimeCycling = NSDate().timeIntervalSinceDate(startCycling!)
        } else {
            //send location when programm  is starting
            presenter?.setRegionForStart(setRegion(0, locationCenter: locations.last!))
            getAlertPoorSignal((locations.last)!)
            return
        }
        for location in locations {
            getAlertPoorSignal(location)
            stopTimer()
            //check if signal from satelite  enough
            if location.horizontalAccuracy < 20 {
                if self.locationPoints.count > 0 {
                    totalDistanceCycling += location.distanceFromLocation(locationPoints.last!)
                    checkChengingCurrentSpeedForChangingZoom(location)
                }
                let lastLocation = locationPoints.last
                if lastLocation != nil {
                    
                }
                dataPresenter.lastCoordinateLocation = locationPoints.last?.coordinate
                
                //save current data to temp variable
                locationPoints.append(location)
                dataPresenter.timeOfTracking = totalTimeCycling;
                dataPresenter.newCoordinateLocation = location.coordinate
                dataPresenter.travelPath = totalDistanceCycling
                dataPresenter.сurrentSpeed = location.speed
                var geolocationData = BTGeolocationData()
                geolocationData.latitude = location.coordinate.latitude
                geolocationData.longitude = location.coordinate.longitude
                geolocationData.altitude = location.altitude
                geolocationData.speed = location.speed
                geolocationData.floor = location.floor?.level
                if lastLocation != nil {
                    geolocationData.distanceFromLocation = location.distanceFromLocation(lastLocation!)
                }
                geolocationData.timeStamp = NSDate()
                itemTrack.listLocations.append(geolocationData)
                
                //save name of track
                if itemTrack.presenterData?.nameTracking == nil {
                    let locationForName = CLLocation(latitude: (itemTrack.listLocations.first?.latitude)!, longitude: (itemTrack.listLocations.first?.longitude)!)
                    setNameTrack(locationForName)
                    if nameOfPlace != nil {
                        itemTrack.presenterData?.nameTracking = nameOfPlace!
                    }
                }
                //send data to presenter
                presenter?.didUpdateDataToPresenter(dataPresenter)
                startTimer()
            }
        }
    }
    
    // set name of tracker save name of starting point
    func setNameTrack(locationName: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(locationName, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks != nil {
                
                if placemarks!.count > 0 {
                    if placemarks!.first! .thoroughfare != nil {
                        self.nameOfPlace = placemarks!.first!.thoroughfare! + " "
                    }
                    if placemarks!.first!.locality != nil && self.nameOfPlace != nil {
                       self.nameOfPlace =  self.nameOfPlace! + placemarks!.first!.locality!
                    }

                } else {
                    print("Problem with the data received from geocoder")
                }
            }
        })
    }
}

extension BTNewRouteInteractor: BTNewRouteInteractorInput {
    
    //start- stop tracking
    func startStopTracking(actionName: String, dataToStartTracking: BTGetDataFromPresenter?) {
        switch actionName {
            
            //have "start" signal
        case "start":
            
            //initialize variable when save current data CLLocation
            itemTrack = BTTrackItem()
            totalDistanceCycling = 0.0
            totalTimeCycling = 0.0
            if dataToStartTracking == nil {
                itemTrack.presenterData = BTGetDataFromPresenter()
            } else {
                itemTrack.presenterData = dataToStartTracking
            }
            locationPoints.removeAll()
            startCycling = NSDate()
            itemTrack.startingTime = startCycling
            locationManager.startLocation()
            
        case "stop":
            
            //prepare data for saving
            itemTrack.finishingTime = NSDate()
            itemTrack.duration = itemTrack.finishingTime?.timeIntervalSinceDate(itemTrack.startingTime!)
            itemTrack.length = totalDistanceCycling
            var startPointLatitude: Double?
            var startPointLongitude: Double?
            var finishPointLatitude: Double?
            var finishPointLongitude: Double?
            if itemTrack.listLocations.first?.latitude != nil {
                startPointLatitude = (itemTrack.listLocations.first?.latitude)!
            }
            if itemTrack.listLocations.first?.longitude != nil {
                startPointLongitude = (itemTrack.listLocations.first?.longitude)!
            }
            if itemTrack.listLocations.last?.altitude != nil {
                finishPointLatitude = (itemTrack.listLocations.last?.latitude)!
            }
            if itemTrack.listLocations.last?.longitude != nil {
                finishPointLongitude = (itemTrack.listLocations.last?.longitude)!
            }
            
            itemTrack.startingLocation = "\(startPointLatitude) " + "\(startPointLongitude)"
            itemTrack.finishingLocation = "\(finishPointLatitude) " + "\(finishPointLongitude)"
            var minHeight: Double = 0
            var maxHeight: Double = 0
            for location in locationPoints {
                if minHeight == 0 {
                    minHeight = location.altitude
                }
                if location.altitude < minHeight {
                    minHeight = location.altitude
                }
                if location.altitude > maxHeight {
                    maxHeight = location.altitude
                }
            }
            
            //save data to file
            itemData?.getTrackDidFinish(itemTrack)
            locationManager.stopLocation()

            //send request to jump in another window
            presenter?.fetchItemForDetailListController(BTConstant.JUMPTONEWDATA)
            stopTimer()
        default:
            print("nothing hapened")
            break
        }
    }
    
    //set POI for trackings point
    func addPOIItem(item: BTPoiItem) {
        var geolocationData: BTGeolocationData?
        if itemTrack.listLocations.last != nil {
            geolocationData = itemTrack.listLocations.last!
        }
        if geolocationData != nil {
            geolocationData!.listPOI.append(item)
            
        }
    }
}

    