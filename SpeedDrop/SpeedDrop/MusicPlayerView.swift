//
//  ContentView.swift
//  AppleMusicController
//
//  Created by Sergio
//
import SwiftUI
import MediaPlayer
import AVKit
import AVFoundation // Added for AVRoutePickerView

struct MusicPlayerView: View {
    @State private var isPlaying = false
    @State private var nowPlayingTitle = "No song playing"
    @State private var nowPlayingArtist = ""
    @State private var currentPlaybackTime: TimeInterval = 0
    @State private var totalPlaybackTime: TimeInterval = 0
    
    private let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    var body: some View {
        ZStack{
            Image("backgroundColor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 20) {
                // Now Playing Info
                VStack(spacing: 8) {
                    Text(nowPlayingTitle)
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .tracking(5)
                        .foregroundColor(.white)
                    Text(nowPlayingArtist)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal)
                
                // Playback Progress (Read-only due to API restrictions)
                if totalPlaybackTime > 0 {
                    VStack {
                        ProgressView(value: currentPlaybackTime, total: totalPlaybackTime)
                        HStack {
                            Text(formatTime(currentPlaybackTime))
                            Spacer()
                            Text(formatTime(totalPlaybackTime))
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                
                // Transport Controls
                HStack(spacing: 40) {
                    Button(action: skipToPrevious) {
                        Image(systemName: "backward.fill")
                            .font(.title)
                    }
                    
                    Button(action: togglePlayback) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                    }
                    
                    Button(action: skipToNext) {
                        Image(systemName: "forward.fill")
                            .font(.title)
                    }
                }
                .padding(.vertical)
                
                // Volume Control and Route Picker (Updated section)
                HStack {
                    VolumeSlider()
                        .frame(height: 40)
                    RoutePickerView()
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal)
                
                // Status
                Text(isPlaying ? "Now Playing" : "Paused")
                    .foregroundColor(isPlaying ? .green : Color(.systemRed).opacity(0.8))
            }
            .padding()
            .onAppear {
                setupNowPlayingObserver()
                updateNowPlayingInfo()
                startPlaybackTimer()
            }
            .onDisappear {
                stopPlaybackTimer()
            }
        }
    }
    
    // MARK: - Playback Controls
    private func togglePlayback() {
        if musicPlayer.playbackState == .playing {
            musicPlayer.pause()
        } else {
            musicPlayer.play()
        }
        isPlaying = (musicPlayer.playbackState == .playing)
    }
    
    private func skipToNext() {
        musicPlayer.skipToNextItem()
    }
    
    private func skipToPrevious() {
        musicPlayer.skipToPreviousItem()
    }
    
    // MARK: - Playback Time
    private func startPlaybackTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentPlaybackTime = musicPlayer.currentPlaybackTime
            if let nowPlayingItem = musicPlayer.nowPlayingItem {
                totalPlaybackTime = nowPlayingItem.playbackDuration
            }
        }
    }
    
    private func stopPlaybackTimer() {
        // Invalidate timer if needed (not shown for simplicity)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - Now Playing Info
    private func updateNowPlayingInfo() {
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            nowPlayingTitle = nowPlayingItem.title ?? "Unknown Title"
            nowPlayingArtist = nowPlayingItem.artist ?? "Unknown Artist"
            isPlaying = (musicPlayer.playbackState == .playing)
            totalPlaybackTime = nowPlayingItem.playbackDuration
        } else {
            nowPlayingTitle = "No song playing"
            nowPlayingArtist = ""
            isPlaying = false
            totalPlaybackTime = 0
        }
        currentPlaybackTime = musicPlayer.currentPlaybackTime
    }
    
    private func setupNowPlayingObserver() {
        NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: musicPlayer,
            queue: .main
        ) { _ in updateNowPlayingInfo() }
        
        NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerPlaybackStateDidChange,
            object: musicPlayer,
            queue: .main
        ) { _ in updateNowPlayingInfo() }
        
        musicPlayer.beginGeneratingPlaybackNotifications()
    }
}

// MARK: - Volume Control (UIKit Integration)
struct VolumeSlider: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.tintColor = .systemBlue
        return volumeView
    }
    
    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}

// MARK: - New Route Picker View (Replaces showsRouteButton)
struct RoutePickerView: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let routePickerView = AVRoutePickerView(frame: .zero)
        routePickerView.activeTintColor = .systemBlue
        routePickerView.tintColor = .systemBlue
        return routePickerView
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}

#Preview {
    MusicPlayerView()
}
