//
//  LocationManager.swift
//  SpeedDrop
//
//  Created by Saul Machuca on 4/25/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @Published var gpsAccuracy: CLLocationAccuracy = -1.0
    @Published var speedMPH: Double = 0.0
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.activityType = .automotiveNavigation
        locationManager.requestWhenInUseAuthorization() // Request permission
        locationManager.startUpdatingLocation() // Start getting location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed with error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Permission granted")
            locationManager.startUpdatingLocation()
            locationManager.requestLocation() // Optional: one-time fetch
        case .denied, .restricted:
            print("❌ Location access denied or restricted")
        case .notDetermined:
            print("🕓 Waiting for user to respond to permission prompt")
        @unknown default:
            print("⚠️ Unknown location status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.latitude = location.coordinate.longitude
        self.longitude = location.coordinate.latitude
        self.gpsAccuracy = location.horizontalAccuracy
        
        DispatchQueue.main.async {
            self.speedMPH = location.speed * 2.23694 // Converts m/s into MPH
        }
    }
}
