//
//  CustomTabContainerView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct CustomTabContainerView<Content: View>: View {
    
    @Binding
    var selection: TabBarItem
    @State
    private var tabs: [TabBarItem] = []
    @Binding
    var favoriteViewPresented: Bool
    
    let content: Content
    
    init(selection: Binding<TabBarItem>, favoriteViewPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self._favoriteViewPresented = favoriteViewPresented
        self.content = content()
    }
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            CustomTabBarView(tabs: tabs, selectedTab: $selection, favoriteViewPresented: $favoriteViewPresented)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}
