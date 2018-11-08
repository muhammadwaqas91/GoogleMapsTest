//
//  LocationManager.swift
//

import CoreLocation
import UIKit

@objc class LocationManager : NSObject, CLLocationManagerDelegate
{
    private var lastLocation : CLLocation?
    private let manager = CLLocationManager()
    private static let sharedInstance = LocationManager()
    
    var distanceLabel: UILabel?
    var lastAddress: String?

    var locationChange : ((_ location: CLLocation) ->())?
    
    class func getInstance() -> LocationManager
    {
        return sharedInstance
    }
    
    override private init()
    {
        super.init()

        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.headingFilter = 0
        
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    class func isLocationIdentified() -> Bool   {
        return sharedInstance.userLocation != nil
    }
    
    var userLocation : CLLocation?   {
        return lastLocation
    }
    
    var userAdress: String? {
        return lastAddress
    }
    
    private func startLocationManager(timer: Timer) {
        manager.startUpdatingLocation()
        timer.invalidate()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last
        
        if lastLocation == nil || (lastLocation?.coordinate.latitude != currentLocation?.coordinate.latitude &&  lastLocation?.coordinate.longitude != currentLocation?.coordinate.longitude)
        {
            lastLocation = currentLocation
            self.locationChange?(currentLocation!)
            getAddressFromLocation()
        }
    }
    
    func getAddressFromLocation()
    {
        
        if ReachabilityManager.isNetworkConnected()
        {
            if let location = lastLocation
            {
//                GMSGeocoder().reverseGeocodeCoordinate(location.coordinate, completionHandler: { response, error in
//                    if error == nil
//                    {
//                        if let r = response
//                        {
//                            let addresses = r.results()
//                            let address = addresses!.first!
//                            self.lastAddress = Utility.getAddressString(address: address)
//                            debugPrint(address)
//                            NotificationCenter.default.post(name: .locationAddressGet, object: nil)
//                        }
//                    }
//                })
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        var shouldAllow = false
        switch (status) {
        case .restricted:
            print("Restricted Access to location")
        case .denied:
            print("User denied access to location")
        case .notDetermined:
            print("Status not determined")
        default:
            print("Allowed to location Access")
            shouldAllow = true
        }
        
        if shouldAllow == true {
            manager.startUpdatingLocation()
        } else {
            print("Denied access: \(status)")
        }

    }
    

    static func startMonitoring()
    {
        self.sharedInstance.manager.startUpdatingLocation()
        self.sharedInstance.manager.startUpdatingHeading()
    }
    
    static func stopMonitoring()
    {
        self.sharedInstance.manager.stopUpdatingLocation()
        self.sharedInstance.manager.stopUpdatingHeading()
    }
}

private struct k    {
    static let QiblahCoordinates = CLLocationCoordinate2DMake(21.422523, 39.8256057)
}


