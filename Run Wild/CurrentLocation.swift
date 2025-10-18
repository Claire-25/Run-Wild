//
//  Untitled.swift
//  Run Wild
//
//  Created by Charlie Liang on 10/18/25.
//

import SwiftUI
import CoreLocation
import Combine


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLongitude: Double?
    @Published var userLatitude: Double?
    
    // The initializer. Retrieves user location in real-time.
    override init() {
        super.init()
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // function gets most recent coordinates, stores them, and updates them in the UI (via the published variables)
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
    }
}

