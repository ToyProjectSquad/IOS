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
    var zoomInCenter: Bool = false
    @State
    var tappedCoordinate: CLLocationCoordinate2D? = nil
    @State
    var didTapped: Bool = false
    @State
    var yDragTranslation: CGFloat = 0
    
    private let detailViewHeight: CGFloat = UIScreen.main.bounds.height * 0.4

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
                    GMView(cafeVM: cafeVM, markers: $cafeVM.markers, tappedCoordinate: $tappedCoordinate, didTapped: $didTapped) {
                        self.zoomInCenter = true
                    }
                    .animation(.easeIn(duration: 0.5))
                    if didTapped {
                        AddCafeView(cafeVM: cafeVM, didTapped: $didTapped, coordinate: $tappedCoordinate)
                            .padding([.leading, .trailing], 18)
                            .padding([.top, .bottom], 100)
                            .cornerRadius(15)
                            .transition(AnyTransition.scale.animation(.easeInOut))
                    }
                }
                if let _ = cafeVM.selectedMarker {
                    VStack {
                        Spacer()
                        DetailCafeView(selectedCafe: $cafeVM.selectedCafe, content: $cafeVM.selectedCafeContent)
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                            .frame(height: geometry.size.height * 0.4 - yDragTranslation)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -5)
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.7))
                    .gesture(
                        DragGesture().onChanged { value in
                            if value.translation.height > geometry.size.height * 0.4 {
                                self.yDragTranslation = geometry.size.height * 0.4
                            }
                            else {
                                self.yDragTranslation = value.translation.height
                            }
                        }.onEnded { value in
                            if self.yDragTranslation > geometry.size.height * 0.4 * 0.5 {
                                self.cafeVM.selectedMarker = nil
                            }
                            self.yDragTranslation = 0
                        }
                    )
                }
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
    }
    
}
