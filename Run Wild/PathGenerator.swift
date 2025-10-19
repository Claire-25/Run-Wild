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
            // Detailed bird shape with head, body, wings, and tail
            coords = [
                // Start at tail
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                // Tail feathers (fan shape)
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon + 0.3*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon + 0.5*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon - 0.5*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon - 0.3*d),
                // Back to tail center
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                // Body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Head
                CLLocationCoordinate2D(latitude: lat + 1.2*d, longitude: lon + 0.1*d),
                // Beak
                CLLocationCoordinate2D(latitude: lat + 1.4*d, longitude: lon + 0.2*d),
                // Top of head
                CLLocationCoordinate2D(latitude: lat + 1.3*d, longitude: lon + 0.3*d),
                // Left wing (detailed with feathers)
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon + 0.6*d),
                // Primary feathers
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon + 0.9*d),
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon + 1.1*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon + 1.0*d),
                // Secondary feathers
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon + 0.8*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon + 0.6*d),
                // Wing tip
                CLLocationCoordinate2D(latitude: lat + 0.05*d, longitude: lon + 0.3*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Right wing (detailed with feathers)
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon - 0.6*d),
                // Primary feathers
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon - 0.9*d),
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon - 1.1*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon - 1.0*d),
                // Secondary feathers
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon - 0.8*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon - 0.6*d),
                // Wing tip
                CLLocationCoordinate2D(latitude: lat + 0.05*d, longitude: lon - 0.3*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Back to tail
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        case "Bunny":
            // Detailed bunny with ears, head, body, and tail
            coords = [
                // Start at tail (small circle)
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon + 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon - 0.1*d),
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                // Body (oval shape)
                CLLocationCoordinate2D(latitude: lat + 0.3*d, longitude: lon + 0.15*d),
                CLLocationCoordinate2D(latitude: lat + 0.6*d, longitude: lon + 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon + 0.1*d),
                // Head
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon + 0.05*d),
                CLLocationCoordinate2D(latitude: lat + 1.1*d, longitude: lon),
                // Left ear (long and pointed)
                CLLocationCoordinate2D(latitude: lat + 1.2*d, longitude: lon + 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 1.4*d, longitude: lon + 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 1.3*d, longitude: lon + 0.3*d),
                CLLocationCoordinate2D(latitude: lat + 1.1*d, longitude: lon + 0.25*d),
                // Back to head
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon + 0.05*d),
                // Right ear (long and pointed)
                CLLocationCoordinate2D(latitude: lat + 1.2*d, longitude: lon - 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 1.4*d, longitude: lon - 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 1.3*d, longitude: lon - 0.3*d),
                CLLocationCoordinate2D(latitude: lat + 1.1*d, longitude: lon - 0.25*d),
                // Back to head
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon + 0.05*d),
                // Back down body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon - 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 0.6*d, longitude: lon - 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 0.3*d, longitude: lon - 0.15*d),
                // Back to tail
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        case "Butterfly":
            // Detailed butterfly with body, antennae, and distinct wing patterns
            coords = [
                // Start at bottom of body
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                // Body (vertical line)
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Left antenna
                CLLocationCoordinate2D(latitude: lat + 0.9*d, longitude: lon + 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon + 0.15*d),
                // Back to head
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Right antenna
                CLLocationCoordinate2D(latitude: lat + 0.9*d, longitude: lon - 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon - 0.15*d),
                // Back to head
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Upper left wing (detailed with wing patterns)
                CLLocationCoordinate2D(latitude: lat + 0.7*d, longitude: lon + 0.3*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon + 0.6*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon + 0.8*d),
                CLLocationCoordinate2D(latitude: lat + 0.05*d, longitude: lon + 0.7*d),
                // Wing tip
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon + 0.5*d),
                // Inner wing pattern
                CLLocationCoordinate2D(latitude: lat + 0.3*d, longitude: lon + 0.4*d),
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon + 0.2*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Upper right wing (detailed with wing patterns)
                CLLocationCoordinate2D(latitude: lat + 0.7*d, longitude: lon - 0.3*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon - 0.6*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon - 0.8*d),
                CLLocationCoordinate2D(latitude: lat + 0.05*d, longitude: lon - 0.7*d),
                // Wing tip
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon - 0.5*d),
                // Inner wing pattern
                CLLocationCoordinate2D(latitude: lat + 0.3*d, longitude: lon - 0.4*d),
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon - 0.2*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Lower left wing (detailed with patterns)
                CLLocationCoordinate2D(latitude: lat + 0.6*d, longitude: lon + 0.2*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon + 0.4*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon + 0.5*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon + 0.3*d),
                // Inner pattern
                CLLocationCoordinate2D(latitude: lat + 0.3*d, longitude: lon + 0.15*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Lower right wing (detailed with patterns)
                CLLocationCoordinate2D(latitude: lat + 0.6*d, longitude: lon - 0.2*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon - 0.4*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon - 0.5*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon - 0.3*d),
                // Inner pattern
                CLLocationCoordinate2D(latitude: lat + 0.3*d, longitude: lon - 0.15*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon),
                // Back to start
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        case "Shrimp":
            // Detailed shrimp with head, segmented body, tail, and legs
            coords = [
                // Start at tail (fan-shaped)
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon + 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 0.05*d, longitude: lon + 0.3*d),
                CLLocationCoordinate2D(latitude: lat + 0.05*d, longitude: lon - 0.3*d),
                CLLocationCoordinate2D(latitude: lat + 0.1*d, longitude: lon - 0.2*d),
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                // Body segments (curved)
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon + 0.15*d),
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon + 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 0.6*d, longitude: lon + 0.25*d),
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon + 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon + 0.15*d),
                // Head
                CLLocationCoordinate2D(latitude: lat + 1.2*d, longitude: lon + 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 1.3*d, longitude: lon),
                // Antennae/eyes
                CLLocationCoordinate2D(latitude: lat + 1.4*d, longitude: lon + 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 1.5*d, longitude: lon + 0.15*d),
                CLLocationCoordinate2D(latitude: lat + 1.4*d, longitude: lon - 0.1*d),
                CLLocationCoordinate2D(latitude: lat + 1.5*d, longitude: lon - 0.15*d),
                // Back to head
                CLLocationCoordinate2D(latitude: lat + 1.3*d, longitude: lon),
                CLLocationCoordinate2D(latitude: lat + 1.2*d, longitude: lon - 0.1*d),
                // Body segments (curved back)
                CLLocationCoordinate2D(latitude: lat + 1.0*d, longitude: lon - 0.15*d),
                CLLocationCoordinate2D(latitude: lat + 0.8*d, longitude: lon - 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 0.6*d, longitude: lon - 0.25*d),
                CLLocationCoordinate2D(latitude: lat + 0.4*d, longitude: lon - 0.2*d),
                CLLocationCoordinate2D(latitude: lat + 0.2*d, longitude: lon - 0.15*d),
                // Back to tail
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        default:
            coords = [start]
        }

        return coords
    }
}
