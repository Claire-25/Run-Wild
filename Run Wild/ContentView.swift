//
//  ContentView.swift
//  Run Wild
//
//  Created by Claire Li on 10/15/25.
//
import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .automatic
    
    private func updatePosition() {
        if let lat = locationManager.userLatitude,
           let long = locationManager.userLongitude {
            position = .camera(
                MapCamera(
                    centerCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: long),
                    distance: 1000, // meters - adjust this to zoom in/out (lower = more zoomed in)
                    heading: 0,
                    pitch: 0
                )
            )
        }
    }
    
    @State private var currentOffset: CGFloat = 400 // starting collapsed
    @State private var dragOffset: CGFloat = 0
    let maxHeight: CGFloat = 100   // fully collapsed offset (higher = lower on screen)
    let minHeight: CGFloat = 400   // fully expanded offset (smaller = higher on screen)
    
    var body: some View {
        ZStack {
            // MAP
            Map(position: $position) {
                UserAnnotation()
            }
            .mapStyle(.standard)
            .ignoresSafeArea()
            .onAppear {
                updatePosition()
            }
            .onChange(of: locationManager.userLatitude) {
                updatePosition()
            }
            .onChange(of: locationManager.userLongitude) {
                updatePosition()
            }
            
            // Dim background when panel up
            Color.black
                .opacity(currentOffset < 250 ? 0.25 : 0)
                .ignoresSafeArea()
                .animation(.easeInOut, value: currentOffset)
            
            // BOTTOM SHEET
            VStack {
                Spacer()
                BottomPanelView()
                    .offset(y: currentOffset + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                dragOffset = gesture.translation.height
                            }
                            .onEnded { gesture in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    if gesture.translation.height < -50 {
                                        // drag up
                                        currentOffset = maxHeight
                                    } else if gesture.translation.height > 50 {
                                        // drag down
                                        currentOffset = minHeight
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
            }
        }
        .onAppear {
            currentOffset = minHeight // start collapsed at bottom
        }
    }
}
