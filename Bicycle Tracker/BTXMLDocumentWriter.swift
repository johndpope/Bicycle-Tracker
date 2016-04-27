//
//  BTXMLDocumentWriter.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 2/15/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation


class BTXMLDocumentWriter: NSObject{
    var trackItem: BTTrackItem?
    var tracks: [BTTrackItem]?
    var nameFile: String?
    
    init(nameFile: String?) {
        self.nameFile = nameFile
    }

    //save all tracks in xml file
    func saveTracks(tracks: [BTTrackItem]) {
        
        //split elements of objects into file's tags
        let tracksElement: GDataXMLElement = GDataXMLNode.elementWithName( BTNameTagOfFile.TRACKS)
        var id: Int = 0
        for track in tracks {
            
            let trackElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.TRACK)
            let trackIdElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.TRACKID, stringValue: String(format: "%d", id) )
            id++
            var str = BTConstant.EMPTYSTRING
            if track.presenterData?.nameTracking != nil &&  track.presenterData?.nameTracking != BTConstant.EMPTYSTRING {
                  str = (track.presenterData?.nameTracking)!
            } else {
               str = stringDate(NSDate())
            }
            let nameFileElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.NAMEFILESCREENSHOTROUTE, stringValue: track.nameFileScreenShotRoute)
            let nameTrackingElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.NAMETRACKING, stringValue: str )
            
            let typeOfRidingElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.TYPEOFRIDING, stringValue: track.presenterData?.typeOfRiding)
            let placeOfRidingElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.PLACEOFRIDING, stringValue:  track.presenterData?.placeOfRiding)
            let numberOfCyclesElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.NUMBEROFCYCLES, stringValue: track.presenterData?.numberOfCycles != nil ? String(format: "%d",(track.presenterData?.numberOfCycles)!): BTConstant.NULLSTRING)
            let lengthElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LENGTH, stringValue: track.length != nil ? String(format: "%.2f", track.length!): BTConstant.NULLSTRING)
            let durationElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.DURATIOH, stringValue: track.duration != nil ? String(format: "%.2f", track.duration!): BTConstant.NULLSTRING)
            let heightDifferenceElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.HEIGHTDIFFERENCE, stringValue: (track.heightDifference != nil ? String(format: "%f", track.heightDifference!): BTConstant.NULLSTRING))
            let startingLocationElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.STARTINGLOCATION,stringValue: track.startingLocation!)
            let finishingLocationElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.FINISHINGLOCATION, stringValue: track.finishingLocation!)
            let startingTimeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.STARTINGTIME, stringValue: stringDate(track.startingTime!))
            let finishingTimeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.FINISHINGTIME, stringValue: stringDate(track.finishingTime!))
            let commentsElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.COMMENTS, stringValue: track.presenterData?.comments )
            let listLocationsElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LISTLOCATIONS)
            
            for location in track.listLocations {
                
                let locationElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LOCATION)
                let latitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LATITUDE, stringValue: (location.latitude != nil ? String(format: "%f", location.latitude!): BTConstant.NULLSTRING))
                let longitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LONGITUDE, stringValue:(location.longitude != nil ?  String(format: "%f", location.longitude!): BTConstant.NULLSTRING))
                let altitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.ALTITUDE, stringValue: (location.altitude != nil ?  String(format: "%.3f", location.altitude!): BTConstant.NULLSTRING))
                let speedElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.SPEED, stringValue: location.speed != nil ?  String(format: "%.2f", location.speed!): BTConstant.NULLSTRING)
                let timeStampElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.TIMESTAMP, stringValue:  location.timeStamp != nil ? stringDate(location.timeStamp!): stringDate(NSDate()))
                let floorElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.FLOOR, stringValue:   location.floor != nil ? String(format: "%d", location.floor!): BTConstant.NULLSTRING)
                let distanceFromLocationElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.DISTNACEFROMLOCATION, stringValue: location.distanceFromLocation != nil ? String(format:"%.3f", location.distanceFromLocation!): BTConstant.NULLSTRING)
                let listPOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LISTPOI)
                
                for poi in location.listPOI {
                    
                    let pOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.POI)
                    let namePOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.NAMEPOI, stringValue: poi.name)
                    let commentsPOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.COMMENTSPOI, stringValue: poi.comments)
                    let typePOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.TYPEPOI, stringValue:  poi.type)
                    let restingTimeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.RESTINGTIME, stringValue: poi.restingTime != nil ?String(format: "%f", poi.restingTime): BTConstant.NULLSTRING)
                    pOIElement.addChild(namePOIElement)
                    pOIElement.addChild(commentsPOIElement)
                    pOIElement.addChild(typePOIElement)
                    pOIElement.addChild(restingTimeElement)
                    listPOIElement.addChild(pOIElement)
                }
                
                locationElement.addChild(latitudeElement)
                locationElement.addChild(longitudeElement)
                locationElement.addChild(altitudeElement)
                locationElement.addChild(speedElement)
                locationElement.addChild(timeStampElement)
                locationElement.addChild(floorElement)
                locationElement.addChild(distanceFromLocationElement)
                locationElement.addChild(listPOIElement)
                listLocationsElement.addChild(locationElement)
            }
            
            trackElement.addChild(trackIdElement)
            trackElement.addChild(nameFileElement)
            trackElement.addChild(nameTrackingElement)
            trackElement.addChild(typeOfRidingElement)
            trackElement.addChild(placeOfRidingElement)
            trackElement.addChild(numberOfCyclesElement)
            trackElement.addChild(lengthElement)
            trackElement.addChild(durationElement)
            trackElement.addChild(heightDifferenceElement)
            trackElement.addChild(startingLocationElement)
            trackElement.addChild(finishingLocationElement)
            trackElement.addChild(startingTimeElement)
            trackElement.addChild(finishingTimeElement)
            trackElement.addChild(commentsElement)
            trackElement.addChild(listLocationsElement)
            tracksElement.addChild(trackElement)
        }
        
        let document: GDataXMLDocument = GDataXMLDocument(rootElement: tracksElement)
        let xmlData: NSData = document.XMLData()
        let dataString = NSString(data: xmlData, encoding: NSUTF8StringEncoding) as String?
        let dataWrite = dataString![22 ..< (dataString?.utf16.count)!]
        do {
            // write tags into file
            try dataWrite.writeToFile(BTConstant.pathFile(nameFile), atomically: true, encoding: NSUTF8StringEncoding)

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //formatted date into one format
    func stringDate(time: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = BTConstant.DAYFORMATED
        return dateFormatter.stringFromDate(time)
    }
    
}

//delete part of string depends of range
extension String {
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
}

extension BTXMLDocumentWriter: BTXMLDocumentWriterModuleIncoming {
    
    //get new track for writing
    func getTrackDidFinish(track: BTTrackItem) {
        trackItem = track
        let xmlParser = BTXMLParser(nameFile: nameFile)
        
        //parse existing xml file
        tracks = xmlParser.parserDocument()
        if tracks == nil {
            tracks = [BTTrackItem]()
        }
        //add new track
        tracks?.append(track)
        saveTracks(tracks!)
    }
}