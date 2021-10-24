//
//  MapView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct MapView: View {
    // MARK: - VARIABLES
    
    // State Object
    @StateObject
    var cafeVM: CafeViewModel = CafeViewModel()
    
    // Environment Object
    @EnvironmentObject
    var userVM: UserViewModel

    // State
    @State
    var selection: Bool = false
    @State
    var markers: [GMSMarker] = []
    @State
    var zoomInCenter: Bool = false
    @State
    var selectedMarker: GMSMarker?
    @State
    var tappedCoordinate: CLLocationCoordinate2D? = nil
    @State
    var didTapped: Bool = false

    // MARK: - INIT
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background")
            if selection { listView }
            else { mapView }
            buttonView
        }
        .onAppear { configure() }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

// MARK: - COMPONENTS

extension MapView {
    
    private var titleView: some View {
        Text("카페 목록")
            .font(.system(size: 34, weight: .bold))
            .padding(.top, 70)
            .padding(.leading, 18)
    }
    
    private var listView: some View {
        VStack(alignment: .leading) {
            titleView
            cafeListView
                .opacity(0.8)
                .cornerRadius(15)
                .padding(18)
        }
    }
    
    private var mapView: some View {
        ZStack {
            GMView(markers: $markers, selectedMarker: $selectedMarker, tappedCoordinate: $tappedCoordinate, didTapped: $didTapped) {
                self.zoomInCenter = true
            }
                .animation(.easeIn)
                .background(Color(red: 254.0/255.0, green: 1, blue: 220.0/255.0))
            if didTapped {
                
            }
        }
    }

    private var cafeListView: some View {
        List {
            ForEach(cafeVM.cafes) { cafe in
                HStack {
                    Image(uiImage: UIImage(data: cafe.image!) ?? UIImage(named: "Placeholder")!)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(15)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                        .padding(8)
                    Text(cafe.title ?? "카페 이름")
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
    }
    
    private var buttonView: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    selection.toggle()
                }
            } label: {
                Text(selection ? "지도" : "목록")
                    .font(.system(size: 17, weight: .bold))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray.opacity(0.4)))
                    .padding(.top, 50)
                    .padding(.trailing, 25)
            }
        }
    }
    
}

// MARK: - FUNCTION

extension MapView {
    
    private func configure() {
        cafeVM.configureUser(user: userVM.user!)
        cafeVM.getCafe()
        markers = cafeVM.cafes.map {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
            marker.title = $0.title
            return marker
        }
    }
    
}
