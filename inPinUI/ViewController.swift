//
//  ViewController.swift
//  inPinUI
//
//  Created by Paras Chaudhary on 1/15/22.
//
import UIKit
import GoogleMaps

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UITextField!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        let nameResults = ["x", "y", "z"]
        let positionResults = [[40.758896,-73.985130],[40.753742,-73.983559],[40.763186,-73.994508]]
        var i = 0
        for pos in positionResults {
            let position = CLLocationCoordinate2D(latitude: pos[0], longitude: pos[1])
            let marker = GMSMarker(position: position)
            marker.title = nameResults[i]
            marker.icon = UIImage(named: "hot")
            marker.setIconSize(scaledToSize: .init(width: 25, height: 40))
            marker.map = mapView
            i+=1
        }
    }

    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)

        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()

    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
      // 1
      let geocoder = GMSGeocoder()

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
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocode(coordinate: position.target)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
      addressLabel.lock()
    }
}


