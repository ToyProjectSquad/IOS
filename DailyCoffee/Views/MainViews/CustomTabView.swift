//
//  CustomTabView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct CustomTabView: View {
    
    @State
    private var tabSelection: TabBarItem = .home
    
    var body: some View {
        CustomTabContainerView(selection: $tabSelection) {
            HomeView()
                .tabBarItem(tab: .home, selection: $tabSelection)
            HistoryView()
                .tabBarItem(tab: .history, selection: $tabSelection)
            MapView()
                .tabBarItem(tab: .map, selection: $tabSelection)
            SettingsView()
                .tabBarItem(tab: .settings, selection: $tabSelection)
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
