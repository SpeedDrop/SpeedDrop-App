//
//  ContentView.swift
//  SpeedDrop
//
//  Created by kyla usi on 4/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
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
                    .padding(.top, 20)
                
                // user's speed
                SpeedometerView()
                    .offset(x: -180, y: 0)
                
                // car component
                Image("car1SpeedDrop")
                    .imageScale(.large)
                    .padding(.top,-100)
                    .padding(.bottom, -50)
                    .offset(x: -180, y: 0)
                    // TODO: when car is tapped go to car customization page
                    .onTapGesture {
                        print("car tapped!")
                    }
                
                // road with dashed lines
                RoadView()
                    .frame(height: 40)
                    .padding(.horizontal, -80)
                    .ignoresSafeArea()
                
               // speed limit sign with pole
                SpeedLimitView()
                    .offset(x: 220, y: -260)
                    // TODO: when speed limit is tapped navigate to apple maps
                    .onTapGesture {
                        print("speed limit tapped!")
                    }
            }
            .padding()
            
           // music bar and text
           MusicBarView()
                // TODO: when music is tapped navigate to apple music
                .onTapGesture {
                    print("music tapped!")
                }
    }
  }
}

struct MusicBarView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white.opacity(0.8), lineWidth: 2)
               .background(
                   RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(0.7))
                   // TODO: add red option when speed limit is exceeded
               )
               .frame(height: 15)
               .padding(.horizontal, 20)
               .offset(x: 0, y: 80)
        HStack {
            Image(systemName: "speaker.wave.2.fill")
            // TODO: for muted Image(systemName: "speaker.slash.fill")
                .foregroundColor(.white)
            Text("Music Playing")
                .foregroundColor(.white)
        }
        .offset(x: 0, y: 110)
        
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
                    Text("LIMIT")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                // JANNIEL will change this text to be the speed limit of the area
                    Text("45")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct SpeedometerView: View {
    
    @StateObject private var locationManager = LocationManager()
    
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
            Text(String(format: "%.0f MPH", locationManager.speedMPH))
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
