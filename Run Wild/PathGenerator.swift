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
            // Side projection of bird with wings spread open and waving
            coords = [
                // Start at Tail Base
                CLLocationCoordinate2D(latitude: lat, longitude: lon), // (0, 0)
                
                // --- Left Body (thinner) & LARGE Wing (scaled up) ---
                CLLocationCoordinate2D(latitude: lat + 4*d, longitude: lon - 1*d), // Left body (4, -1) - THINNER
                CLLocationCoordinate2D(latitude: lat + 5*d, longitude: lon - 8*d), // Left wing root (5, -8) - SCALED
                CLLocationCoordinate2D(latitude: lat + 11*d, longitude: lon - 16*d), // Feather 1 (11, -16) - SCALED
                CLLocationCoordinate2D(latitude: lat + 10*d, longitude: lon - 18*d), // Feather 2 (10, -18) - SCALED
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon - 17*d), // Feather 3 (8, -17) - SCALED
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon - 7*d), // Inner wing (8, -7) - SCALED
                
                // --- Head ---
                CLLocationCoordinate2D(latitude: lat + 11*d, longitude: lon - 1.5*d), // Left head (11, -1.5)
                CLLocationCoordinate2D(latitude: lat + 12*d, longitude: lon), // Top of head (12, 0)
                CLLocationCoordinate2D(latitude: lat + 11*d, longitude: lon + 1.5*d), // Right head (11, 1.5)
                
                // --- Beak (pointing right) ---
                CLLocationCoordinate2D(latitude: lat + 11.5*d, longitude: lon + 3*d), // Beak Tip (11.5, 3)
                CLLocationCoordinate2D(latitude: lat + 10.5*d, longitude: lon + 1.5*d), // Beak Bottom (10.5, 1.5)
                
                // --- Right LARGE Wing (scaled up) & Body (thinner) ---
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon + 7*d), // Inner wing (8, 7) - SCALED
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon + 17*d), // Feather 3 (8, 17) - SCALED
                CLLocationCoordinate2D(latitude: lat + 10*d, longitude: lon + 18*d), // Feather 2 (10, 18) - SCALED
                CLLocationCoordinate2D(latitude: lat + 11*d, longitude: lon + 16*d), // Feather 1 (11, 16) - SCALED
                CLLocationCoordinate2D(latitude: lat + 5*d, longitude: lon + 8*d), // Right wing root (5, 8) - SCALED
                CLLocationCoordinate2D(latitude: lat + 4*d, longitude: lon + 1*d), // Right body (4, 1) - THINNER

                // Back to Tail Base
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        case "Bunny":
            // Fresh bunny design - side profile facing right
            coords = [
                // Start at chin
                CLLocationCoordinate2D(latitude: lat, longitude: lon), // (0, 0)
                
                // --- Nose/Mouth Area (traces a small figure-eight) ---
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon),         // (0, 1) - Up to nose
                CLLocationCoordinate2D(latitude: lat + 1.5*d, longitude: lon - 0.5*d), // (-0.5, 1.5) - Left nostril
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon),         // (0, 1) - Back to center
                CLLocationCoordinate2D(latitude: lat + 1.5*d, longitude: lon + 0.5*d), // (0.5, 1.5) - Right nostril
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon),         // (0, 1) - Back to center
                CLLocationCoordinate2D(latitude: lat, longitude: lon),         // (0, 0) - Back to chin
                
                // --- Left Side ---
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon - 2*d),  // (-2, 1) - Left jaw
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon - 4*d),  // (-4, 3) - Left cheek
                CLLocationCoordinate2D(latitude: lat + 7*d, longitude: lon - 3*d),  // (-3, 7) - Base of left ear
                
                // --- Left Ear ---
                CLLocationCoordinate2D(latitude: lat + 10*d, longitude: lon - 3.5*d), // (-3.5, 10) - Outer left ear
                CLLocationCoordinate2D(latitude: lat + 12*d, longitude: lon - 2*d),  // (-2, 12) - Tip of left ear
                CLLocationCoordinate2D(latitude: lat + 9*d, longitude: lon - 1*d),  // (-1, 9) - Inner left ear
                
                // --- Top of Head ---
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),         // (0, 8) - Between ears
                
                // --- Right Ear ---
                CLLocationCoordinate2D(latitude: lat + 9*d, longitude: lon + 1*d),  // (1, 9) - Inner right ear
                CLLocationCoordinate2D(latitude: lat + 12*d, longitude: lon + 2*d),  // (2, 12) - Tip of right ear
                CLLocationCoordinate2D(latitude: lat + 10*d, longitude: lon + 3.5*d), // (3.5, 10) - Outer right ear
                
                // --- Right Side ---
                CLLocationCoordinate2D(latitude: lat + 7*d, longitude: lon + 3*d),  // (3, 7) - Base of right ear
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon + 4*d),  // (4, 3) - Right cheek
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon + 2*d),  // (2, 1) - Right jaw
                
                // --- Back to Start ---
                CLLocationCoordinate2D(latitude: lat, longitude: lon) // (0, 0) - Back to chin
            ]
            
        case "Shrimp":
            // Simple shrimp outline facing right
            coords = [
                // Start at tail center
                CLLocationCoordinate2D(latitude: lat, longitude: lon), // (0, 0)
                
                // --- Tail Fan (left side) ---
                CLLocationCoordinate2D(latitude: lat - 1*d, longitude: lon - 2*d), // (-2, -1) - Lower tail
                CLLocationCoordinate2D(latitude: lat - 2*d, longitude: lon - 1*d), // (-1, -2) - Bottom tail tip
                CLLocationCoordinate2D(latitude: lat, longitude: lon - 2.5*d), // (-2.5, 0) - Center tail tip
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon - 1*d), // (-1, 2) - Top tail tip
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon - 2*d), // (-2, 1) - Upper tail
                CLLocationCoordinate2D(latitude: lat, longitude: lon), // (0, 0) - Back to tail center
                
                // --- Body Segments (curving upward then leveling) ---
                CLLocationCoordinate2D(latitude: lat + 1.5*d, longitude: lon + 2*d), // (2, 1.5) - Segment 1 top
                CLLocationCoordinate2D(latitude: lat + 2.5*d, longitude: lon + 4*d), // (4, 2.5) - Segment 2 top
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon + 6*d), // (6, 2) - Segment 3 top
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon + 8*d), // (8, 2) - Head base top
                
                // --- Head & Antennae ---
                CLLocationCoordinate2D(latitude: lat + 2.5*d, longitude: lon + 9*d), // (9, 2.5) - Head top
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon + 10*d), // (10, 3) - Antenna 1 base
                CLLocationCoordinate2D(latitude: lat + 4*d, longitude: lon + 12*d), // (12, 4) - Antenna 1 tip
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon + 10*d), // (10, 3) - Back to antenna base
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon + 11*d), // (11, 2) - Antenna 2 tip
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon + 10*d), // (10, 2) - Head front
                
                // --- Return along bottom ---
                CLLocationCoordinate2D(latitude: lat, longitude: lon + 8*d), // (8, 0) - Head base bottom
                CLLocationCoordinate2D(latitude: lat - 1*d, longitude: lon + 6*d), // (6, -1) - Segment 3 bottom
                CLLocationCoordinate2D(latitude: lat - 1.5*d, longitude: lon + 4*d), // (4, -1.5) - Segment 2 bottom
                CLLocationCoordinate2D(latitude: lat - 1*d, longitude: lon + 2*d), // (2, -1) - Segment 1 bottom
                
                // Back to tail center
                CLLocationCoordinate2D(latitude: lat, longitude: lon) // (0, 0)
            ]
            
        case "Butterfly":
            // Detailed butterfly with body, antennae, and distinct wing patterns
            coords = [
                // Start at bottom of body
                CLLocationCoordinate2D(latitude: lat, longitude: lon),
                // Body (vertical line)
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),
                // Left antenna
                CLLocationCoordinate2D(latitude: lat + 9*d, longitude: lon + 1*d),
                CLLocationCoordinate2D(latitude: lat + 10*d, longitude: lon + 1.5*d),
                // Back to head
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),
                // Right antenna
                CLLocationCoordinate2D(latitude: lat + 9*d, longitude: lon - 1*d),
                CLLocationCoordinate2D(latitude: lat + 10*d, longitude: lon - 1.5*d),
                // Back to head
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),
                // Upper left wing (detailed with wing patterns)
                CLLocationCoordinate2D(latitude: lat + 7*d, longitude: lon + 3*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 5*d, longitude: lon + 6*d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon + 8*d),
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon + 7*d),
                // Wing tip
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon + 5*d),
                // Inner wing pattern
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon + 4*d),
                CLLocationCoordinate2D(latitude: lat + 4*d, longitude: lon + 2*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),
                // Upper right wing (detailed with wing patterns)
                CLLocationCoordinate2D(latitude: lat + 7*d, longitude: lon - 3*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 5*d, longitude: lon - 6*d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon - 8*d),
                CLLocationCoordinate2D(latitude: lat + 0.5*d, longitude: lon - 7*d),
                // Wing tip
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon - 5*d),
                // Inner wing pattern
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon - 4*d),
                CLLocationCoordinate2D(latitude: lat + 4*d, longitude: lon - 2*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),
                // Lower left wing (detailed with patterns)
                CLLocationCoordinate2D(latitude: lat + 6*d, longitude: lon + 2*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 4*d, longitude: lon + 4*d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon + 5*d),
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon + 3*d),
                // Inner pattern
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon + 1.5*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),
                // Lower right wing (detailed with patterns)
                CLLocationCoordinate2D(latitude: lat + 6*d, longitude: lon - 2*d),
                // Wing edge
                CLLocationCoordinate2D(latitude: lat + 4*d, longitude: lon - 4*d),
                CLLocationCoordinate2D(latitude: lat + 2*d, longitude: lon - 5*d),
                CLLocationCoordinate2D(latitude: lat + 1*d, longitude: lon - 3*d),
                // Inner pattern
                CLLocationCoordinate2D(latitude: lat + 3*d, longitude: lon - 1.5*d),
                // Back to body
                CLLocationCoordinate2D(latitude: lat + 8*d, longitude: lon),
                // Back to start
                CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ]
            
        default:
            coords = [start]
        }

        return coords
    }
}
