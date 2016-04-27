//
//  BTRouteListViewOutput.swift
//  Bicycle Tracker
//
//  Created by Plumb on 2/17/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import Foundation

protocol BTRouteListViewOutput: class {
    func setupView()
    func numberOfSections() -> Int
    func numberOfRoutes(inSection section: Int) -> Int
    func setContentToView(view: BTRouteListItemViewProtocol, indexPath: NSIndexPath)
    func didTriggerTapGoRideButton()
    func didTriggerTapCell(atIndexPath indexPath: NSIndexPath)
    func didTriggerSearchBarButtonTappedWithText(text: String, difficultySegmentControllIndex: Int)
}
