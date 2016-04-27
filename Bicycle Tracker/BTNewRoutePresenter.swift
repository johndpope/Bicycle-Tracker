//
//
//  BTNewRoutePresenter.swift
//  Bicycle Tracker
//
//  Created by Plumb on 2/12/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import MapKit

class BTNewRoutePresenter: NSObject {
    enum RouteAction: String {
        case RouteActionStart = "start"
        case RouteActionStop = "stop"
    }
    
    var outdoorInteractor : BTNewRouteInteractorInput?
    var userInterface : BTNewRouteViewInput?
    
    // MARK: - Private
    func updateUserInterfaceWithNewData(data: BTFetchDataPresenter) {
        //prepare and set data to UI
        let currentSpeed = String.formattedSpeed(data.сurrentSpeed)
        userInterface?.setSpeedText(currentSpeed)
        
        let currentDistance = String.formattedDistance(data.travelPath)
        userInterface?.setDistanceText(currentDistance)
        
        userInterface?.setCurrentCoordinate(data.newCoordinateLocation!)
        
        if (data.lastCoordinateLocation != nil) {
            userInterface?.makePolynileWithCoordinates(data.lastCoordinateLocation!, currentPosition: data.newCoordinateLocation!)
        }
    }
    
    // MARK: - Navigation
    func presentDetailRouteViewControllerWithRouteId(routeId: Int) {
        // setup VIPER components
        weak var detailRouteViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetilRouteViewController") as? BTDetailRouteViewController
        detailRouteViewController?.presenter = BTDetailRouteViewPresenter()
        detailRouteViewController?.presenter?.view = detailRouteViewController
        detailRouteViewController?.presenter!.trackId = routeId
        detailRouteViewController?.presenter!.interactor = BTDetailRouteViewInteractor()
        detailRouteViewController?.presenter!.interactor?.setDetailRoutePresenter((detailRouteViewController?.presenter)!)
        weak var sourceViewController = self.userInterface as? BTNewRouteViewController
        sourceViewController?.navigationController?.pushViewController(detailRouteViewController!, animated: true)
    }

func segueRouteListController() {
//    weak var routeListViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RouteListViewController") as? BTRouteListViewController
        weak var sourceViewController = self.userInterface as? BTNewRouteViewController
    sourceViewController?.navigationController?.popViewControllerAnimated(true)//pushViewController(routeListViewController!, animated: true)
    outdoorInteractor = nil
    userInterface = nil
    
}
}

// MARK: - BTNewRouteViewOutput
extension BTNewRoutePresenter: BTNewRouteViewOutput {
    func startRouteAction() {
        outdoorInteractor?.startStopTracking(RouteAction.RouteActionStart.rawValue,
            dataToStartTracking: BTGetDataFromPresenter())
    }
    
    func stopRouteAction() {
        outdoorInteractor?.startStopTracking(RouteAction.RouteActionStop.rawValue, dataToStartTracking: BTGetDataFromPresenter())
    }
}

// MARK: - BTNewRouteInteractorOutput
extension BTNewRoutePresenter: BTNewRouteInteractorOutput {
    func didUpdateDataToPresenter(fetchDataDidUpdata: BTFetchDataPresenter) {
        updateUserInterfaceWithNewData(fetchDataDidUpdata)
    }
    
    func fetchItemForDetailListController(idItemTrack: Int) {
        self.presentDetailRouteViewControllerWithRouteId(idItemTrack)
    }
    
    func setRegionForStart(region: MKCoordinateRegion){
        userInterface?.setRegionForStartPoin(region)
    }
    
    func fetchingAlertPoorSignal(alert: Bool) {
        userInterface?.fetchingAlertPoorSatelitsSignal(alert)
    }
}

