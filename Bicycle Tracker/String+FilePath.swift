//
//  String+FilePath.swift
//  Bicycle Tracker
//
//  Created by Plumb on 3/10/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

extension String {
    static func screenshotDataFilePath(named: String) -> String {
       let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
       return dir.stringByAppendingPathComponent(named)
    }
}
