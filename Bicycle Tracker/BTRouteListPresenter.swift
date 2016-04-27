//
//  BTRouteListPresenter.swift
//  Bicycle Tracker
//
//  Created by Plumb on 2/17/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit

class BTRouteListPresenter: NSObject {
    var view: BTRouteListViewInput?
    var interactor: BTRouteListInteractorOutput?
    var routeListItems = [BTRouteListItem]()
    
    // MARK: - Private
    func prepareRouteListItems(itemsArray: [BTTrackItem]) -> [BTRouteListItem] {
        // convert data from interactor into appropriate format
        var routeListItemsArray = [BTRouteListItem]()
        for item in itemsArray {
            var routeListItem = BTRouteListItem()
            routeListItem.name = item.presenterData!.nameTracking
            
            if item.length != nil {
                routeListItem.length = String.formattedDistance(item.length!)
            }
            
            if item.duration != nil {
                routeListItem.duration =  String.formattedDuration(item.duration!)
            }
            
            routeListItem.objectId = item.trackId
            routeListItem.address = item.presenterData!.placeOfRiding
            
            if item.nameFileScreenShotRoute != nil {
                routeListItem.screenshot = formattedScreenshot(item.nameFileScreenShotRoute!)
            } else {
                routeListItem.screenshot = formattedScreenshot("")
            }
            
            routeListItemsArray.append(routeListItem)
        }
        return routeListItemsArray
    }
    
    // MARK: - Formatting
    func formattedScreenshot(named: String) -> UIImage {
        if !named.isEmpty {
            let path = String.screenshotDataFilePath(named)
            let screenshot = UIImage(contentsOfFile: path)
            if screenshot != nil {
                return screenshot!//.resizedImageWithBounds(CGSize(width: 100, height: 100))
            }
        }
        return Constants.noContentImage!
    }
    
    // MARK: - Navigation
    func presentDetailRouteViewController(routeId: Int) {
        weak var detailRouteViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetilRouteViewController") as? BTDetailRouteViewController
        detailRouteViewController?.presenter = BTDetailRouteViewPresenter()
        detailRouteViewController?.presenter?.view = detailRouteViewController
        detailRouteViewController?.presenter!.trackId = routeId
        detailRouteViewController?.presenter!.interactor = BTDetailRouteViewInteractor()
        detailRouteViewController?.presenter!.interactor?.setDetailRoutePresenter((detailRouteViewController?.presenter)!)
        weak var sourceViewController = self.view as? BTRouteListViewController
        sourceViewController?.navigationController?.pushViewController(detailRouteViewController!, animated: true)
    }
    
    func presentNewRouteViewController() {
        let newRouteViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewRouteViewController") as? BTNewRouteViewController
       newRouteViewController?.presenter = BTNewRoutePresenter()
       newRouteViewController?.interactor = BTNewRouteInteractor()
        
         let sourceViewController = self.view as? BTRouteListViewController
        sourceViewController?.navigationController?.pushViewController(newRouteViewController!, animated: true)
    }
}

// MARK: - BTRouteListViewOutput
extension BTRouteListPresenter: BTRouteListViewOutput {
    func setupView() {
        // query all routes from interactor
        let routes = (interactor?.fetchArrayTrack())!
        
        if (routes.count > 0) {
            routeListItems = prepareRouteListItems(routes)
        }
    }
    
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfRoutes(inSection section: Int) -> Int {
        return self.routeListItems.count
    }
    
    func setContentToView(view: BTRouteListItemViewProtocol, indexPath: NSIndexPath) {
        // setup content view
        let routeListItem = self.routeListItems[indexPath.row]
        view.setName(routeListItem.name!)
        if routeListItem.length != nil {
            view.setLength(routeListItem.length!)
        }
        if routeListItem.duration != nil {
            view.setDuration(routeListItem.duration!)
        }
        if routeListItem.screenshot != nil {
            view.setScreenshot(routeListItem.screenshot!)
        }
    }
    
    func didTriggerTapGoRideButton() {
        self.presentNewRouteViewController()
    }
    
    func didTriggerTapCell(atIndexPath indexPath: NSIndexPath) {
        let routeListItem = self.routeListItems[indexPath.row]
        self.presentDetailRouteViewController(routeListItem.objectId!)
    }
    
    func didTriggerSearchBarButtonTappedWithText(text: String, difficultySegmentControllIndex: Int) {
        print("didTriggerSearchBarButtonTappedWithText: \(text) and difficulty level: \(difficultySegmentControllIndex)")
    }
}
