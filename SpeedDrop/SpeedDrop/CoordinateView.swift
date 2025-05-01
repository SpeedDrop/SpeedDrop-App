//
//  CoordinateView.swift
//  SpeedDrop
//
//  Created by Janniel Tan on 4/29/25.
//

import SwiftUI
import CoreLocation

struct CoordinateView: View {
    @StateObject private var locationManager = LocationLimitManager()
    @StateObject private var speedFetcher = SpeedLimitFetcher()
    @State private var locationName: String = "Locating..."

    var body: some View {
        ZStack {
            Image("backgroundColor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                if let location = locationManager.lastLocation {
                    Text("Coordinates:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)")
                        .foregroundColor(.white)

                    Text("Location:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(locationName)
                        .foregroundColor(.white)

                    if let speed = speedFetcher.speedLimit {
                        Text("Speed Limit: \(speed) mph")
                            .foregroundColor(.white)
                    }
                } else {
                    Text("Getting location...")
                        .foregroundColor(.white)
                }
            }
            .onChange(of: locationManager.lastLocation) { newLocation in
                if let newLocation = newLocation {
                    fetchLocationName(from: newLocation)
                }
            }
        }
        
        .onAppear {
            speedFetcher.startFetching {
                locationManager.lastLocation
            }
        }
        .onDisappear {
            speedFetcher.stopFetching()
        }
    }

    func fetchLocationName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                locationName = [
                    //apple documentation
                    placemark.thoroughfare,              //street
                    placemark.locality,                  //city
                    placemark.administrativeArea,        //city
                    placemark.country
                ]
                .compactMap { $0 }
                .joined(separator: ", ")
            } else {
                locationName = "Unknown location"
            }
        }
    }
}

