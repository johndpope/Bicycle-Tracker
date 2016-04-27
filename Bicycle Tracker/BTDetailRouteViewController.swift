//
//  BTDetailRouteViewController.swift
//  Bicycle Tracker
//
//  Created by imvimm on 2/19/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import MapKit

class BTDetailRouteViewController: UIViewController {
   
   struct LocalConstants {
      static let mapViewRectDelta: Double = 200 // Used for margins from polyline to the end of the display area
      static let mapRectInset = UIEdgeInsetsMake(10, 10, 10, 10)
      static let polylineWidth: CGFloat = 3
      static let startPinImageName = "start_pin_icon.png"
      static let finishPinImageName = "finish_pin_icon.png"
   }
   
   var presenter : BTDetailRouteViewPresenter?
   var interactor : BTDetailRouteViewInteractor?
   var polylinePoints : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
   var route: BTDetailRouteUpcomingDisplayItem!
   var shareBarButtonItem: UIBarButtonItem?
   @IBOutlet weak var viewMap: MKMapView!
   @IBOutlet weak var tableView: UITableView!
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      viewMap.delegate = self
      shareBarButtonItem = UIBarButtonItem(title: "Share", style: .Plain, target: self, action: "actionShareButtonPressed")
      self.navigationItem.setRightBarButtonItem(shareBarButtonItem, animated: true)
      self.navigationController?.navigationBar.barTintColor = Constants.blueCustomColor
      self.navigationController?.navigationBar.translucent = false
      self.navigationItem.title = "Route details"
      self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
      self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
      presenter?.setupView()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        presenter = nil
        interactor = nil
    }
   
   // MARK: Actions
   func actionShareButtonPressed() {
      presenter?.didTriggerShareButtonTapped()
   }
   
   func makePolynile() {
      viewMap.addOverlay(MKPolyline(coordinates: &polylinePoints, count: polylinePoints.count))
      
      var zoomRect: MKMapRect = MKMapRectNull
      for point:CLLocationCoordinate2D in polylinePoints {
         let center: MKMapPoint = MKMapPointForCoordinate(point)
         let rect: MKMapRect = MKMapRectMake(center.x - LocalConstants.mapViewRectDelta, center.y - LocalConstants.mapViewRectDelta, LocalConstants.mapViewRectDelta * 2, LocalConstants.mapViewRectDelta * 2)
         zoomRect = MKMapRectUnion(zoomRect, rect)
      }
      
      zoomRect = self.viewMap.mapRectThatFits(zoomRect)
      self.viewMap.setVisibleMapRect(zoomRect, edgePadding: LocalConstants.mapRectInset, animated: true)
   }
}

extension BTDetailRouteViewController: UITableViewDataSource {
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 4
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell: UITableViewCell
      
      switch indexPath.row {
      case 0:
         cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath)
         cell.textLabel?.text = self.route.name
      case 1:
         cell = tableView.dequeueReusableCellWithIdentifier("DistanceCell", forIndexPath: indexPath)
         cell.textLabel?.text = String("Distance: \(self.route.length!) miles")
      case 2:
         cell = tableView.dequeueReusableCellWithIdentifier("TimeCell", forIndexPath: indexPath)
         cell.textLabel?.text = String("Time: \(self.route.duration!) minutes")
      case 3:
         cell = tableView.dequeueReusableCellWithIdentifier("HeightCell", forIndexPath: indexPath)
         cell.textLabel?.text = String("Height difference: \(self.route.heightDifference!) feet")
      default:
         cell = tableView.dequeueReusableCellWithIdentifier("SimpleCell", forIndexPath: indexPath)
      }
      
      return cell
   }
}

// MARK: - MKMapViewDelegate
extension BTDetailRouteViewController: MKMapViewDelegate {
   func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
      if !overlay.isKindOfClass(MKPolyline) {
         return nil
      }
      
      let polyline = overlay as! MKPolyline
      let renderer = MKPolylineRenderer(polyline: polyline)
      renderer.strokeColor = Constants.blueCustomColor
      renderer.lineWidth = LocalConstants.polylineWidth
      return renderer
   }
   
   func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
      if !(annotation is CustomPointAnnotation) {
         return nil
      }
      
      let reuseId = "pin"
      
      var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
      if anView == nil {
         anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
         anView!.canShowCallout = true
      }
      else {
         anView!.annotation = annotation
      }
      
      //Set annotation-specific properties **AFTER**
      //the view is dequeued or created...
      
      let cpa = annotation as! CustomPointAnnotation
      anView!.image = UIImage(named:cpa.imageName)
      anView?.centerOffset = CGPointMake(0, -10)
      
      return anView
   }
}

// MARK: - BTDetailRouteViewInput
extension BTDetailRouteViewController: BTDetailRouteViewInput {
   func setupDetailRouteViewWithRoute(route: BTDetailRouteUpcomingDisplayItem) {
      self.route = route
      let isScreenShot = route.screenShot?.isEmpty
      if isScreenShot!  {
         let spinner = BTProgressActivityIndicator()
         self.view.addSubview(spinner.getIndicator())
         spinner.startAnimation()
         shareBarButtonItem?.enabled = false
         let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
         dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            spinner.stopAnimation()
            self.shareBarButtonItem?.enabled = true
         })
      }
      
      polylinePoints = self.route.listOfPoints
      makePolynile()
      
      let routeStart = CustomPointAnnotation()
    if polylinePoints.first != nil {
      routeStart.coordinate = polylinePoints.first!
    }
      routeStart.imageName = LocalConstants.startPinImageName
      viewMap.addAnnotation(routeStart)
      
      let routeFinish = CustomPointAnnotation()
      routeFinish.coordinate = polylinePoints.last!
      routeFinish.imageName = LocalConstants.finishPinImageName
      viewMap.addAnnotation(routeFinish)
   }
   
   func showShareActivityViewWithActivityItems(activityItems: [AnyObject]) {
      let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
      presentViewController(activityVC, animated: true, completion: nil)
   }
}

class CustomPointAnnotation: MKPointAnnotation {
   var imageName: String!
}