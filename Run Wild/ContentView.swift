//
//  ContentView.swift
//  Run Wild
//
//  Created by Claire Li on 10/15/25.
//
import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var appData = AppData()
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    @State private var currentOffset: CGFloat = 400 // starting collapsed
    @State private var dragOffset: CGFloat = 0
    let maxHeight: CGFloat = 100   // fully collapsed offset (higher = lower on screen)
    let minHeight: CGFloat = 400   // fully expanded offset (smaller = higher on screen)
    
    var body: some View {
        ZStack {
            // Base map
            Map(position: $position) {
                UserAnnotation()
            }
            .mapStyle(.standard)
            .ignoresSafeArea()
            .onAppear { updateUserLocation() }
            .onChange(of: locationManager.userLatitude) { _ in updateUserLocation() }
            .onChange(of: locationManager.userLongitude) { _ in updateUserLocation() }

            // Route overlay
            if !appData.routeCoordinates.isEmpty {
                RouteMapView(routeCoordinates: appData.routeCoordinates)
                    .edgesIgnoringSafeArea(.all)
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
                    .environmentObject(appData)
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
    
    // MARK: - Helper
    private func updateUserLocation() {
        if let lat = locationManager.userLatitude,
           let lon = locationManager.userLongitude {
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            appData.userLocation = coord
            
            // Optional: move map camera to follow user
            withAnimation {
                position = .region(
                    MKCoordinateRegion(
                        center: coord,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }
        }
    }
}
