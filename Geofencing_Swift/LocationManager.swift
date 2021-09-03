//
//  LocationManager.swift
//  Geofencing_Swift
//
//  Created by Kavya K N on 03/09/21.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager : NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    let locationManager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    // MARK : To request user to enable permission and get User current Location.

    public func getUserLocation(completion: @escaping((CLLocation) -> Void)){
        self.completion = completion
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        // Set hard coded geoFenceRegion to Mumbai region.
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(19.01761470, 72.85616440), radius: 100, identifier: "Home Location")
        
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    // MARK : Get location name.
    public func findLocationName(with location: CLLocation, completion: @escaping((String?) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            var name = ""
            
            if let locality = place.locality {
                name += locality
            }
            if let adminRegion = place.administrativeArea {
                name += ",\(adminRegion)"
            }
            
            completion(name)
        }
    }
    
    // MARK : Location Manager Delegate methods.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        completion?(location)
        print(location)
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
        self.presentAlert(withTitle: "Geofencing App", message: "You have entered \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
        self.presentAlert(withTitle: "Geofencing App", message: "You have exited \(region.identifier)")
    }
}

// MARK : To show alert on enter and exit events.
extension LocationManager {
    
    func presentAlert(withTitle : String, message : String) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
