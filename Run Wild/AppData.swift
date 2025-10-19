//
//  AppData.swift
//  Run Wild
//
//  Created by Claire Li on 10/18/25.
//

import SwiftUI
import Combine
import CoreLocation

class AppData: ObservableObject {
    @Published var distance: String = ""
    @Published var selectedShape: String = "Bird"
    
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var userLocation: CLLocationCoordinate2D? = nil
}
