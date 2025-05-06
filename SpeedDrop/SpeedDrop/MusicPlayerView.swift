//
//  MusicPlayerView.swift
//  SpeedDrop
//
//  Created by kyla usi on 5/5/25.
//

import SwiftUI

struct MusicPlayerView: View {
    var body: some View {
        ZStack{
            // gradient background color
            Image("backgroundColor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // put stuff here
            Text("music player view")
        }
    }
}

#Preview {
    MusicPlayerView()
}
