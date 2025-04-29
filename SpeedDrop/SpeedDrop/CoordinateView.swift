//
//  CoordinateView.swift
//  SpeedDrop
//
//  Created by Janniel Tan on 4/29/25.
//

import SwiftUI

struct CoordinateView: View {
    var body: some View {
        ZStack{
            // gradient background color
            Image("backgroundColor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // put stuff here
            Text("location and coordinate view")
        }
    }
}

#Preview {
    CoordinateView()
}
