//
//  ContentView.swift
//  SpeedDrop
//
//  Created by kyla usi on 4/13/25.
//

import SwiftUI

// published variable for the selected car they choose in customization
class CarSelectionModel: ObservableObject {
    @Published var selectedCar: String = "carspeeddrop1"
}

struct ContentView: View {
    @State private var navigateToCustomization = false
    
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
                    
                
                       Image("car1SpeedDrop")
                           .imageScale(.large)
                           .padding(.top, -100)
                           .padding(.bottom, -50)
                           .offset(x: geometry.size.width * -0.25)
                           .onTapGesture {
                               print("car tapped!")
                               navigateToCustomization = true
                           }
                           .navigationDestination(isPresented: $navigateToCustomization) {
                               CarCustomizationView()
                           }
                 
                    
                    // road with dashed lines
                    RoadView()
                        .frame(height: 40)
                        .padding(.horizontal, -80)
                        .ignoresSafeArea()
                    
                   // speed limit sign with pole
                    SpeedLimitView()
                        .offset(x: geometry.size.width * 0.25, y: -260)
                        // TODO: when speed limit is tapped navigate to apple maps
                        .onTapGesture {
                            print("speed limit tapped!")
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
                    .onTapGesture {
                        print("music tapped!")
                    }
                }
            }
        }
     .tint(.white)

    }
}

struct MusicBarView: View {
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                   .background(
                       RoundedRectangle(cornerRadius: 20)
                        .fill(Color.green.opacity(0.7))
                       // TODO: add red option when speed limit is exceeded
                   )
                   .frame(height: 15, alignment: .center)
                   .padding(.horizontal, 75)
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                // TODO: for muted Image(systemName: "speaker.slash.fill")
                    .foregroundColor(.white)
                Text("Music Playing")
                    .foregroundColor(.white)
            }
        }
    }
}

struct SpeedLimitView: View {
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
                    Text("45")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct SpeedometerView: View {
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
            
            // SAUL will change this text to be the user's speed
            Text("45")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .offset(x:0,y:-15)
                
        }
        .frame(width: 300, height: 110)
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
