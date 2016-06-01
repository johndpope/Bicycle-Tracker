//
//  BTTrackingRouteAssembly.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/26/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit


class BTTrackingRouteAssembly: NSObject {
    private var trackingRouteViewController: BTTrackingRouteViewController?
    private var presenter: BTTrackingRoutefPresenter?
    private var interactor: BTTrackingRouteInteractor?
    init(item: BTTrackItem, sourceViewController: BTDetailRouteViewController, presenterSource: BTTrackingRoutefPresenter) {
        super.init()
        interactor = BTTrackingRouteInteractor(item: item)
       // interactor?.locationManager = BTLocationManager.sharedInstances
        interactor?.locationManager.setPresenterProtocol(interactor!)
        
         trackingRouteViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TrackingRouteViewController") as? BTTrackingRouteViewController
        sourceViewController.navigationController?.pushViewController(trackingRouteViewController!, animated: true)
        self.presenter = presenterSource
        
        trackingRouteViewController?.setPresetner(presenter!)
        if interactor != nil {
            presenter?.setInteractor(interactor!)
        }
        presenter?.setVeiwControllerProtocol(trackingRouteViewController!)
        interactor?.setIteractorOutputProtocol(presenter!)
        interactor?.locationManager.startLocation()
    }
}