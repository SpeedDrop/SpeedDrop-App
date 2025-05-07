//
//  SpeedLimitFetcher.swift
//  testing4
//
//  Created by Janniel Tan on 4/28/25.
//

import Foundation
import CoreLocation

class SpeedLimitFetcher: ObservableObject {
    @Published var speedLimit: Int?
    @Published var isLoading = false
    
    private var timer: Timer?
    private var lastFetchedLocation: CLLocation?  // last location
    
    
    func startFetching(for locationProvider: @escaping () -> CLLocation?) {
        timer?.invalidate() // Stop any previous timer if it's running
        
        // fetch data every minute
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self,
                  let location = locationProvider() else {
                return
            }
            
            
            if let lastLocation = self.lastFetchedLocation {
                let distance = location.distance(from: lastLocation)
                if distance < 20 { // avoid calling the api too much
                    // only starts calling after moving
                    return
                }
            }
            
            self.lastFetchedLocation = location
            self.fetchSpeedLimit(lat: location.coordinate.latitude, lon: location.coordinate.longitude) // for the new location
        }
        
        
        if let location = locationProvider() {
            self.fetchSpeedLimit(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            self.lastFetchedLocation = location
        }
    }
    
    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
    
    func fetchSpeedLimit(lat: Double, lon: Double) {
        let query = """
        [out:json];
        way(around:100,\(lat),\(lon))["maxspeed"];
        out;
        """
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://overpass-api.de/api/interpreter?data=\(encodedQuery)") else {
            print("URL not working")
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let elements = json["elements"] as? [[String: Any]] {
                    
                    var bestSpeed: Int?
                    
                    for element in elements {
                        if let tags = element["tags"] as? [String: Any],
                           let maxspeed = tags["maxspeed"] as? String {
                            
                            let numberString = maxspeed.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                            if let speed = Int(numberString) {
                                bestSpeed = speed
                                break
                            }
                        }
                    }
                    
                    if let speed = bestSpeed {
                        DispatchQueue.main.async {
                            self.speedLimit = speed
//                            print("Updated speed limit: \(speed) mph")
                        }
                    } else {
                        print("No valid speed found in Overpass response")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
