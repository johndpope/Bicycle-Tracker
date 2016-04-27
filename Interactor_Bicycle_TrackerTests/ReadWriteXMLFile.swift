//
//  ReadWriteXMLFile.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/14/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import XCTest
import Foundation
@testable import Bicycle_Tracker


// test read-write data into file
class ReadWriteXMLFile: XCTestCase {
    
    var writer: BTXMLDocumentWriter?
    var reader: BTXMLParser?
    
    override func setUp() {
        super.setUp()
        
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
        
        //read data
        reader = BTXMLParser(nameFile: "test.xml")
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
    
    //read from file data and checked count of items
    func testReadWrite() {
        
        
        let items = reader!.parserDocument()
        XCTAssertGreaterThan(items.count , 0)
    }
    
    //checed correct read-write data
    func testCheckId() {
        let items = reader!.parserDocument()
        XCTAssertEqual(items.first?.trackId, 0)
    }
    
}
    
