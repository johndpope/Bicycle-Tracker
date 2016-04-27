//
//  Interactor_Bicycle_TrackerTests.swift
//  Interactor_Bicycle_TrackerTests
//
//  Created by kkolontay on 2/10/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import XCTest
@testable import Bicycle_Tracker
import Foundation
import CoreLocation
import MapKit

class Interactor_Bicycle_TrackerTests: XCTestCase {
    
    private var interactor: BTNewRouteInteractor!
    private var fetchDataPresenter: BTFetchDataPresenter!
    private var getDataFromPresenter: BTGetDataFromPresenter!
    private var poiItem: BTPoiItem!
    private var geolocationData: BTGeolocationData!
    private var trackItem: BTTrackItem!
    private var getDataFromPresenterRequest: BTGetDataFromPresenterRequest!
    private var presenterClass: Presenter?
    private var itemClass: Item?
    var view: BTNewRouteViewController?
    
    override func setUp() {
        super.setUp()
        
        //create interactor
        interactor = BTNewRouteInteractor()
        
        //create view controller
        view = BTNewRouteViewController()
        
        //create structure data recieved from view controller
        fetchDataPresenter = BTFetchDataPresenter()
        
        //create sturcture data send to view controller
        getDataFromPresenter = BTGetDataFromPresenter()
        
        //create structure of POI data
        poiItem = BTPoiItem()
        
        //create structure of geolocation data
        geolocationData = BTGeolocationData()
        
        //create item for save data into file
        trackItem = BTTrackItem()
        
        //create structure data recieved from view controller
        getDataFromPresenterRequest = BTGetDataFromPresenterRequest()
        getDataFromPresenter.comments = "hello world"
        getDataFromPresenter.nameTracking = "test"
        getDataFromPresenter.numberOfCycles = 3
        getDataFromPresenter.typeOfRiding = "cool"
        getDataFromPresenter.placeOfRiding = "my place"
        
        //create presenter
        presenterClass = Presenter()
        presenterClass?.delegate = interactor
        presenterClass?.dataFromPresenter = getDataFromPresenter
        interactor.setPresenterDelegate(presenterClass!)
        interactor.setFetchDataToItem(BTXMLDocumentWriter(nameFile: "test.xml"))
        
        //send to interactor start signal
        presenterClass?.delegate?.startStopTracking((presenterClass?.startString)!, dataToStartTracking: getDataFromPresenter)
        
        //create data with location's coordinate
        itemClass = Item()
        
        // interactor.setFetchDataToItem(itemClass!)
        
        poiItem.comments  = "it's test POI"
        poiItem.name = "cool place"
        poiItem.restingTime = 5.0
        poiItem.type = "alarm"
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        //delete file "test.xml"
        var path: String?
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first {
            path = dir.stringByAppendingPathComponent("test.xml")
        }
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path!)
        }catch {
            print("/(ErrorType)")
        }
        
    }
    
    
    //check alert depends from horizontal accuracy
    func testAlertSignal() {
        var location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33333, longitude: 22222), altitude: 23.5, horizontalAccuracy: 0.00002, verticalAccuracy: 34.8, course: 21.0, speed: 333.6, timestamp: NSDate())
        
        
        interactor.getAlertPoorSignal(location)
        var alertSignal = presenterClass?.alertSignal
        XCTAssertTrue(alertSignal! as Bool)
        
        location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33333, longitude: 22222), altitude: 23.5, horizontalAccuracy: 41, verticalAccuracy: 34.8, course: 21.0, speed: 333.6, timestamp: NSDate())
        
        
        interactor.getAlertPoorSignal(location)
        alertSignal = presenterClass?.alertSignal
        XCTAssertTrue(alertSignal! as Bool)
        location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33333, longitude: 22222), altitude: 23.5, horizontalAccuracy: 26, verticalAccuracy: 34.8, course: 21.0, speed: 333.6, timestamp: NSDate())
        
        interactor.getAlertPoorSignal(location)
        alertSignal = presenterClass?.alertSignal
        XCTAssertFalse(alertSignal! as Bool)
        location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33333, longitude: 22222), altitude: 23.5, horizontalAccuracy: 9, verticalAccuracy: 34.8, course: 21.0, speed: 333.6, timestamp: NSDate())
        
        interactor.getAlertPoorSignal(location)
        alertSignal = presenterClass?.alertSignal
        XCTAssertFalse(alertSignal! as Bool)
        
    }
    
    //check fetched data to presenter
    func testFetchDataPresenter() {
        interactor.startStopTracking("start", dataToStartTracking: BTGetDataFromPresenter())
        interactor.fetchLocationsInteractor((itemClass?.getLocationsClass())!)
        let temp = presenterClass?.currentDataForView
        XCTAssertEqual(temp?.сurrentSpeed, 333.6)
    }
    
    //check save data when get command stop
    func testsaveData() {
        interactor.fetchLocationsInteractor((itemClass?.getLocationsClass())!)
        interactor.startStopTracking("stop", dataToStartTracking: BTGetDataFromPresenter())
        let reader = BTXMLParser(nameFile: "test.xml")
        let items = reader.parserDocument()
        XCTAssertEqual(items.first!.listLocations.count,  5)
    }
    
    
    //check send signal to another view controller
    func testSendSignal(){
        interactor.startStopTracking("stop", dataToStartTracking: BTGetDataFromPresenter())
        
        XCTAssertEqual(presenterClass?.segueSignal , -9999)
    }
}
class Item: NSObject {
    var item: BTTrackItem?
    
    func getLocationClass() -> CLLocation {
        
        return CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33333, longitude: 22222), altitude: 23.5, horizontalAccuracy: 2.6, verticalAccuracy: 34.8, course: 21.0, speed: 333.6, timestamp: NSDate())
    }
    
    func getLocationsClass() -> [CLLocation] {
        var locations = [CLLocation]()
        for _ in 0...4 {
            locations.append(getLocationClass())
        }
        return locations
    }
    
}

extension Item: BTXMLDocumentWriterModuleIncoming {
    
    //this function send information about track
    func getTrackDidFinish(track: BTTrackItem) {
        item = track;
    }
    func saveTracks(tracks: [BTTrackItem]) {
        
    }
}

class Presenter: NSObject {
    var delegate: BTNewRouteInteractorInput?
    var startString: String?
    var stopString: String?
    var dataFromPresenter: BTGetDataFromPresenter?
    var currentDataForView: BTFetchDataPresenter?
    var alertSignal: Bool?
    var segueSignal: Int?
    override init() {
        super.init()
        startString = "start"
        stopString = "stop"
    }
}

extension Presenter: BTNewRouteInteractorOutput {
    
    
    func didUpdateDataToPresenter(fetchDataDidUpdata: BTFetchDataPresenter) {
        currentDataForView = fetchDataDidUpdata
    }
    func setRegionForStart(region: MKCoordinateRegion){
        
    }
    
    func fetchArrayTrack() -> [BTTrackItem] {
        return [BTTrackItem]()
    }
    
    
    func fetchItemForDetailListController(idItemTrack: Int) {
        segueSignal = idItemTrack
    }
    func fetchingAlertPoorSignal(alert: Bool) {
        alertSignal = alert
        
    }
}

