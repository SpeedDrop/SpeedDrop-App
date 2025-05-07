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
    let carImages = ["car1SpeedDrop", "pinkCar", "purpleCar", "redCar"]
    
    // grid layout with 2 columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            // gradient background color
            Image("backgroundColor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            HStack {
                VStack {
                    Text("Car Customization").font(.title)
                        .fontWeight(.light)
                        .tracking(3)
                        .foregroundColor(.white)
                        .padding(.top, 110)
                    
                    
                    // car component - now showing selected car
                    Image(carModel.selectedCar)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .padding(.bottom, 40)
                    
                    Spacer()
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)

                ZStack {
                    // gray background panel
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(width: 350, height: 300)
                    
                    // grid of car thumbnails
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(carImages, id: \.self) { carImage in
                            Image(carImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)
                                .padding(10)
                                .background(
                                    carModel.selectedCar == carImage ?
                                        Color.white.opacity(0.2) : Color.clear
                                )
                                .cornerRadius(10)
                                .onTapGesture {
                                    // Update the selected car when clicked
                                    carModel.selectedCar = carImage
                                }
                        }
                    }
                    .padding(30)
                }
                .frame(width: 380)
                .padding(.trailing, 20)
            }
        }
    }
}

#Preview {
    // for preview
    let tempModel = CarSelectionModel()
    return CarCustomizationView()
        .environmentObject(tempModel)
}

