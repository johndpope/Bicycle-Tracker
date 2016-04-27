//
//  RouteListInteractorTests.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 2/22/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import XCTest
@testable import Bicycle_Tracker
import Foundation

class RouteListInteractorTests: XCTestCase {
    
    private var routeListInteractor: BTRouteListInteractor?
    private var items: [BTTrackItem]?
    private var writer: BTXMLDocumentWriter?
    
    override func setUp() {
        super.setUp()
        
        //create object
        routeListInteractor = BTRouteListInteractor()
        routeListInteractor?.setXMLParser(BTXMLParser(nameFile: "test.xml"))
        //create file "test.xml"
        writer = BTXMLDocumentWriter(nameFile: "test.xml")
        
        //create item for writing
        var item = BTTrackItem()
        item.startingLocation = BTConstant.EMPTYSTRING
        item.finishingLocation = BTConstant.EMPTYSTRING
        item.startingTime = NSDate()
        item.finishingTime = NSDate()
        
        //writing item
        writer!.getTrackDidFinish(item)
        
        //read items
         items = BTXMLParser(nameFile: "test.xml").parserDocument()
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
    
    //get items from test's file
    func testgetCountOfItems() {
       
        XCTAssertNotNil(items?.count)
        
    }
    
    
    //check correct writting 
    func testPerformanceExample() {
        
        XCTAssertEqual(items?.first?.trackId, 0)
    }
}
