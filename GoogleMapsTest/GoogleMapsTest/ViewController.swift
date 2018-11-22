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
        signInButton.center = CGPoint(x: view.center.x, y: 120)
        mapView.addSubview(signInButton)
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
}
