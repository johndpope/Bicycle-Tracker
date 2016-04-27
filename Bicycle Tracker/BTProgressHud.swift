//
//  BTProgressHud.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/5/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit

class BTProgressActivityIndicator: NSObject  {
    private var spinner: UIActivityIndicatorView?
    
    override init() {
        super.init()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
         spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner!.center = CGPointMake(screenSize.width/2, screenSize.height/2)
        spinner!.tag = 12
        spinner!.transform = CGAffineTransformMakeScale(3, 3)
    }
    
    func getIndicator() -> UIActivityIndicatorView {
        return spinner!
    }
    
    func stopAnimation() {
        spinner!.stopAnimating()
    }
    
    func startAnimation() {
        spinner!.startAnimating()
    }

}