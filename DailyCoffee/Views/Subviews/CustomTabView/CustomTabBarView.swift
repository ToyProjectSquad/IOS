//
//  CustomTabBarView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct CustomTabBarView: View {

    let tabs: [TabBarItem]
    
    @Namespace
    private var namespace
    @Binding
    var selectedTab: TabBarItem
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(tabs, id: \.self) { tab in
                tabView(item: tab)
                    .onTapGesture {
                        self.switchTabItem(item: tab)
                    }
            }
        }
        .frame(height: 50)
        .padding(6)
        .background(Color.clear)
        .overlay(
            coffeeIcon
        )
    }
}

extension CustomTabBarView {
    
    private var coffeeIcon: some View {
        Image("CoffeeCup")
            .padding(.bottom, 60)
    }
    
    private func tabView(item: TabBarItem) -> some View {
        VStack {
            Spacer()
            Image(systemName: item.iconName)
                .font(.subheadline)
            Text(item.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(selectedTab == item ? Color.accentColor : item.color)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                if selectedTab == item {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor.opacity(0.15))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }
    
    private func switchTabItem(item: TabBarItem) {
        withAnimation(.easeInOut) {
            selectedTab = item
        }
    }
}
