//
//  BTXMLParser.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 2/15/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit

protocol BTXMLParserModuleOutput {
    func parserDocument() -> [BTTrackItem]
}

class BTXMLParser: NSObject, BTXMLParserModuleOutput, NSXMLParserDelegate {
    var xmlParser: NSXMLParser!
    var itemsTrack: [BTTrackItem] = []
    var itemsLocation: [BTGeolocationData]?
    var itemsPOI: [BTPoiItem]?
    var currentTrack: BTTrackItem?
    var currentLocation: BTGeolocationData?
    var currentPOI: BTPoiItem?
    var xmlText: String
   
     init(nameFile: String?) {
         xmlText = BTConstant.EMPTYSTRING
        super.init()
       
        do {
                //starting parse existing xml file
                let xml = try String(contentsOfFile: BTConstant.pathFile(nameFile), encoding: NSUTF8StringEncoding)
                if let data = xml.dataUsingEncoding(NSUTF8StringEncoding) {
                    xmlParser = NSXMLParser(data: data)
                    xmlParser?.delegate = self
            }
            
        } catch {
            print(error)
        }
    }
    
    //format string to date
    func formatStringToDate(string: String?) -> NSDate? {
        if !string!.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = BTConstant.DAYFORMATED
            if string == BTConstant.NULLSTRING {
                return dateFormatter.dateFromString(BTConstant.SOMEDATE)
            }
            return dateFormatter.dateFromString(string!)!
        }
        return NSDate()
    }
    
    //parse document from started tags
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        xmlText = BTConstant.EMPTYSTRING
        switch elementName {
        case  BTNameTagOfFile.TRACK:
            currentTrack = BTTrackItem()
            currentTrack?.presenterData = BTGetDataFromPresenter()
            
        case  BTNameTagOfFile.LISTLOCATIONS:
            itemsLocation = [BTGeolocationData]()
            
        case BTNameTagOfFile.LOCATION:
            currentLocation = BTGeolocationData()
            
        case  BTNameTagOfFile.LISTPOI:
            itemsPOI = [BTPoiItem]()
            
        case BTNameTagOfFile.POI:
            currentPOI = BTPoiItem()
            
        default:
            break
        }
    }


    //parse document from finising tags
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case BTNameTagOfFile.LISTPOI:
            currentLocation?.listPOI = itemsPOI!
        
        case BTNameTagOfFile.POI:
            itemsPOI?.append(currentPOI!)
        
        case BTNameTagOfFile.NAMEPOI:
            currentPOI?.name = xmlText
        
        case BTNameTagOfFile.COMMENTSPOI:
            currentPOI?.comments = xmlText
        
        case  BTNameTagOfFile.TYPEPOI:
            currentPOI?.type = xmlText
        
        case BTNameTagOfFile.NAMETRACKING:
            currentTrack?.presenterData?.nameTracking = xmlText
        
        case  BTNameTagOfFile.TYPEOFRIDING:
            currentTrack?.presenterData?.typeOfRiding = xmlText
        
        case  BTNameTagOfFile.PLACEOFRIDING:
            currentTrack?.presenterData?.placeOfRiding = xmlText
        
        case  BTNameTagOfFile.NUMBEROFCYCLES:
            if let numberOfCycles = Int(xmlText) {
                currentTrack?.presenterData?.numberOfCycles = numberOfCycles
            }
        
        case  BTNameTagOfFile.RESTINGTIME:
            if let restingTime = Double(xmlText) {
                currentPOI?.restingTime = restingTime
            }
        
        case  BTNameTagOfFile.TRACKID:
            if let trackId = Int(xmlText) {
                currentTrack?.trackId = trackId
            }
        
        case  BTNameTagOfFile.LENGTH:
            if let length = Double(xmlText) {
                currentTrack?.length =  length
            }
        
        case BTNameTagOfFile.DURATIOH:
            if let duratin = Double(xmlText) {
                currentTrack?.duration = duratin
            }
        
        case BTNameTagOfFile.HEIGHTDIFFERENCE:
            if let heightDiffernce = Double(xmlText) {
                currentTrack?.heightDifference = heightDiffernce
            }
        
        case BTNameTagOfFile.STARTINGLOCATION:
            currentTrack?.startingLocation = xmlText
        
        case  BTNameTagOfFile.FINISHINGLOCATION:
            currentTrack?.finishingLocation = xmlText
        
        case BTNameTagOfFile.STARTINGTIME:
            currentTrack?.startingTime = formatStringToDate(xmlText)
        
        case BTNameTagOfFile.FINISHINGTIME:
            currentTrack?.finishingTime = formatStringToDate(xmlText)
        
        case  BTNameTagOfFile.COMMENTS:
            currentTrack?.presenterData?.comments = xmlText
        
        case  BTNameTagOfFile.LATITUDE:
            if let latitude = Double(xmlText) {
            currentLocation?.latitude = latitude
            }
            
        case BTNameTagOfFile.LONGITUDE:
            if let longitude = Double(xmlText) {
            currentLocation?.longitude = longitude
            }
            
        case BTNameTagOfFile.ALTITUDE:
            if let altitude = Double(xmlText) {
            currentLocation?.altitude = altitude
            }
        
        case  BTNameTagOfFile.SPEED:
            if let speed = Double(xmlText) {
            currentLocation?.speed = speed
            }
        
        case BTNameTagOfFile.FLOOR:
            if let floor = Int(xmlText) {
                currentLocation?.floor = floor
            }
    
        case  BTNameTagOfFile.DISTNACEFROMLOCATION:
            if let distanceFromLocation = Double(xmlText) {
            currentLocation?.distanceFromLocation = distanceFromLocation
            }
        
        case  BTNameTagOfFile.TIMESTAMP:
            currentLocation?.timeStamp = formatStringToDate(xmlText)
        
        case BTNameTagOfFile.LISTLOCATIONS:
            currentTrack?.listLocations = itemsLocation!

        case BTNameTagOfFile.LOCATION:
            itemsLocation?.append(currentLocation!)
        
        case BTNameTagOfFile.NAMEFILESCREENSHOTROUTE:
            if xmlText.isEmpty {
                currentTrack?.nameFileScreenShotRoute = BTConstant.EMPTYSTRING
            } else {
            currentTrack?.nameFileScreenShotRoute = xmlText
        }
        
        case BTNameTagOfFile.TRACK:
            if let track = currentTrack {
                itemsTrack.append(track)
            }
        default:
            break
        }
    }
    
    //get string value from tags
    func parser(parser: NSXMLParser, foundCharacters string: String) {
    
        xmlText += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    //get array objects extracted from file
    func parserDocument() -> [BTTrackItem] {
        xmlParser?.parse()
        return itemsTrack
    }
    
}