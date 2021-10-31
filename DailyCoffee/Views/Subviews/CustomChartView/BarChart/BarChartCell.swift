//
//  BarChartCell.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/31.
//

import SwiftUI

public struct BarChartCell : View {
    
    @Binding
    var didTapped: Bool
    
    var accentColor: Color
    var gradient: GradientColor?
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(LinearGradient(gradient: gradient?.getGradient() ?? GradientColor(start: accentColor, end: accentColor).getGradient(), startPoint: .bottom, endPoint: .top))
        
    }
}
