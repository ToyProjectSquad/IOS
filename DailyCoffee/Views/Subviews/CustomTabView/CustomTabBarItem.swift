//
//  CustomTabBarItem.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case home, history, map, settings
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .history:
            return "chart.bar"
        case .map:
            return "map"
        case .settings:
            return "ellipsis"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "house"
        case .history:
            return "history"
        case .map:
            return "map"
        case .settings:
            return "settings"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return Color(hex: "#919191")
        case .history:
            return Color(hex: "#919191")
        case .map:
            return Color(hex: "#919191")
        case .settings:
            return Color(hex: "#919191")
        }
    }
}
