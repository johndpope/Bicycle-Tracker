//
//  BTRouteListViewController.swift
//  Bicycle Tracker
//
//  Created by Plumb on 2/16/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import UIKit

class BTRouteListViewController: UIViewController {
   
   struct LocalConstants {
      static let tableViewRowHeight: CGFloat = 57
   }
   
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var segmentedControl: UISegmentedControl!
   
   weak var output: BTRouteListViewOutput?
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      // setup VIPER components
      let pres = BTRouteListPresenter()
      let interactor = BTRouteListInteractor()
      pres.interactor = interactor
      interactor.setPresenterDelegate(pres)
      pres.view = self
      output = pres
      // configure view
      tableView.rowHeight = LocalConstants.tableViewRowHeight
      let goRideBarButton = UIBarButtonItem(title: "Go Ride", style: .Plain, target: self, action: "goRideButtonTapped")
      self.navigationItem.setLeftBarButtonItem(goRideBarButton, animated: true)
      self.navigationController?.delegate = self
      self.navigationController?.navigationBar.barTintColor = Constants.blueCustomColor
      self.navigationController?.navigationBar.translucent = false
      self.navigationItem.title = "Routes list"
      self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
      self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
      output?.setupView()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
    
   
   // MARK: - IBActions
   @IBAction func segmentChanged(sender: UISegmentedControl) {
      output?.didTriggerSearchBarButtonTappedWithText(searchBar.text!, difficultySegmentControllIndex: segmentedControl.selectedSegmentIndex)
   }
   
   func goRideButtonTapped() {
      output?.didTriggerTapGoRideButton()
   }
}

// MARK: - UITableViewDataSource
extension BTRouteListViewController: UITableViewDataSource {
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return output!.numberOfRoutes(inSection: section)
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as! RouteCell
      self.output?.setContentToView(cell, indexPath: indexPath)
      return cell
   }
}

// MARK: - UITableViewDelegate
extension BTRouteListViewController: UITableViewDelegate {
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      output?.didTriggerTapCell(atIndexPath: indexPath)
   }
}

// MARK: - UISearchBarDelegate
extension BTRouteListViewController: UISearchBarDelegate {
   func searchBarSearchButtonClicked(searchBar: UISearchBar) {
      output?.didTriggerSearchBarButtonTappedWithText(searchBar.text!, difficultySegmentControllIndex: segmentedControl.selectedSegmentIndex)
   }
   
   func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
      return .TopAttached
   }
}

// MARK: - BTRouteListViewInput
extension BTRouteListViewController: BTRouteListViewInput {
   func reloadEntries () {
      tableView.reloadData()
   }
}

extension BTRouteListViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController is BTRouteListViewController {
        output?.setupView()
            tableView.reloadData()
        }
    }
}
