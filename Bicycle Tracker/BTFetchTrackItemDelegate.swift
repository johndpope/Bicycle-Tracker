//
//  BTFetchTrackItemDelegate.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 2/11/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

protocol BTXMLDocumentWriterModuleIncoming: class {
    
    //this function send information about track
    func getTrackDidFinish(track: BTTrackItem)
    
    //save all tracks
    func saveTracks(tracks: [BTTrackItem])
}
