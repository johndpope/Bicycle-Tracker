//
//  BTDetermineComplexityRoad.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/18/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

struct BTConstantValues {
    static let  WOMAN = "woman"
    static let MAN = "man"
    static let MANWEIGHT = 78.0
    static let WOMANWEIGHT = 60.0
    static let MEDIUM = "medium"
    static let HARD = "hard"
    static let EASY = "easy"
    static let THREHOLDMEDIUM = 15
    static let THREHOLDHARD = 25
    static let THREHOLDMAX = 30
    static let MAXPOINTHEIGHTDIFFERENCE = 13.0
    static let MAXPOINTDURATION = 6.0
    static let MAXPOINTLENGTHTRACK = 11.0
    static let ESTIMATEPOINTHEIGHTDIFFERENCE = 50
    static let ESTIMATEDURATION = 1800
    static let ESTIMATELENGHT = 2500
    
    
}

class BTDefinitionComplexity: NSObject {
    static func getComplexity( trackInfo: BTTrackItem, sex: String = BTConstantValues.MAN, weight: Double = BTConstantValues.MANWEIGHT) -> String {
        var ratioWeight: Double?
        if sex == BTConstantValues.MAN {
            ratioWeight = weight / BTConstantValues.MANWEIGHT
        } else {
            ratioWeight = weight / BTConstantValues.WOMANWEIGHT
        }

        if ratioWeight > 1.15 {
            ratioWeight = 1.15
        }
        if ratioWeight < 0.85 {
            ratioWeight = 0.85
        }
        var countPoints: Int
        let distancePoint = trackInfo.length! / Double(BTConstantValues.ESTIMATELENGHT)
        var zerro = 0.0
        var difraction: Double
        difraction = modf(distancePoint, &zerro)
        if distancePoint > BTConstantValues.MAXPOINTLENGTHTRACK {
            countPoints = Int(BTConstantValues.MAXPOINTLENGTHTRACK)
        } else {
            if difraction != 0.0 {
                countPoints = Int(distancePoint) + 1
            } else {
                countPoints = Int(distancePoint)
            }
        }
        
        let durationPoint = trackInfo.duration! / Double(BTConstantValues.ESTIMATEDURATION)
        if durationPoint > BTConstantValues.MAXPOINTDURATION {
            countPoints += Int(BTConstantValues.MAXPOINTDURATION)
        } else {
            difraction = modf(durationPoint, &zerro)
            if difraction != 0.0 {
                countPoints += Int(durationPoint) + 1
            } else {
                countPoints += Int(durationPoint)
            }
        }
        let differenceHeightPoint = trackInfo.heightDifference ?? 0 / Double(BTConstantValues.ESTIMATEPOINTHEIGHTDIFFERENCE)
        if differenceHeightPoint > BTConstantValues.MAXPOINTHEIGHTDIFFERENCE {
            countPoints += Int(BTConstantValues.MAXPOINTHEIGHTDIFFERENCE)
        } else {
            difraction = modf(differenceHeightPoint, &zerro)
            if difraction != 0.0 {
                countPoints += Int(differenceHeightPoint) + 1
            } else {
                countPoints += Int(differenceHeightPoint)
            }
        }
        let points = Double(countPoints) * ratioWeight!
        if points < 15 {
            return BTConstantValues.EASY
        } else if points < 25 {
            return BTConstantValues.MEDIUM
        }
        return BTConstantValues.HARD
    }
    
    static func setMidWay(trackItem: BTTrackItem) -> BTLocationMidWay {
        var itemMidWay = BTLocationMidWay()
        let midPoint = (trackItem.length ?? 1) / 2
        var distance = 0.0
        for  itemLocation in trackItem.listLocations {
            let location = itemLocation as BTGeolocationData
            distance += location.distanceFromLocation ?? 0
            if distance >= midPoint {
                itemMidWay.latitudeMidWay = location.latitude
                itemMidWay.longitudeMidWay = location.longitude
                break
            }
        }
        return itemMidWay
    }
}