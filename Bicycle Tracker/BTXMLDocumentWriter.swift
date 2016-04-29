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
            id = id + 1
            var str = BTConstant.EMPTYSTRING
            if track.presenterData?.nameTracking != nil &&  track.presenterData?.nameTracking != BTConstant.EMPTYSTRING {
                  str = (track.presenterData?.nameTracking)!
            } else {
               str = stringDate(NSDate())
            }
            let midWayElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.MIDWAY)
            let latitudeMidWayElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.LATITUDEMIDWAY, stringValue:  track.midWay?.latitudeMidWay != nil ? String(format: "%f", (track.midWay?.latitudeMidWay)!): BTConstant.EMPTYSTRING)
            let longitudeMidWayElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.LONGITUDEMIDWAY, stringValue:  track.midWay?.longitudeMidWay != nil ? String(format: "%f", (track.midWay?.longitudeMidWay)!): BTConstant.EMPTYSTRING)
            let routeComplexityElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.ROUTECOMPLEXITY, stringValue:  track.routeComplexity ?? BTConstant.EMPTYSTRING)
            let middleRouteAddressElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.MIDDLEROUTEADDRESS, stringValue:  track.middleRouteAddress ?? BTConstant.EMPTYSTRING)
            let circleRouteElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.CIRCLEROUTE, stringValue: track.circleRoute ? "true": "false")
            let addressStartPointElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.ADDRESSSTARTPOINT, stringValue:  track.startingAddress ?? BTConstant.EMPTYSTRING)
            let addressFinishPointElement: GDataXMLElement = GDataXMLElement.elementWithName(BTNameTagOfFile.ADDRESSFINISHPOINT, stringValue:  track.finishingAddress ?? BTConstant.EMPTYSTRING)
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
            let usersTracksElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERSTRACKS)
            if track.usersTracks != nil {
            for userTrack in track.usersTracks! {
                let userElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USER)
                let userTrackIdElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERTRACKID, stringValue: userTrack.trackId != nil ? String(format: "%d", userTrack.trackId!): BTConstant.NULLSTRING)
                let userDurationTrackingElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERDURATIONTRACKING, stringValue: userTrack.durationTracking != nil ? String(format: "%f", userTrack.durationTracking!) : BTConstant.NULLSTRING)
                let userDistanceTraveledElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERDISTNACETRAVELED, stringValue: userTrack.distanceTraveled != nil ? String(format: "%f", userTrack.distanceTraveled!) : BTConstant.NULLSTRING)
                let userTraveledPointsElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERTRAVELEDPOINTS)
                
                for userTrackPoint in userTrack.traveledPoints {
                    let userPointElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERPOINT)
                    let onWayElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERPOINT, stringValue: userTrackPoint.onWay ? "true": "false")
                    let userLocationElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERLOCATION)
                    let userLatitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERLATITUDE, stringValue: userTrackPoint.location.latitude != nil ? String(format: "%f", userTrackPoint.location.latitude!) : BTConstant.NULLSTRING)
                     let userLongitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERLONGITUDE, stringValue: userTrackPoint.location.longitude != nil ? String(format: "%f", userTrackPoint.location.longitude!) : BTConstant.NULLSTRING)
                     let userAltitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERALTITUDE, stringValue: userTrackPoint.location.altitude != nil ? String(format: "%f", userTrackPoint.location.altitude!) : BTConstant.NULLSTRING)
                     let userSpeedElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERSPEED, stringValue: userTrackPoint.location.speed != nil ? String(format: "%f", userTrackPoint.location.speed!) : BTConstant.NULLSTRING)
                     let userFloorElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERFLOOR, stringValue: userTrackPoint.location.floor != nil ? String(format: "%d", userTrackPoint.location.floor!) : BTConstant.NULLSTRING)
                    let userTimeStampElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERTIMESTAMP, stringValue: userTrackPoint.location.timeStamp != nil ?  stringDate(userTrackPoint.location.timeStamp!) : stringDate(NSDate()))
                     let userCourseElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.COURSE, stringValue: userTrackPoint.location.course != nil ? String(format: "%f", userTrackPoint.location.course!) : BTConstant.NULLSTRING)
                    let userListPOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERLISTPOI)
                    
                    for userPOI in userTrackPoint.location.listPOI {
                        let userPOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERPOI)
                         let userNamePOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERNAMEPOI, stringValue: userPOI.name != nil ? userPOI.name : BTConstant.NULLSTRING)
                        let userCommentsPOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERCOMMENTSPOI, stringValue: userPOI.comments != nil ? userPOI.comments : BTConstant.NULLSTRING)
                        let userTypePOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERTYPEPOI, stringValue: userPOI.type != nil ? userPOI.type : BTConstant.NULLSTRING)
                        let userRestingTimePOIElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.USERRESTINGTIMEPOI, stringValue: userPOI.restingTime != nil ? String(format: "%f", userPOI.restingTime!) : BTConstant.NULLSTRING)
                        userPOIElement.addChild(userNamePOIElement)
                        userPOIElement.addChild(userCommentsPOIElement)
                        userPOIElement.addChild(userTypePOIElement)
                        userPOIElement.addChild(userRestingTimePOIElement)
                        userListPOIElement.addChild(userPOIElement)
                    }
                    userLocationElement.addChild(userListPOIElement)
                    userLocationElement.addChild(userLatitudeElement)
                    userLocationElement.addChild(userLongitudeElement)
                    userLocationElement.addChild(userAltitudeElement)
                    userLocationElement.addChild(userSpeedElement)
                    userLocationElement.addChild(userFloorElement)
                    userLocationElement.addChild(userTimeStampElement)
                    userLocationElement.addChild(userCourseElement)
                    userPointElement.addChild(userLocationElement)
                    userPointElement.addChild(onWayElement)
                    userTraveledPointsElement.addChild(userPointElement)
                }
                userElement.addChild(userTraveledPointsElement)
                userElement.addChild(userDistanceTraveledElement)
                userElement.addChild(userTrackIdElement)
                userElement.addChild(userDurationTrackingElement)
                usersTracksElement.addChild(userElement)
            }
            }
            
            let listLocationsElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LISTLOCATIONS)
            
            for location in track.listLocations {
                
                let locationElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LOCATION)
                let latitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LATITUDE, stringValue: (location.latitude != nil ? String(format: "%f", location.latitude!): BTConstant.NULLSTRING))
                let longitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.LONGITUDE, stringValue:(location.longitude != nil ?  String(format: "%f", location.longitude!): BTConstant.NULLSTRING))
                let altitudeElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.ALTITUDE, stringValue: (location.altitude != nil ?  String(format: "%.3f", location.altitude!): BTConstant.NULLSTRING))
                let courseElement: GDataXMLElement = GDataXMLNode.elementWithName(BTNameTagOfFile.COURSE, stringValue: location.course != nil ? String(format: "%.2f", location.course!): BTConstant.NULLSTRING)
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
                locationElement.addChild(courseElement)
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
            trackElement.addChild(routeComplexityElement)
            trackElement.addChild(addressFinishPointElement)
            trackElement.addChild(addressStartPointElement)
            midWayElement.addChild(latitudeMidWayElement)
            midWayElement.addChild(longitudeMidWayElement)
            trackElement.addChild(midWayElement)
            trackElement.addChild(middleRouteAddressElement)
            trackElement.addChild(circleRouteElement)
            trackElement.addChild(listLocationsElement)
            trackElement.addChild(usersTracksElement)
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