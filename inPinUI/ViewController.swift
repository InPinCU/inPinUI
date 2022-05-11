//
//  ViewController.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 1/15/22.
//
import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var restaurantCards: RestaurantCardsView!
    var restaurantList: [IndividualRestaurantViewModel]?
    var currentMapCenter: CLLocationCoordinate2D?
    
    /* MARK: Code for adding autocomplete */
    @IBAction func TopBarValueChanged(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.primaryTextColor = UIColor.lightGray
        acController.secondaryTextColor = UIColor.darkGray
        acController.primaryTextHighlightColor = UIColor.white
        acController.tableCellSeparatorColor = UIColor.darkGray
        acController.tableCellBackgroundColor = UIColor.black
        
        
           
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    struct Position: Decodable {
        let lat: Float64
        let long: Float64
        let avgLike: Float
        let name: String
    }
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes

        addressLabel.backgroundColor = searchBarGray
        addressLabel.textColor = UIColor.white
        mapView.setMinZoom(14, maxZoom: 20)
        let NYC = GMSCameraPosition.camera(
            withLatitude: 40.758896,
            longitude: -73.985130,
            zoom: 16
        )
        mapView.camera = NYC
        self.checkUsersLocationServicesAuthorization()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: MapConstants.styleURL)
        }
        catch {
            NSLog("Map Failed to load")
        }
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.currentMapCenter = NYC.target;
    }
    
    func checkUsersLocationServicesAuthorization(){
        /// Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                self.locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                // Disable location features
                let alert = UIAlertController(title: "Allow Location Access", message: "MyApp needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable features that require location services here.
                print("Full Access")
                break
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        print("Marker tapped")
        return true
    }
    
    func parseAPIRespone( data:Data?, response:URLResponse?, error:Error?){
        print("####################")
        if let httpResponse = response as? HTTPURLResponse {
            print("error \(httpResponse.statusCode)")
            guard httpResponse.statusCode == 200 else {
                parseMarkerData(data: mockData.data(using: .utf8)!)
                return
            }
        }
        print(error)
        guard error == nil else {
            return
        }
        guard let data = data else {
            return
        }
        parseMarkerData(data: data)
    }
    func makeMarkers(restaurants: [Restaurant]){
        DispatchQueue.main.async {
            self.mapView.clear()
            var i = 0
            self.restaurantList = []
            for pos in restaurants {
                let position = CLLocationCoordinate2D(latitude: pos.location.coordinates[1], longitude: pos.location.coordinates[0])
                let marker = GMSMarker(position: position)
                let restaurantCardElement = self.setupRestaurantCard(pos)
                marker.title = pos.name
                marker.icon = UIImage(named: MapConstants.iconMap[i] ?? "grey")
                marker.yelpID = pos.yelpId
                marker.setIconSize(scaledToSize: .init(width: 30, height: 48))
                marker.map = self.mapView
                self.restaurantList?.append(IndividualRestaurantViewModel(restaurant: pos, restaurantCardView: restaurantCardElement, restaurantMarker: marker))
                i+=1
            }
            
        }
    }
    func setupRestaurantCard(_ currentElement: Restaurant) -> RestauarantCard{
        let newRestaurantCard =  RestauarantCard(restaurantInfo: currentElement,frame:CGRect(x: 0, y: 0, width:179, height: 179))

        return newRestaurantCard
    }
    
    func parseMarkerData(data:Data){
        do {
            if let restaurants = try? JSONDecoder().decode([Restaurant].self,from:data){
                //                              print(restaurants)
                
//                self.restaurantList = restaurants
                makeMarkers(restaurants: restaurants)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func filterRestaurants(restaurants:[Restaurant]) -> [Restaurant]{
        var filteredRestaurantList:[Restaurant] = []
        let bounds:GMSCoordinateBounds = GMSCoordinateBounds.init(region: mapView.projection.visibleRegion())
        for restaurant in restaurants{
            
            if(bounds.contains(CLLocationCoordinate2D.init(latitude: restaurant.location.coordinates[1], longitude: restaurant.location.coordinates[0]))){
                filteredRestaurantList.append(restaurant)
            }
        }
        return filteredRestaurantList
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()
        let url  = "https://api.inpin.it/restaurants?lat="+String(coordinate.latitude)+"&long="+String(coordinate.longitude)+"&radius=200"
        //        print(mapView.projection.visibleRegion())
        
        APIRequestServie.getRequest(urlString: url, header: ["x-access-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MjMzMmU1NmU5Zjg2ZTUyOTE2MmM3MTkiLCJlbWFpbCI6ImpuX2FtYW5AeWFob28uY29tIiwiaWF0IjoxNjQ3NTIxNDU5LCJleHAiOjE2NTI3MDU0NTl9.JDkaoiyZLmVLS6rkGStASw7nzObuYUaGDWtiyTHqmKk"], parserFunction: parseAPIRespone)
        //      let url = URL(string: "https://bit.ly/3sspdFO")!
        //      let request = NSMutableURLRequest()
        //      request.url = url
        //      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        //            if let data = data {
        //                if let positions = try? JSONDecoder().decode([Position].self, from: data) {
        //                    print(positions)
        //                } else {
        //                    print("Invalid Response")
        //                }
        //            } else if let error = error {
        //                print("HTTP Request Failed \(error)")
        //            }
        //        }
        //      task.resume()
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            self.addressLabel.unlock()
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                return
            }
            
            // 3
            self.addressLabel.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        //        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!,zoom:mapView)
        let cameraUpdate = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!));
        mapView.animate(with: cameraUpdate)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    /* MARK: Mapview delegates */
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // UPDATE POSITION
        self.currentMapCenter = position.target;
        print(self.currentMapCenter)
        //if the location has changed
        //else it filters the list
        reverseGeocode(coordinate: position.target)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
    }
}


extension ViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place address: \(place.formattedAddress)")
    print("Place attributions: \(place.attributions)")
      
    let chosenLocation = GMSCameraPosition.camera(
        withLatitude: place.coordinate.latitude,
        longitude:place.coordinate.longitude,
          zoom: 16
      )
    mapView.camera = chosenLocation
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: \(error)")
    dismiss(animated: true, completion: nil)
  }

  // User cancelled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    print("Autocomplete was cancelled.")
    dismiss(animated: true, completion: nil)
  }
}
