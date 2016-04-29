//
//  BTNewRouteViewController.swift
//  Bicycle Tracker
//
//  Created by imvimm on 2/17/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import MapKit

class BTNewRouteViewController: UIViewController {
   
   struct LocalConstants {
      static let zeroSpeedCounterPlaceholderString = "0.0"
      static let zeroTimerCounterPlaceholderString = "00:00"
      static let zeroDistanceCounterPlaceholderString = "0.0"
      static let polylineWidth: CGFloat = 3
      static let minutesInHour: Double = 60.0
   }
   
    var  presenter : BTNewRoutePresenter?
   var interactor : BTNewRouteInteractor?
   var currentPoint : CLLocationCoordinate2D?
   var polylinePoints : [CLLocationCoordinate2D]?
   var polyline: MKPolyline?
   var currentRegion: MKCoordinateRegion?
   var timer = NSTimer()
   var startTime = NSTimeInterval()
   private var alertPoorSignal: BTProgressActivityIndicator?
   
   @IBOutlet weak var labelSpeed: UILabel!
   @IBOutlet weak var labelTime: UILabel!
   @IBOutlet weak var labelDistance: UILabel!
   @IBOutlet weak var viewMap: MKMapView!
   @IBOutlet weak var listRoutsButton: UIBarButtonItem!
   @IBOutlet weak var stopStartButton: UIBarButtonItem!
   
// MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      viewMap.delegate = self
     // presenter = BTNewRoutePresenter()
      presenter?.userInterface = self
     // interactor = BTNewRouteInteractor()
      presenter?.outdoorInteractor = interactor
      interactor?.setPresenterDelegate(presenter!)
      listRoutsButton.enabled = true
      alertPoorSignal = BTProgressActivityIndicator()
      polylinePoints = [CLLocationCoordinate2D]()
      view.addSubview((alertPoorSignal?.getIndicator())!)
      self.navigationController?.navigationBar.barTintColor = Constants.blueCustomColor
      self.navigationController?.navigationBar.translucent = false
      self.navigationItem.title = "My route"
      self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
      self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
      labelDistance.text = LocalConstants.zeroDistanceCounterPlaceholderString
      labelSpeed.text = LocalConstants.zeroSpeedCounterPlaceholderString
      labelTime.text = LocalConstants.zeroTimerCounterPlaceholderString
   }
   
   override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
    }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
// MARK: - IBActions
   @IBAction func actionStartButtonPressed(sender: UIBarButtonItem) {
      if sender.title == "Start" {
         if polyline != nil {
            viewMap.removeOverlays(viewMap.overlays)
         }
        if presenter == nil {
            self.viewDidLoad()
        }
         presenter?.startRouteAction()
         startTimer()
         sender.title = "Stop"
         listRoutsButton.enabled = false
         polylinePoints = [CLLocationCoordinate2D]()
         viewMap.reloadInputViews()
      } else {
         stopTimer()
         sender.title = "Start"
         setSpeedText(LocalConstants.zeroSpeedCounterPlaceholderString)
         listRoutsButton.enabled = true
         presenter?.stopRouteAction()
      }
   }
    
    @IBAction func segueRouteListView(sender: AnyObject) {
        if presenter == nil {
            self.viewDidLoad()
        }
        presenter!.segueRouteListController()
    }
   // MARK: - Private
   func startTimer() {
      labelTime.text = LocalConstants.zeroTimerCounterPlaceholderString
      timer.invalidate()
      timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimerCounter", userInfo: NSDate(), repeats: true)
   }
   
   func stopTimer() {
      timer.invalidate()
      // we can add additional functionality such as clear counter and so on on demand later (depending on Bicycle Tracker app functionality, logic and UI)
   }
   
   func updateTimerCounter() {
      var elapsedTime = -(self.timer.userInfo as! NSDate).timeIntervalSinceNow
      
      //calculate the minutes in elapsed time.
      let minutes = Int((elapsedTime / LocalConstants.minutesInHour))
      elapsedTime -= (NSTimeInterval(minutes) * LocalConstants.minutesInHour)
      
      //calculate the seconds in elapsed time.
      let seconds = Int(elapsedTime)
      elapsedTime -= NSTimeInterval(seconds)
      
      //add the leading zero for minutes, seconds and store them as string constants
      let strMinutes = String(format: "%02d", minutes)
      let strSeconds = String(format: "%02d", seconds)
      
      //concatenate minuets, seconds as assign it to the UILabel
      labelTime.text = "\(strMinutes):\(strSeconds)"
   }
}

// MARK: - MKMapViewDelegate
extension BTNewRouteViewController: MKMapViewDelegate {
   func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
      if !overlay.isKindOfClass(MKPolyline) {
         return MKOverlayRenderer()
      }
      
      polyline = overlay as? MKPolyline
      let renderer = MKPolylineRenderer(polyline: polyline!)
      renderer.strokeColor = Constants.blueCustomColor
      renderer.lineWidth = LocalConstants.polylineWidth
      return renderer
   }
   
   func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
      viewMap.setCenterCoordinate(userLocation.coordinate, animated: false)
   }
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        if let coordinate = currentRegion?.center {
            viewMap.setCenterCoordinate(coordinate, animated: false)
        }
    }
}

// MARK: - BTNewRouteViewInput
extension BTNewRouteViewController: BTNewRouteViewInput {
   func setSpeedText(text: NSString) {
      labelSpeed.text = String(text)
   }
   
   func setTimeText(text: NSString) {
      labelTime.text = String(text)
   }
   
   func setDistanceText(text: NSString) {
      labelDistance.text = String(text)
   }
   
   func setCurrentCoordinate(currentCoordinate: CLLocationCoordinate2D) {
      currentPoint = currentCoordinate
      self.viewMap.showsUserLocation = true
   }
   
   func makePolynileWithCoordinates(lastPosition: CLLocationCoordinate2D, currentPosition: CLLocationCoordinate2D) {
      polylinePoints = [lastPosition, currentPosition]
      
      if polylinePoints != nil {
         viewMap.addOverlay(MKPolyline(coordinates: &polylinePoints!, count: polylinePoints!.count))
      }
   }
    
   
   func setRegionForStartPoin(region: MKCoordinateRegion) {
      currentRegion = region
      
      if currentRegion != nil {
         viewMap.setRegion(currentRegion!, animated: false)
         viewMap.showsUserLocation = true
      }
   }
   
   func fetchingAlertPoorSatelitsSignal(signal: Bool) {
      if signal && stopStartButton.title == "Start" {
         alertPoorSignal?.startAnimation()
         stopStartButton.enabled = false
      } else {
         alertPoorSignal?.stopAnimation()
         stopStartButton.enabled = true
      }
   }
}