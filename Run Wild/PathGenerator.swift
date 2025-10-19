//
//  PathGenerator.swift
//  Run Wild
//
//  Created by Claire Li on 10/16/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct RouteMapView: UIViewRepresentable {
    let routeCoordinates: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)

        // Create the polyline from coordinates
        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        uiView.addOverlay(polyline)

        // Fit the map region around the polyline
        if let first = routeCoordinates.first {
            uiView.setRegion(
                MKCoordinateRegion(
                    center: first,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ),
                animated: true
            )
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

// MARK: - Route Generator

struct RouteGenerator {
    static func generateRoute(for animal: String, at start: CLLocationCoordinate2D, distanceGoal: Double = 1.0) -> [CLLocationCoordinate2D] {
        let lat = start.latitude
        let lon = start.longitude
        let d = 0.001 * distanceGoal // scale by distance goal
        var coords: [CLLocationCoordinate2D] = []

        switch animal {
        case "Bird":
            // Simple bird “V” shape
            coords = [
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon + d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon + 0.5*d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon - d),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon - 0.5*d),
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        case "Bunny":
            // Bunny ears, head, body
            coords = [
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon + 0.05*d),
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon + 0.1*d), // head
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon + 0.05*d), // right ear
                CLLocationCoordinate2D(latitude: lat + 0.75*d, longitude: lon - 0.05*d), // left ear
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon - 0.1*d), // head left
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon - 0.05*d), // body left
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        case "Butterfly":
            // Parametric butterfly wings
            for t in stride(from: 0.0, to: 2*Double.pi, by: 0.1) {
                let x = d * cos(t) * (1 + 0.5 * sin(4*t))
                let y = d * sin(t) * (1 + 0.5 * cos(3*t))
                coords.append(CLLocationCoordinate2D(latitude: lat + y, longitude: lon + x))
            }
            
        case "Shrimp":
            // Shrimp-like curved body
            for i in 0...50 {
                let theta = Double(i)/50 * Double.pi // half circle
                let x = d * theta * 0.6
                let y = d * sin(theta) * 0.5
                coords.append(CLLocationCoordinate2D(latitude: lat + y, longitude: lon + x))
            }
            
        default:
            coords = [start]
        }

        return coords
    }
}
