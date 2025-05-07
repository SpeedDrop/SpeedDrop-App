//
//  ContentView.swift
//  SpeedDrop
//
//  Created by kyla usi on 4/13/25.
//

import SwiftUI
import MediaPlayer

// published variable for the selected car they choose in customization
class CarSelectionModel: ObservableObject {
    @Published var selectedCar: String = "car1SpeedDrop"
}

// track speed
class SpeedMonitorModel: ObservableObject {
    @Published var isSpeeding = false
    @Published var isMusicMuted = false
    @Published var lastSpeedLimit: Int? = nil
    
    private let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    func checkSpeedLimit(currentSpeed: Double, speedLimit: Int?) {
        // update lastSpeedLimit property when we get a valid speed limit
        if let limit = speedLimit, limit > 0 {
            lastSpeedLimit = limit
        }
        
        guard let limit = lastSpeedLimit, limit > 0 else { return }
        
        let wasSpeedingBefore = isSpeeding
        isSpeeding = currentSpeed >= Double(limit + 15)
        
        // when the speeding status changes
        if isSpeeding != wasSpeedingBefore {
            if isSpeeding {
                // exceeded speed limit by 15+ mph
                if musicPlayer.playbackState == .playing {
                    musicPlayer.pause()
                    isMusicMuted = true
                }
            } else {
                // slowed down below the threshold
                if isMusicMuted {
                    musicPlayer.play()
                    isMusicMuted = false
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var navigateToCustomization = false
    @State private var navigateToCoordinates = false
    @State private var navigateToMusic = false
    @StateObject private var carModel = CarSelectionModel()
    @StateObject private var speedMonitor = SpeedMonitorModel()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var locationLimitManager = LocationLimitManager()
    @StateObject private var speedLimitFetcher = SpeedLimitFetcher()
    
    var body: some View {
    
    NavigationStack {
        GeometryReader{ geometry in
            ZStack{
                // gradient background color
                Image("backgroundColor")
                       .resizable()
                       .scaledToFill()
                       .ignoresSafeArea()
                
                // main components
                VStack {
                    // app title text
                    Text("SPEEDDROP")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .tracking(5)
                        .foregroundColor(.white)
                    
                    // user's speed
                    SpeedometerView()
                        .offset(x: geometry.size.width * -0.25, y: 0)
                        .environmentObject(locationManager)
                    // pass the speed monitor
                        .environmentObject(speedMonitor)
                    
                    // use selected car image here
                       Image(carModel.selectedCar)
                           .resizable()
                           .scaledToFit()
                           .padding(.top, -100)
                           .padding(.bottom, -60)
                           .offset(x: geometry.size.width * -0.25)
                           .onTapGesture {
                               print("car tapped!")
                               navigateToCustomization = true
                           }
                           .navigationDestination(isPresented: $navigateToCustomization) {
                               CarCustomizationView()
                               // pass car environment object
                                   .environmentObject(carModel)
                           }
                    
                    // road with dashed lines
                    RoadView()
                        .frame(height: 40)
                        .padding(.horizontal, -80)
                        .ignoresSafeArea()
                    
                   // speed limit sign with pole
                    SpeedLimitView()
                        .offset(x: geometry.size.width * 0.25, y: -260)
                        .environmentObject(speedLimitFetcher)
                        .environmentObject(speedMonitor)
                        .onTapGesture {
                            print("speed limit tapped!")
                            navigateToCoordinates = true
                        }
                        .navigationDestination(isPresented: $navigateToCoordinates) {
                            CoordinateView()
                        }
                }
                .padding()
                .offset(y: -geometry.size.height * 0.04)
                .frame(width: geometry.size.width)
               // music bar and text
               MusicBarView()
                    // TODO: when music is tapped navigate to apple music
                    .offset(y: geometry.size.height * 0.20000001)
                    .frame(alignment: .center)
                    .environmentObject(speedMonitor)
                    .onTapGesture {
                        print("music tapped!")
                        navigateToMusic = true
                    }
                    .navigationDestination(isPresented: $navigateToMusic) {
                        MusicPlayerView()
                    }
                }
            }
        }
        // make selected car available in other view
        .environmentObject(carModel)
        .environmentObject(speedMonitor)
        .tint(.white)
        .onAppear {
                   // start the speed limit fetcher
                   speedLimitFetcher.startFetching { [weak locationLimitManager] in
                       return locationLimitManager?.lastLocation
                   }
                   
                   // initialize the speed monitor with current values
                   speedMonitor.checkSpeedLimit(currentSpeed: locationManager.speedMPH,
                                                speedLimit: speedLimitFetcher.speedLimit)
               }
               // monitor speed changes and check against speed limit
               .onChange(of: locationManager.speedMPH) { oldValue, newValue in
                   speedMonitor.checkSpeedLimit(currentSpeed: newValue,
                                             speedLimit: speedLimitFetcher.speedLimit)
                   print("Speed changed to \(newValue) MPH, checking against limit: \(speedLimitFetcher.speedLimit ?? 0)")
               }
                // update speed monitor when speed limit changes
               .onChange(of: speedLimitFetcher.speedLimit) { oldValue, newValue in
                           speedMonitor.checkSpeedLimit(currentSpeed: locationManager.speedMPH,
                                                       speedLimit: newValue)
                           print("Speed limit updated to: \(newValue ?? 0) MPH")
                       }
    }
}

struct MusicBarView: View {
    @EnvironmentObject var speedMonitor: SpeedMonitorModel
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                   .background(
                       RoundedRectangle(cornerRadius: 20)
                        .fill(speedMonitor.isSpeeding ? Color.red.opacity(0.7) : Color.green.opacity(0.7))
                   )
                   .frame(height: 15, alignment: .center)
                   .padding(.horizontal, 75)
            HStack {
                Image(systemName: speedMonitor.isSpeeding ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.white)
                Text(speedMonitor.isSpeeding ? "Music Paused" : "Music Playing")
                    .foregroundColor(.white)
            }
        }
    }
}

struct SpeedLimitView: View {
    @StateObject private var locationLimitManager = LocationLimitManager()
    @EnvironmentObject var speedLimitFetcher: SpeedLimitFetcher
    @EnvironmentObject var speedMonitor: SpeedMonitorModel

    var body: some View {
        ZStack {
            // pole
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 5, height: 165)
                .offset(y: 50)

            // speed limit sign
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                            .padding(2)
                    )

                VStack(spacing: 0) {
                    Text("SPEED")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text("LIMIT")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                  
                // JANNIEL will change this text to be the speed limit of the area
                        .font(.footnote)
                                  if let speedLimit = speedLimitFetcher.speedLimit {
                                      Text("\(speedLimit)")
                                          .font(.system(size: 28))
                                          .fontWeight(.bold)
                                          .foregroundColor(.black)
                                  } else {
                                      Text("N/A")
                                          .font(.system(size: 28))
                                          .fontWeight(.bold)
                                          .foregroundColor(.black)
                                  }
                              }
                 }
            }
        
