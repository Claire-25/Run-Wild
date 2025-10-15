//
//  ContentView.swift
//  Run Wild
//
//  Created by Claire Li on 10/15/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var currentLocation = ""
    @State private var destination = ""
    @State private var distance = ""
    @State private var selectedShape = 0
    @State private var bottomSheetOffset: CGFloat = 0
    
    
    var body: some View {
        ZStack {
            // Background map
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
            
            
        }
        
    }
    
   
}
