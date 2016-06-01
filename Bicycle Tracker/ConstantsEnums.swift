//
//  ConstantsEnums.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/7/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

enum BTNewRoute: Double {
    case MinSpeedZooming = 6.0
    case AverageSpeedZooming = 12.0
    case MaxSpeedZooming = 20.0
}

struct BTConstant {
    static let NAMEOFFILE = "Items.xml"
    static let JUMPTONEWDATA = -9999
    static let DAYFORMATED = "yyyy-MM-dd hh:mm:ss"
    static let SOMEDATE = "1999-12-31 23:59:59"
    static let EMPTYSTRING = ""
    static let NULLSTRING = "0"
    
    
    static func pathFile(fileName: String?) -> String {
        var path: String?
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first {
            path = dir.stringByAppendingPathComponent(fileName ?? BTConstant.NAMEOFFILE);
            if NSFileManager.defaultManager().fileExistsAtPath(path!) {
                return path!
            }
        }
        NSFileManager.defaultManager().createFileAtPath(path!, contents: nil, attributes: nil )
        return path!
    }
}


enum BTHorizontalAccuracy: Double {
    case NoSignal = 0.0002
    case PoorSingnal = 30
    case AverageSignal = 20
    case StrongSignal = 10
}

struct BTNameTagOfFile {
    static let TRACKS = "tracks"
    static let TRACK = "track"
    static let TRACKID = "trackId"
    static let NAMETRACKING = "nameTracking"
    static let NAMEFILESCREENSHOTROUTE = "nameFileScreenShotRoute"
    static let TYPEOFRIDING = "typeOfRiding"
    static let PLACEOFRIDING = "placeOfRiding"
    static let NUMBEROFCYCLES = "numberOfCycles"
    static let LENGTH = "length"
    static let DURATIOH = "duration"
    static let HEIGHTDIFFERENCE = "heightDifference"
    static let STARTINGLOCATION = "startingLocation"
    static let FINISHINGLOCATION = "finishingLocation"
    static let STARTINGTIME = "startingTime"
    static let FINISHINGTIME = "finishingTime"
    static let COMMENTS = "comments"
    static let LISTLOCATIONS = "listLocations"
    static let LOCATION = "location"
    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    static let ALTITUDE = "altitude"
    static let SPEED = "speed"
    static let TIMESTAMP = "timeStamp"
    static let FLOOR = "floor"
    static let DISTNACEFROMLOCATION = "distanceFromLocation"
    static let LISTPOI = "listPOI"
    static let POI = "POI"
    static let NAMEPOI = "namePOI"
    static let COMMENTSPOI = "commentsPOI"
    static let TYPEPOI = "typePOI"
    static let RESTINGTIME = "restingTime"
    static let MIDWAY = "midWay"
    static let LATITUDEMIDWAY = "latitudeMidWay"
    static let LONGITUDEMIDWAY = "longitudeMidWay"
    static let ADDRESSSTARTPOINT = "addressStartPoint"
    static let ADDRESSFINISHPOINT = "addressFinishPoint"
    static let ROUTECOMPLEXITY = "routeComplexity"
    static let MIDDLEROUTEADDRESS = "middleRouteAddress"
    static let CIRCLEROUTE = "circleRoute"
    static let COURSE = "course"
    
    static let USERSTRACKS = "usersTracks"
    static let USER = "user"
    static let USERTRACKID = "userTrackId"
    static let USERDURATIONTRACKING = "userDurationTracking"
    static let USERDISTNACETRAVELED = "userDistanceTraveled"
    static let USERTRAVELEDPOINTS = "userTraveledPoints"
    static let USERPOINT = "userPoint"
    static let ONWAY = "onWay"
    static let USERLOCATION = "userLocation"
    static let USERLATITUDE = "userLatitude"
    static let USERLONGITUDE = "userLongitude"
    static let USERALTITUDE = "userAltitude"
    static let USERSPEED = "userSpeed"
    static let USERFLOOR = "userFloor"
    static let USERTIMESTAMP = "userTimeStamp"
    static let USERCOURSE = "userCourse"
    static let USERDISTANCEFROMLOCATION = "userDistanceFromLocation"
    static let USERLISTPOI = "userListPOI"
    static let USERPOI = "userPOI"
    static let USERNAMEPOI = "userNamePOI"
    static let USERCOMMENTSPOI = "userCommentsPOI"
    static let USERTYPEPOI = "userTypePOI"
    static let USERRESTINGTIMEPOI = "userRestingTimePOI"
    
}

enum BTDistanceZoom: Double {
    case ZoomUptoMinSpeed = 200
    case ZoomUptoAverageSpeed = 400
    case ZoomUptoMaxSpeed = 700
    case ZoomOverMaxSpeed = 1000
}