//
//  ViewController.swift
//  GoogleMapsTest
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var camera : GMSCameraPosition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.getInstance().locationChange = { (newLocation) in
            self.drawUserLocation(location: newLocation)
        }
        
        if let userLocation = LocationManager.getInstance().userLocation {
            drawUserLocation(location: userLocation)
        }
        else {
            drawUserLocation(location: CLLocation(latitude: -33.86, longitude: 151.20))
        }
    }
    
    
    fileprivate func drawUserLocation(location: CLLocation) {
        
        let coordinates = location.coordinate
        if camera != nil {
            camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: camera!.zoom)
        }
        else {
            camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 19.0)
        }
        mapView.camera = camera!
        mapView.clear()
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = coordinates
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
    }
}
