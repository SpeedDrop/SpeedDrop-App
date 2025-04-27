//
//  CarCustomizationView.swift
//  SpeedDrop
//
//  Created by kyla usi on 4/22/25.
//

import SwiftUI

struct CarCustomizationView: View {
    // selected car variable
    @EnvironmentObject var carModel: CarSelectionModel
    // array of car images to choose from
    let carImages = ["car1SpeedDrop", "grayCar", "pinkCar", "purpleCar", "redCar"]
    
    var body: some View {
        ZStack{
            // gradient background color
            Image("backgroundColor")
                   .resizable()
                   .scaledToFill()
                   .ignoresSafeArea()
            HStack{
                VStack{
                    Text("Car Customization").font(.largeTitle)
                        .fontWeight(.light)
                        .tracking(3)
                        .foregroundColor(.white)
                    
                    // car component
                    Image("car1SpeedDrop")
                        .imageScale(.large)
                        // TODO: when car is tapped go to car customization page
                        .onTapGesture {
                            print("car tapped!")
                        }
                }
                .padding()

                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(width: 380, height: 350)
                    
                }
            }
        }
    }
}

#Preview {
    CarCustomizationView()
}
