//
//  ViewController.swift
//  GoogleMapsTest
//

import UIKit
import GoogleMaps
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    
    
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
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        let signInButton = GIDSignInButton()
        mapView.addSubview(signInButton)
        
        
        let string12H = "2018-11-30 07:35:22 PM"
        let string24H = "2018-11-30 19:35:22"
        
        let date12H = getDateFrom(string12H, withFormat: "yyyy-MM-dd hh:mm:ss a", timeZone: "IST")
        let date24H = getDateFrom(string24H, withFormat: "yyyy-MM-dd HH:mm:ss", timeZone: "IST")
        
        let string1_12 = getStringFrom(date12H!, withFormat: "yyyy-MM-dd hh:mm:ss a")
        let string1_24 = getStringFrom(date12H!, withFormat: "yyyy-MM-dd HH:mm:ss")
        
        let string2_12 = getStringFrom(date24H!, withFormat: "yyyy-MM-dd hh:mm:ss a")
        let string2_24 = getStringFrom(date24H!, withFormat: "yyyy-MM-dd HH:mm:ss")
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
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        print("signInWillDispatch")
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        print("presentViewController")
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        print("dismissViewController")
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDateFrom(_ dateString: String, withFormat formatString: String, timeZone: String = "UTC") -> Date? {
        var dateToReturn: Date?
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: timeZone) as TimeZone?
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        dateToReturn = formatter.date(from: dateString)
        return dateToReturn
    }
    
    func getStringFrom(_ date: Date, withFormat formatString: String) -> String? {
        var stringToReturn: String?
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        formatter.locale = Locale(identifier: "en_US_POSIX")
        stringToReturn = formatter.string(from: date)
        return stringToReturn
    }
}
