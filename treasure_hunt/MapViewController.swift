import UIKit
import MapKit
import CoreLocation
import AudioToolbox
import CoreData
import Canvas
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,PassValueDelegate{
    func RoleToMap(PassFirst: String) {
        
    }
    
    @IBOutlet var animViewInMap: CSAnimationView!
    
    @IBAction func ShakeMePressed(_ sender: Any) {
        animViewInMap.startCanvasAnimation()
    }
    
    @IBAction func BackPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    //Initial coredate context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imgeNameIndex:Int?
    weak var delegate:PassValueDelegate?
    var arrLatitude:[Double]=[0.0]
    var arrLongtitude:[Double]=[0.0]
    var imgRealName = ["PikachuTwo.ico","cutty.ico","elephant.ico","mouse.ico"]
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
        if TreasureCounter>1 || (treasureLatitude-finalLatitude<15 && treasureLongitude-finalLongitude<15){
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
    var clickCounter = 1
    //counter when click the screeen, update what pikachu said
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickCounter = clickCounter+1
        print("the times you touch screen is : ")
        print(clickCounter)
        self.myMap.delegate = self
        
        if clickCounter%5 == 1{
            objectAnnotation.title = "I wana be Home:Coding-Dojo!!!"
            
        }
        else if clickCounter%5 == 2{
            objectAnnotation.title = "GoGoGo,Where is my Treasure?"
        }
        else if clickCounter%5 == 3{
            objectAnnotation.title = "Pokemon Is Cool!"
        }
        else if clickCounter%5 == 4{
            objectAnnotation.title = "Secret Message! Jason feel hungry again!"
        }
        else if clickCounter%5 == 0{
            objectAnnotation.title = "I wanna learn more about iOS"
        }
    }
    
    //set up button "Jump" and "Stay"
    let longPressForActionSheet = UILongPressGestureRecognizer(target: self,action:#selector(getActionSheet))
    @IBAction func StayHere(_ sender: UIButton) {
        
        let longPressForActionSheet = UILongPressGestureRecognizer(target: self,action:#selector(getActionSheet))
            longPressForActionSheet.minimumPressDuration = 0.1
            myMap.addGestureRecognizer(longPressForActionSheet)
        if clickCounter%2 == 0{
           
            myMap.removeGestureRecognizer(longPressForActionSheet)
            //add new pin
            let longPressGestureRecogn = UILongPressGestureRecognizer(target: self, action:#selector(addAnnotation(press:)))
            longPressGestureRecogn.minimumPressDuration=0.2
            myMap.addGestureRecognizer(longPressGestureRecogn)
        }
       
    
}

    
    @IBAction func ChanePlace(_ sender: UIButton) {
        
        
    
        
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
        let objectAnnotation = CustomPointAnnotation()
        objectAnnotation.imageName = "\(imgRealName[imgeNameIndex!])"
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "ME"
        self.myMap.addAnnotation(objectAnnotation)
        
        
        
    }
    
    
    //MARK: if the locManager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed", error)
    }
    //declare mutiple pokemon pin
    class CustomPointAnnotation:MKPointAnnotation{
        var imageName: String!
    }
   var objectAnnotation = CustomPointAnnotation()
    var NPCOnePin = CustomPointAnnotation()
    var NPCTwoPin = CustomPointAnnotation()
    
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
        longPressGestureRecogn.minimumPressDuration=0.2
        myMap.addGestureRecognizer(longPressGestureRecogn)
        self.myMap.delegate = self
        
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(finalLatitude, finalLongitude)
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.imageName = "\(imgRealName[imgeNameIndex!])"
        objectAnnotation.title = "Go Go Go~ Where is my treasure?"
        self.myMap.addAnnotation(objectAnnotation)
       
        
        let NPCOnepinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(40, -74)
        NPCOnePin.coordinate = NPCOnepinLocation
        NPCOnePin.imageName = "NPCOne.ico"
        NPCOnePin.title = "Hi,I am a NPC..."
        NPCOnePin.subtitle = "Good Morning,Good Afternoon and Good Evening"
        self.myMap.addAnnotation(NPCOnePin)
        
        let NPCTwopinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37, -122)
        NPCTwoPin.coordinate = NPCTwopinLocation
        NPCTwoPin.imageName = "batgirlTwo.png"
        NPCTwoPin.title = "Wana Date With Me ?"
        NPCTwoPin.subtitle = ""
        self.myMap.addAnnotation(NPCTwoPin)
        }
    

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay:overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation){
           print("NOT REGISTERED AS MKPOINTANNOTATION")
            return nil
            
        }
        var annotationView = myMap.dequeueReusableAnnotationView(withIdentifier: "pokemonIdentifier")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation,reuseIdentifier: "pokemonIdentifier")
            annotationView?.canShowCallout = true
        }
        else{
            annotationView?.annotation = annotation
        }
        let Jason = annotation as! CustomPointAnnotation
        annotationView!.image = UIImage(named: Jason.imageName)
        return annotationView
    }
    
    //a func to declare action sheet
    @objc func getActionSheet(sender: UIButton ){
        //decalre the action sheet
        
        let title = "Action sheet title"
        let message = "action sheet message"
        
        
        let optionalFourText = "Cancel"
        //decalre the actionsheet
        let actionSheet = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.actionSheet)
        let ViewStatusActionSheet = UIAlertController(title: "Pokemon Attribute", message: "Intelegent : 10            Health:10          Sight:10",preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let actionFour = UIAlertAction(title: optionalFourText, style: .default, handler: nil)
        // declare a specific action
        let ViewAction = UIAlertAction(title: "ViewStatus", style: .default) { (handler) in
            
            self.present(ViewStatusActionSheet,animated: true,completion: nil)
        }
        let EditAction = UIAlertAction(title: "Search Around", style: .default) { (handler) in
            self.TreasureCounter = self.TreasureCounter+1
           
            //call Coredate to save numbers of treasure box
            let thing = NSEntityDescription.insertNewObject(forEntityName: "PokemonEntity", into: self.managedObjectContext) as! PokemonEntity
            thing.entitycounter = Int16(self.TreasureCounter)
            
           
            
            
            
            
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                    
                    print("Success : \(thing)")
                } catch {
                    print("\(error)")
                }
            }
        }
        let DeleteAction = UIAlertAction(title: "Call Jason", style: .default) { (handler) in
            
            
            
        }
        //call the action
        actionSheet.addAction(ViewAction)
        actionSheet.addAction(EditAction)
        actionSheet.addAction(DeleteAction)
        actionSheet.addAction(actionFour)
        ViewStatusActionSheet.addAction(actionFour)
        //present the whole actionsheet
               self.present(actionSheet, animated: true, completion: nil)
    }
  var TreasureCounter = 1
    var EntityInMapView = [PokemonEntity]()
    @objc func addAnnotation(press:UILongPressGestureRecognizer){
        if press.state == .began {
            let location = press.location(in: myMap)
            let coordinates = myMap.convert(location, toCoordinateFrom: myMap)
            dest1 = coordinates
            let annotation = CustomPointAnnotation()
            annotation.coordinate = coordinates
            annotation.imageName = "\(imgRealName[imgeNameIndex!])"
            annotation.title = "No, I should Go back to Coding......"
            annotation.subtitle = ""
            
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

