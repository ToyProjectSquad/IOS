//
//  CustomTabView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct CustomTabView: View {
    
    @StateObject
    var coffeeVM: CoffeeViewModel = CoffeeViewModel()
    @StateObject
    var cafeVM: CafeViewModel = CafeViewModel()
    @StateObject
    var chartVM: ChartViewModel = ChartViewModel()
    
    @State
    private var tabSelection: TabBarItem = .home
    @State
    private var favoriteViewPresented: Bool = false
    
    var body: some View {
        CustomTabContainerView(selection: $tabSelection, favoriteViewPresented: $favoriteViewPresented) {
            HomeView()
                .tabBarItem(tab: .home, selection: $tabSelection)
            HistoryView()
                .tabBarItem(tab: .history, selection: $tabSelection)
            MapView()
                .tabBarItem(tab: .map, selection: $tabSelection)
            SettingsView()
                .tabBarItem(tab: .settings, selection: $tabSelection)
        }
        .environmentObject(coffeeVM)
        .environmentObject(cafeVM)
        .environmentObject(chartVM)
        .sheet(isPresented: $favoriteViewPresented) {
            FavoriteView()
                .environmentObject(coffeeVM)
                .environmentObject(chartVM)
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
