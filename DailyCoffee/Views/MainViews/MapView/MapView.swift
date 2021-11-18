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
    
    // Environment Object
    @EnvironmentObject
    var cafeVM: CafeViewModel
    
    @EnvironmentObject
    var userVM: UserViewModel
    
    // State Object
    @StateObject
    var detailCafeVM: DetailCafeViewModel = DetailCafeViewModel()

    // State
    @State
    var selection: Bool = false
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
        .edgesIgnoringSafeArea(.top)
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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    GMView(markers: $cafeVM.markers, tappedCoordinate: $tappedCoordinate, didTapped: $didTapped)
                    if didTapped {
                        AddCafeView(didTapped: $didTapped, coordinate: $tappedCoordinate)
                            .padding([.leading, .trailing], 18)
                            .padding([.top, .bottom], 100)
                            .cornerRadius(15)
                            .transition(AnyTransition.scale.animation(.easeInOut))
                    }
                }
                if let _ = cafeVM.selectedMarker {
                    DetailCafeView()
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .frame(height: geometry.size.height * 0.5)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -5)
                }
            }
        }
        .environmentObject(detailCafeVM)
        
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
    }
    
}
