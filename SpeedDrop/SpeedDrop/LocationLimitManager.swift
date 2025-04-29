//
//  LocationLimitManager.swift
//  testing4
//
//  Created by Janniel Tan on 4/29/25.
//


import Foundation
import CoreLocation

class LocationLimitManager: NSObject, CLLocationManagerDelegate, ObservableObject {
private let locationManager = CLLocationManager()
@Published var lastLocation: CLLocation?

override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let newLocation = locations.first else { return }
    self.lastLocation = newLocation
}

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to get location: \(error.localizedDescription)")
}
}
