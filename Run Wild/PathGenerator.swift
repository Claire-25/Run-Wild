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
    static func generateRoute(for animal: String, at start: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        let lat = start.latitude
        let lon = start.longitude
        let d = 0.001 // roughly ~100 meters per step

        switch animal {
        case "Bird":
            return [
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon + d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon - d),
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
        case "Bunny":
            return [
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon + 0.5*d),
                CLLocationCoordinate2D(latitude: lat + 1.5*d, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon - 0.5*d),
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
        case "Butterfly":
            return [
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon + d),
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon - d),
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
        case "Shrimp":
            return [
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon + 0.3*d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + d, longitude: lon - 0.3*d),
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
        default:
            return []
        }
    }
}