        .onChange(of: speedLimitFetcher.speedLimit) { oldValue, newValue in
                    if let limit = newValue {
                        print("Speed limit changed to \(limit) MPH")
                        speedMonitor.lastSpeedLimit = limit
                    }
                }
    }
}


struct SpeedometerView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var speedMonitor: SpeedMonitorModel
    
    var body: some View {
        ZStack {
            // semi-circle speedometer
            Circle()
                .trim(from: 0.5, to: 1.0)
                .foregroundColor(Color(red: 0.2, green: 0.22, blue: 0.24))
                .overlay(
                    Circle()
                        .trim(from: 0.5, to: 1.0)
                        .stroke(Color(red: 0.3, green: 0.28, blue: 0.2), lineWidth: 6)
                )
            
            // tick marks of speedometer
            ForEach(0..<31) { i in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 1, height: 5)
                    .offset(y: -50)
                    .rotationEffect(.degrees(Double(i) * 6 - 90))
            }
            
            // User's Current Speed
            Text(String(format: "%.0f", locationManager.speedMPH))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .offset(x:0,y:-15)
                
        }
        .frame(width: 300, height: 110)
        .onAppear {
                    // connect to speed monitor when view appears
                    connectToSpeedMonitor()
                }
                // monitor speed changes
                .onChange(of: locationManager.speedMPH) { _, newSpeed in
                    connectToSpeedMonitor()
                }
    }
    private func connectToSpeedMonitor() {
           // check if speeding and control music
           speedMonitor.checkSpeedLimit(currentSpeed: locationManager.speedMPH,speedLimit: speedMonitor.lastSpeedLimit)
       }
}


struct RoadView: View {
    var body: some View {
        ZStack {
            // road background
            Rectangle()
                .foregroundColor(.black)
            // dashed line
            HStack(spacing: 12) {
                ForEach(0..<30) { _ in
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 3)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
