//
//  GMView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/24.
//

import GoogleMaps
import SwiftUI
import CoreLocation

struct GMView: UIViewRepresentable {
    // MARK: - VARIABLES
    // Binding
    @Binding
    var markers: [GMSMarker]
    @Binding
    var selectedMarker: GMSMarker?
    @Binding
    var tappedCoordinate: CLLocationCoordinate2D?
    @Binding
    var didTapped: Bool
    
    // Public
    var onAnimationEnded: () -> ()
    
    // Private
    private let gmsMapView = GMSMapView(frame: .zero)
    private let defaultZoomLevel: Float = 10
    
    // MARK: - MAKE UI VIEW
    func makeUIView(context: Context) -> GMSMapView {
        // Default Coordinate
        let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7576, longitude: -122.4194)
        gmsMapView.camera = GMSCameraPosition.camera(withTarget: sanFrancisco, zoom: defaultZoomLevel)
        gmsMapView.delegate = context.coordinator
        gmsMapView.isUserInteractionEnabled = true
        return gmsMapView
    }
    
    // MARK: - UPDATE UI VIEW
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        markers.forEach { marker in
            marker.map = uiView
        }
        if let selectedMarker = selectedMarker {
            let camera = GMSCameraPosition.camera(withTarget: selectedMarker.position, zoom: defaultZoomLevel)
            print("Animating to position \(selectedMarker.position)")
            CATransaction.begin()
            CATransaction.setValue(NSNumber(floatLiteral: 5), forKey: kCATransactionAnimationDuration)
            gmsMapView.animate(with: GMSCameraUpdate.setCamera(camera))
            CATransaction.commit()
        }
    }
    
    // MARK: - SET DELEGATE
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GMView
        
        init(_ mapView: GMView) {
            self.mapView = mapView
        }
        
        func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
            print("\(coordinate.longitude), \(coordinate.latitude) has tapped")
            self.mapView.tappedCoordinate = coordinate
            self.mapView.didTapped.toggle()
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.mapView.onAnimationEnded()
        }
        
    }
}

