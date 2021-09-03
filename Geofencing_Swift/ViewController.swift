//
//  ViewController.swift
//  Geofencing_Swift
//
//  Created by Kavya K N on 03/09/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    private let map : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        
        LocationManager.sharedInstance.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                // For testing in Device.
//                strongSelf.addMapPin(location: location)
                
                //For testing in simulator.
                strongSelf.addMapPin(location: CLLocation(latitude: 19.01761470, longitude: 72.85616440))
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    // MARK : Add annotation pin on MapView.
    func addMapPin(location: CLLocation) {
        let annotationPin = MKPointAnnotation()
        annotationPin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        map.addAnnotation(annotationPin)
        
        LocationManager.sharedInstance.findLocationName(with: location) { [weak self] locationName in
            self?.title = locationName
        }
    }

}

