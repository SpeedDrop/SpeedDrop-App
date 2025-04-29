//
//  SpeedLimitFetcher.swift
//  testing4
//
//  Created by Janniel Tan on 4/28/25.
//

import Foundation

class SpeedLimitFetcher: ObservableObject {
    @Published var speedLimit: Int?
    @Published var isLoading = false

    func fetchSpeedLimit(lat: Double, lon: Double) {
        let query = """
        [out:json];
        way(around:100,\(lat),\(lon))["maxspeed"];
        out;
        """

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://overpass-api.de/api/interpreter?data=\(encodedQuery)") else {
            print("Bad URL")
            return
        }

        isLoading = true

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
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

                    if let first = elements.first,
                       let tags = first["tags"] as? [String: Any],
                       let maxspeed = tags["maxspeed"] as? String {

                        let numberString = maxspeed.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        if let speed = Int(numberString) {
                            DispatchQueue.main.async {
                                self?.speedLimit = speed
                            }
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
