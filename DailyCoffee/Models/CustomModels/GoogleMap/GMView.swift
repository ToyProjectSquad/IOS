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
    @ObservedObject
    var cafeVM: CafeViewModel
    
    // Binding
    @Binding
    var markers: [GMSMarker]
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
        let Seoul = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        gmsMapView.camera = GMSCameraPosition.camera(withTarget: Seoul, zoom: defaultZoomLevel)
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
            self.mapView.gmsMapView.animate(with: GMSCameraUpdate.setCamera(camera))
            CATransaction.commit()
            self.mapView.cafeVM.selectedMarker = marker
            self.mapView.cafeVM.findCafeWithMarker()
            return true
        }
        
    }
}

