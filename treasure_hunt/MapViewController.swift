//
//  ViewController.swift
//  treasure_hunt
//
//  Created by Rachel Ng on 1/18/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AudioToolbox

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var arrLatitude:[Double]=[0.0]
    var arrLongtitude:[Double]=[0.0]
    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var digButton: UIButton!
    //declare soundManager
    var soundManager = SoundManager()
    
    @IBAction func ShowTheDirection(_ sender: UIButton) {
        
        //Getting Directions between two position
        if CLLocationManager.locationServicesEnabled(){
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            
        }
        
        let sourceCoordinates = CLLocationCoordinate2DMake(finalLatitude, finalLongitude)
        let destCoordinates = dest1
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates)
        let destPlacemark = MKPlacemark(coordinate:destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response,error in
            
            guard let response = response else {
                if error != nil {
                    print ("Something went Wrong")
                }
                return
            }
            let route = response.routes[0]
            self.myMap.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.myMap.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            
        })
        finalLatitude=dest1.latitude
        finalLongitude=dest1.longitude
    }
    @IBAction func digButtonPressed(_ sender: UIButton) {
 
        //GO TO Result View
        if treasureLatitude-finalLatitude<15 && treasureLongitude-finalLongitude<15{
            performSegue(withIdentifier: "gotWinner", sender: sender)
        }
        
        //GO TO HINT View
              else{ performSegue(withIdentifier: "needHint", sender: sender)
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "needHint" {
            let hintViewController = segue.destination as! HintViewController
            let message = "You are too far away!"
            hintViewController.message = message
        }
    }
    
    //MARK: Creating the instance of the CLLocationManagerClass
    @objc let locManager = CLLocationManager()
    let testnumb:Double=1.1
    //Coding-dojo Burbank adrress
    var finalLatitude:Double = 34.1810714596047
    var finalLongitude:Double = -118.309393896266
    //temp store new pin position
    var dest1: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    
    //treasure location
    // -124 to -81
    let treasureLatitude = Double(arc4random_uniform(20) + 30) + drand48()
    let treasureLongitude = -1 * Double(arc4random_uniform(44) + 81) + drand48()
    //set up the timer and interval
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self,  selector:(#selector(MapViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        locManager.startUpdatingLocation()
        locManager.stopUpdatingLocation()
        seconds -= 1     //This will decrement(count down)the seconds.
       
    }
    //set up button "Jump" and "Stay"
    @IBAction func StayHere(_ sender: UIButton) {
        locManager.stopUpdatingLocation()
        
    }

    
    @IBAction func ChanePlace(_ sender: UIButton) {
        locManager.startUpdatingLocation()
       
        //add timer if we need it
        //runTimer()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let singleLoc = locations[0]
       
        //Get user location updates
        arrLatitude.append(singleLoc.coordinate.latitude)
        arrLongtitude.append(singleLoc.coordinate.longitude)
      
        
        finalLatitude=arrLatitude[arrLongtitude.count-1]+Double(arc4random_uniform(11))
        finalLongitude=arrLongtitude[arrLongtitude.count-1]+Double(arc4random_uniform(11))
      
        //move the map
        myMap.centerCoordinate = CLLocationCoordinate2DMake(finalLatitude, finalLongitude)
       //set pin animation
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(finalLatitude, finalLongitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "ME"
        self.myMap.addAnnotation(objectAnnotation)
        
        
        
    }
    
    
    //MARK: if the locManager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed", error)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //show compass and so on
        myMap.showsCompass = true
        myMap.showsScale = true
        myMap.showsTraffic = true
        
        myMap.showsPointsOfInterest = true
        //MARK: LocationManager Setup
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        
        
        
        //MARK: Cam Setup
        myMap.delegate = self
        let cam = MKMapCamera()
        cam.altitude = 30000
        myMap.camera = cam
        //intial location to coding-dojo
        myMap.centerCoordinate = CLLocationCoordinate2DMake(finalLatitude, finalLongitude)
        
      
        //add new pin
        let longPressGestureRecogn = UILongPressGestureRecognizer(target: self, action:#selector(addAnnotation(press:)))
        longPressGestureRecogn.minimumPressDuration=0.5
        myMap.addGestureRecognizer(longPressGestureRecogn)
        
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(finalLatitude, finalLongitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "I am at Home:Coding-Dojo"
        self.myMap.addAnnotation(objectAnnotation)
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay:overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
    
    @objc func addAnnotation(press:UILongPressGestureRecognizer){
        if press.state == .began {
            let location = press.location(in: myMap)
            let coordinates = myMap.convert(location, toCoordinateFrom: myMap)
            dest1 = coordinates
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "New of Me"
            annotation.subtitle = "HI"
            
            myMap.addAnnotation(annotation)
        }
    }
    
    
    
  
    override func viewDidAppear(_ animated: Bool) {
        //soundManager.playSound(.rain)
        locManager.stopUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        soundManager.stopSound()
        locManager.stopUpdatingLocation()
    }

}

