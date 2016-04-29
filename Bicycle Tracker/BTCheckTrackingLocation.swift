//
//  BTCheckTrackingLocation.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/30/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AVFoundation

class BTCheckTrakingLocation: NSObject {
    private var itemLocations: [BTGeolocationData]?
    private var alertSignalReturnPath: Int?
    private var alertSignalWrongWay: Int?
    private var audioPlayer: AVAudioPlayer?
    
    init(locations: [BTGeolocationData]) {
        super.init()
        itemLocations = locations
        alertSignalReturnPath = 0
        alertSignalWrongWay = 0
      // UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    func fetchCurrentLocation(location: BTGeolocationDataUser) -> Bool {
        var minDistance = 100.0
        var geolocationDataTrack: BTGeolocationData?
        for locationTrack in itemLocations! {
              let distance = getDistance(locationTrack.latitude!, longitudeFirstPoint: locationTrack.longitude!, latitudeSecondPoint: location.location.latitude!, longitudeSecondPoint: location.location.longitude!)
            if distance < 15 {
                if distance < minDistance {
                    minDistance = distance
                    geolocationDataTrack = locationTrack
                }
            }
        }
        let currentCourse = abs(location.location.course! - (geolocationDataTrack?.course ?? 0)!)
        if currentCourse > 120 && minDistance < 15 {
            alertSignalWrongWay = alertSignalWrongWay! + 1
            if alertSignalWrongWay > 3 {
                alertSignalWrongWay = 0
                alert("WrongWay")
            }
        } else {
            alertSignalWrongWay = 0
        }
        if minDistance < 15 {
            alertSignalReturnPath = 0
            return true
        }
        alertSignalReturnPath = alertSignalReturnPath! + 1
        if alertSignalReturnPath > 3 {
            alert("ReturnPath")
            alertSignalReturnPath = 0
        }
        return false
    }
    
    func alert(soundName: String) {
        let path = NSBundle.mainBundle().pathForResource(soundName, ofType: "m4a")
        let coinSound = NSURL(fileURLWithPath: path! )
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
             audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
             audioPlayer!.prepareToPlay()
             audioPlayer!.play()
        }catch {
            print("Error getting the audio file")
        }
    }
   
    func getDistance(latitudeFirstPoint: Double, longitudeFirstPoint: Double, latitudeSecondPoint: Double, longitudeSecondPoint: Double) -> Double {
        return CLLocation(latitude: latitudeFirstPoint, longitude: longitudeFirstPoint).distanceFromLocation(CLLocation(latitude: latitudeSecondPoint, longitude: longitudeSecondPoint))
    }
}