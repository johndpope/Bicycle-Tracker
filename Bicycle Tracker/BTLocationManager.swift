//
//  BTLocationManager.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/10/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit
import CoreLocation

protocol BTLocationManagerOutput: class {
    func fetchLocationsInteractor(locations:[CLLocation], alert: Bool)
}
protocol BTLocationManagerInput {
    func setPresenterProtocol(mainPresenter: BTLocationManagerOutput)
    func startLocation()
    func stopLocation()
}

class BTLocationManager: NSObject {
    
    class var sharedInstances: BTLocationManager {
        struct  Static {
            static let instance: BTLocationManager = BTLocationManager()
        }
        return Static.instance
    }
    
    weak var presenter: BTLocationManagerOutput?
    // set location manager for 9th version iOS
    @available(iOS 9.0, *)
 private   lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 5.0
        _locationManager.allowsBackgroundLocationUpdates = true
        return _locationManager
    }()
    
    //set location manager for upto 9th version iOS
  private  lazy var locationManagerIOS8: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 5.0
        return _locationManager
    }()

   private override init() {
        super.init()
        getLocationManagerDependsIOSVersion().requestWhenInUseAuthorization()
        getLocationManagerDependsIOSVersion().startUpdatingLocation()
    }
    
    //check version of iOS and use location manager for it
    func getLocationManagerDependsIOSVersion() -> CLLocationManager {
        if #available(iOS 9.0, *) {
            return locationManager
        }
        return locationManagerIOS8
    }
    //send signal about power of connection
  private  func getAlertPoorSignal (location: CLLocation) -> Bool {
        if (location.horizontalAccuracy < BTHorizontalAccuracy.NoSignal.rawValue)
        {
            return true
            // No Signal
        }
        else if (location.horizontalAccuracy > BTHorizontalAccuracy.PoorSingnal.rawValue)
        {
            return true
            // Poor Signal
        }
                   return false
    
    }

}

extension BTLocationManager: CLLocationManagerDelegate {
    
    //update location data
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let alert: Bool = getAlertPoorSignal(locations.last!)
        presenter?.fetchLocationsInteractor(locations, alert: alert)
    }
    
    //callback authorization status, than allow work program in background
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        getLocationManagerDependsIOSVersion().requestAlwaysAuthorization()
    }
    
}

extension BTLocationManager: BTLocationManagerInput {
    
    func startLocation() {
        getLocationManagerDependsIOSVersion().startUpdatingLocation()
    }
    
    func stopLocation() {
        getLocationManagerDependsIOSVersion().stopUpdatingLocation()
    }
    
    func setPresenterProtocol(mainPresenter: BTLocationManagerOutput) {
        presenter = mainPresenter
    }
}