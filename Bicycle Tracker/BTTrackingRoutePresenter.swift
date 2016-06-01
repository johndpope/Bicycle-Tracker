//
//  BTTrackingRoutePresenter.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/25/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation
import MapKit


class BTTrackingRoutefPresenter: NSObject {
    private var itemTrack: BTTrackItem?
    private var interactor: BTTrackingRouteInteractorInput?
    private var view: BTTrackingRouteViewInput?
    private var assembly: BTTrackingRouteAssembly?
    init(item: BTTrackItem, view: BTDetailRouteViewController) {
        super.init()
        itemTrack = item
        assembly = BTTrackingRouteAssembly(item: item, sourceViewController: view, presenterSource: self)
    }
    func setInteractor(item: BTTrackingRouteInteractorInput) {
        interactor = item
    }
    func setVeiwControllerProtocol(item: BTTrackingRouteViewInput) {
        view = item
    }
}

extension BTTrackingRoutefPresenter: BTTrackingRouteInteractorOutput {
    func fetchTrack(item: BTTrackItem) {
        var pointsOfTrack = [CLLocationCoordinate2D]()
        for item in item.listLocations {
            pointsOfTrack.append(CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!))
        }
        view?.fetchedSourceTrack(pointsOfTrack)
    }
    
    func fetchCurrentData(currentData: BTFetchDataPresenter, course: Double) {
        let location = CLLocation(latitude: (currentData.newCoordinateLocation?.latitude)!, longitude: (currentData.newCoordinateLocation?.longitude)!)
        setStartCoordinate(location, course: course)
       // view?.setTimeText(String.formattedDuration(<#T##duration: Double##Double#>))
        view?.setSpeedText(String.formattedSpeed(currentData.сurrentSpeed))
        view?.setDistanceText(String.formattedDistance(currentData.travelPath))
        
    }
    // set region for map view
    func setStartCoordinate(location: CLLocation, course: Double = 0.0) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, BTDistanceZoom.ZoomUptoMinSpeed.rawValue, BTDistanceZoom.ZoomUptoMinSpeed.rawValue)
        view!.setRegion(region, course: location.course)
    }
    
    // alert signal of poor connection with satelites
     func fetchingAlertPoorSignal(alert: Bool) {
           view!.fetchPowerSignal(alert)
    }
}

extension BTTrackingRoutefPresenter: BTTrackingRouteViewOutput {
    func pressStartStopButton(stringAction: String) {
        interactor?.startStopAction(stringAction)
    }
}
