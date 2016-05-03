//
//  BTTrackingRouteViewController.swift
//  Bicycle Tracker
//
//  Created by kkolontay on 3/25/16.
//  Copyright © 2016 imvimm. All rights reserved.
//

import MapKit

protocol  BTTrackingRouteViewOutput: class {
    func pressStartStopButton(stringAction: String)
}
protocol  BTTrackingRouteViewInput {
    func fetchedSourceTrack(points: [CLLocationCoordinate2D])
    func fetchPowerSignal(alert: Bool)
    func setRegion(region: MKCoordinateRegion, course: Double)
    func setSpeedText(text: NSString)
    func setDistanceText(text: NSString)
   

}

class BTTrackingRouteViewController: UIViewController {
    struct LocalConstants {
        static let zeroSpeedCounterPlaceholderString = "0.0"
        static let zeroTimerCounterPlaceholderString = "00:00"
        static let zeroDistanceCounterPlaceholderString = "0.0"
        static let polylineWidth: CGFloat = 3
        static let minutesInHour: Double = 60.0
    }
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIBarButtonItem!
    @IBOutlet weak var speedLabel: UILabel!

    @IBOutlet weak var mapView: MKMapView!
    private weak var presenter: BTTrackingRouteViewOutput?
    private  var polylinePoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var timer: NSTimer?
    private var alertPoorSignal: BTProgressActivityIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        alertPoorSignal = BTProgressActivityIndicator()
         UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
    }
    
    @IBAction func pressedStartStopButton(sender: AnyObject) {
        
        if startStopButton.title == "Start" {
            startTimer()
            cancelButton.enabled = false
            startStopButton.title = "Stop"
        } else {
            stopTimer()
            cancelButton.enabled = true
            startStopButton.title = "Start"
            setSpeedText("0")
        }
        presenter?.pressStartStopButton(startStopButton.title!)
    }
    @IBAction func backToParentController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    func setPresetner(itemPresenter: BTTrackingRouteViewOutput) {
        presenter = itemPresenter
    }
    func makePolynile() {
        self.mapView.addOverlay(MKPolyline(coordinates: &polylinePoints, count: polylinePoints.count))
        
        var zoomRect: MKMapRect = MKMapRectNull
        for point:CLLocationCoordinate2D in polylinePoints {
            let center: MKMapPoint = MKMapPointForCoordinate(point)
            let rect: MKMapRect = MKMapRectMake(center.x - 40, center.y - 40, 40 * 2, 40 * 2)
            zoomRect = MKMapRectUnion(zoomRect, rect)
        }
        
        zoomRect = self.mapView.mapRectThatFits(zoomRect)
        self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(10, 10, 10, 10), animated: true)
    }
    func startTimer() {
        timeLabel.text = LocalConstants.zeroTimerCounterPlaceholderString
        if timer != nil {
            timer!.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimerCounter", userInfo: NSDate(), repeats: true)
    }
    
    func stopTimer() {
        timer!.invalidate()
        // we can add additional functionality such as clear counter and so on on demand later (depending on Bicycle Tracker app functionality, logic and UI)
    }
    
    func updateTimerCounter() {
        var elapsedTime = -(self.timer!.userInfo as! NSDate).timeIntervalSinceNow
        
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
        timeLabel.text = "\(strMinutes):\(strSeconds)"
    }

    
}

extension BTTrackingRouteViewController: BTTrackingRouteViewInput {
    func fetchedSourceTrack(points: [CLLocationCoordinate2D]) {
        polylinePoints = points
    }
    func setSpeedText(text: NSString) {
        speedLabel.text = String(text)
    }
    
    func setDistanceText(text: NSString) {
        distanceLabel.text = String(text)
    }
    func fetchPowerSignal(alert: Bool) {
        if alert && startStopButton.title == "Start" {
            alertPoorSignal?.startAnimation()
            startStopButton.enabled = false
        } else {
            alertPoorSignal?.stopAnimation()
            startStopButton.enabled = true
        }
    }
   func setRegion(region: MKCoordinateRegion, course: Double) {
        let camera = MKMapCamera()
        camera.centerCoordinate = coordinateFromCoord(region.center, distanceKm: 0.2, bearingDegrees: course)
        camera.heading = course
        camera.pitch = 80
        camera.altitude = 150

        mapView.setCamera(camera, animated: true)
        mapView.showsUserLocation = true
        //mapView.setRegion(region, animated: true)
    }
    
    func radiansFromDegrees(degrees: Double) -> Double {
    return degrees * (M_PI/180.0);
    }
    
    func degreesFromRadians(radians: Double) -> Double {
    return radians * (180.0/M_PI);
    }
    
    func coordinateFromCoord(fromCoord: CLLocationCoordinate2D,distanceKm: Double,bearingDegrees: Double) -> CLLocationCoordinate2D {
    let distanceRadians = distanceKm / 6371.0;
    //6,371 = Earth's radius in km
    let bearingRadians = radiansFromDegrees(bearingDegrees)
    let fromLatRadians = radiansFromDegrees(fromCoord.latitude)
    let fromLonRadians = radiansFromDegrees(fromCoord.longitude)
    
    let  toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
    + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    var toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
    * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
    - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    var result = CLLocationCoordinate2D()
    result.latitude = degreesFromRadians(toLatRadians)
    result.longitude = degreesFromRadians(toLonRadians)
    return result;
    }
}

extension BTTrackingRouteViewController: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        makePolynile()
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    if !overlay.isKindOfClass(MKPolyline) {
    return MKPolylineRenderer()
    }
    
    let polyline = overlay as! MKPolyline
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = Constants.blueCustomColor
    renderer.lineWidth = 8
    return renderer
    }

    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
       self.mapViewDidFinishLoadingMap(mapView)
    }
    
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//       // mapView.setCenterCoordinate(userLocation.coordinate, animated: false)
//        let camera = MKMapCamera()
//        camera.centerCoordinate = userLocation.coordinate
//        //camera.heading = course
////        camera.pitch =
//        camera.altitude = 100
//        mapView.setCamera(camera, animated: true)
//        mapView.showsUserLocation = true
//
//    }
   
    

}