//
//  BTDetailViewInteractor.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 2/19/16.
//  Copyright © 2016 imvimm. All rights reserved.
//


import UIKit
import Foundation
import MapKit

protocol BTDetailRouteViewInteractorInput {
    
    // set detailrout presenter interfase
    func setDetailRoutePresenter(detailPresenter: BTDetailRouteViewInteractorOutput)
    
    
    //query detail information about track of id
    func queryDetailTrack(trackID: Int)
    
  }

protocol BTDetailRouteViewInteractorOutput: class {
    
    //get all data from requested track
    func getDetailTrack(item: BTTrackItem)
}

class BTDetailRouteViewInteractor: NSObject {
    
   private  weak var presenter: BTDetailRouteViewInteractorOutput?
    private var detailRoute: BTTrackItem?
    private var parser: BTXMLParserModuleOutput?
    private var itemsTrack: [BTTrackItem]?
    private var itemData: BTXMLDocumentWriterModuleIncoming?
    
    override init() {
        parser = BTXMLParser(nameFile: nil)
        super.init()
         setFetchDataToItem(BTXMLDocumentWriter(nameFile: nil))
       
    }
    
    //set parser
    func setParser(pars: BTXMLParserModuleOutput?) {
        parser = pars
    }
    
    //set link on xml writer into file
    func setFetchDataToItem(item: BTXMLDocumentWriterModuleIncoming) {
        itemData = item
    }
    
    //create screen shot for trackers
    private func createScreenShot(itemTrack: BTTrackItem) {
       itemsTrack?.removeLast()
        var item: BTTrackItem = itemTrack
        var dateString: String {
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = BTConstant.DAYFORMATED
            return dateFormater.stringFromDate(NSDate())
        }
        
        // set file name
        let fileName = "screenshot" + dateString + ".png"
       item.nameFileScreenShotRoute = fileName
        itemsTrack?.append(item)
        
        //search needed view controller for screen shot
        let window = UIApplication.sharedApplication().delegate?.window
        let nawController = window!!.rootViewController as! UINavigationController
    
        var contr: BTDetailRouteViewController?
      for  controller in nawController.viewControllers {
            if controller is BTDetailRouteViewController {
        contr = controller as? BTDetailRouteViewController
           }
       }
        var imgData: NSData?
        var view: MKMapView!
        if contr != nil {
         view = contr!.viewMap
        
            
            //get data for picture
        UIGraphicsBeginImageContext((view.frame.size))
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        imgData = UIImagePNGRepresentation(image)
        }
        
        var path: String?
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first {
            path = dir.stringByAppendingPathComponent(fileName)
            
            if !NSFileManager.defaultManager().fileExistsAtPath(path!) {
                NSFileManager.defaultManager().createFileAtPath(path!, contents: nil, attributes: nil )
            }
        }
        
        // save data into file
        if (imgData != nil) {
            imgData?.writeToFile(path!, atomically: true)
        }
        
        // save track into xml file
        itemData?.saveTracks(itemsTrack!)
        
        //get track to presenter
        presenter?.getDetailTrack((itemsTrack?.last)!)
       
        
    }
}



extension BTDetailRouteViewInteractor: BTDetailRouteViewInteractorInput {
    
    //set presenter interface
    func setDetailRoutePresenter(detailPresenter: BTDetailRouteViewInteractorOutput) {
        presenter = detailPresenter
    }

    //get from xml file required track for presenter
    func queryDetailTrack(trackID: Int) {
         itemsTrack = (parser?.parserDocument())!
        if trackID == BTConstant.JUMPTONEWDATA {
            if itemsTrack?.last != nil {
             presenter?.getDetailTrack((itemsTrack?.last)!)
            }
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.createScreenShot((self.itemsTrack?.last)!)
            })
            
            
            
        } else {
        for item in itemsTrack! {
            if trackID == item.trackId {
                detailRoute = item
            }
        }
        if detailRoute != nil {
            presenter?.getDetailTrack(detailRoute!)
        }
        }
    }
}