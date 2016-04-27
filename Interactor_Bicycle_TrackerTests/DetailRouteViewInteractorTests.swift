//
//  DetailRouteViewInteractorTest.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 2/22/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import XCTest
@testable import Bicycle_Tracker
import Foundation
import CoreLocation

class DetailRouteViewInteractorTests: XCTestCase {
    
    private var itemForTest: BTDetailRouteViewInteractor?
    private var presenter: TestPresenter?
    var item: BTTrackItem?
    var items: [BTTrackItem] = []
    
    override func setUp() {
        super.setUp()
        
        //creating item
        item = BTTrackItem()
        item?.startingLocation = "0"
        item?.finishingLocation = "0"
        item?.startingTime = NSDate()
        item?.finishingTime = NSDate()
        
        //create array of items
        items = [BTTrackItem]()
        items.append(item!)
        
        //save data into temporary file
        let saveData = BTXMLDocumentWriter(nameFile: "test.xml" )
        saveData.saveTracks(items)
        
        //create interactor for test
        itemForTest = BTDetailRouteViewInteractor()
        presenter = TestPresenter()
        itemForTest?.setDetailRoutePresenter(presenter!)
        itemForTest?.setParser(BTXMLParser(nameFile: "test.xml"))
        
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

    
    // query track with id=0 and checked if I will have track with id == 0
   func testgetItemId() {
       itemForTest?.queryDetailTrack(0)
        XCTAssertEqual(presenter?.testItem?.trackId, 0)
   }
    
}


class TestPresenter: NSObject, BTDetailRouteViewInteractorOutput {
    var testItem: BTTrackItem?
    
    func getDetailTrack(item: BTTrackItem) {
        testItem = item
    }
    
}