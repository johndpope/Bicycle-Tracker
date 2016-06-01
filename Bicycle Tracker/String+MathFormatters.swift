//
//  String+MathFormatters.swift
//  Bicycle Tracker
//
//  Created by Plumb on 3/10/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

extension String {
    static func formattedSpeed(speed: Double) -> String {
        let milesPerHour = speed * Constants.metersPerSecond
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter.stringFromNumber(milesPerHour)!
    }
    
    static func formattedDistance(distance: Double) -> String {
        let distanceInMiles = distance * Constants.metersInOneMile
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.stringFromNumber(distanceInMiles)!
    }
    
    static func formattedDuration(duration: Double) -> String {
        var tmpDuration = duration
        
        let minutes = UInt8(tmpDuration / 60.0)
        tmpDuration -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(tmpDuration)
        tmpDuration -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        return "\(strMinutes):\(strSeconds)"
    }
   
   static func formattedHeightDifference(heightDifference: Double) -> String {
      return String(heightDifference)
   }
}
