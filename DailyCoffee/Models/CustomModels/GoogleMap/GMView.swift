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
            self.mapView.tappedCoordinate = coordinate
            withAnimation {
                self.mapView.didTapped.toggle()
            }
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.mapView.onAnimationEnded()
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 10)
            CATransaction.begin()
            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
            CATransaction.commit()
            mapView.selectedMarker = marker
            print("marker has tapped")
            return true
        }
        
    }
}

