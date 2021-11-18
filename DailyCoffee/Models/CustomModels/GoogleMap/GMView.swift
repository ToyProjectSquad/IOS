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
    
    // User Defualts
    @AppStorage("zoomLevel")
    var zoomLevel: Double?
    @AppStorage("latitude")
    var latitude: Double?
    @AppStorage("longitude")
    var longitude: Double?
    
    // Environment Object
    @EnvironmentObject
    var cafeVM: CafeViewModel
    @EnvironmentObject
    var detailCafeVM: DetailCafeViewModel
    
    // Binding
    @Binding
    var markers: [GMSMarker]
    @Binding
    var tappedCoordinate: CLLocationCoordinate2D?
    @Binding
    var didTapped: Bool
    
    // Private
    private let gmsMapView = GMSMapView(frame: .zero)
    
    // MARK: - MAKE UI VIEW
    func makeUIView(context: Context) -> GMSMapView {
        // Default Coordinate
        if zoomLevel == nil {
            zoomLevel = 10
        }
        let Seoul = CLLocationCoordinate2D(latitude: latitude ?? 37.5665, longitude: longitude ?? 126.9780)
        gmsMapView.camera = GMSCameraPosition.camera(withTarget: Seoul, zoom: Float(zoomLevel!))
        gmsMapView.delegate = context.coordinator
        gmsMapView.isUserInteractionEnabled = true
        
        return gmsMapView
    }
    
    // MARK: - UPDATE UI VIEW
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()
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
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            self.mapView.zoomLevel = Double(position.zoom)
            self.mapView.latitude = Double(position.target.latitude)
            self.mapView.longitude = Double(position.target.longitude)
        }

        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            self.mapView.cafeVM.selectedMarker = nil
        }
        
        func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
            self.mapView.tappedCoordinate = coordinate
            withAnimation {
                self.mapView.didTapped.toggle()
            }
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: Float(self.mapView.zoomLevel ?? 3))
            CATransaction.begin()
            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
            self.mapView.gmsMapView.animate(with: GMSCameraUpdate.setCamera(camera))
            CATransaction.commit()
            self.mapView.cafeVM.selectedMarker = marker
            self.mapView.cafeVM.findCafeWithMarker()
            self.mapView.detailCafeVM.configure(selectedCafe: self.mapView.cafeVM.selectedCafe)
            return true
        }
        
    }
}

