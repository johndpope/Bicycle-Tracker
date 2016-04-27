//
//  BTRouteListIteractor.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 2/18/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation


protocol BTRouteListInteractorOutput: class {
    
    //get array of tracks, which was required
    func fetchArrayTrack() -> [BTTrackItem]
}

protocol BTRouteListInteractorInput {
    
    // set presenter into class of interface
    func setPresenterDelegate(presenter: BTRouteListPresenter)
}
class BTRouteListInteractor: NSObject {
    private var presenter: BTRouteListPresenter?
    private var getDataParser: BTXMLParserModuleOutput?
    private var locationManager: BTLocationManagerInput
    
    override init() {
        locationManager =  BTLocationManager.sharedInstances
        super.init()
        locationManager.startLocation()
        //set link on parser
        setXMLParser(BTXMLParser(nameFile: nil))
    }
    
    // link on parser
    func setXMLParser(item: BTXMLParserModuleOutput) {
        getDataParser = item
    }
    
    //set link to presenter
    func setPresenterDelegate(presenter: BTRouteListPresenter) {
        self.presenter = presenter
    }
    
}

extension  BTRouteListInteractor: BTRouteListInteractorOutput {
    
    // get all objects from xml file
    func fetchArrayTrack() -> [BTTrackItem] {
        if getDataParser != nil {
            getDataParser = nil
            setXMLParser(BTXMLParser(nameFile: nil))
        }
        return (getDataParser?.parserDocument())!
    }
    
   }