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
    
    var label: String
    var height: Double
    var accentColor: Color
    var gradient: GradientColor?
    
    public var body: some View {
        VStack(spacing: 5) {
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(gradient: gradient?.getGradient() ?? GradientColor(start: accentColor, end: accentColor).getGradient(), startPoint: .bottom, endPoint: .top))
                .frame(width: 25, height: height, alignment: .center)
                .scaleEffect(didTapped ? CGSize(width: 1.3, height: 0.9) : CGSize(width: 1, height: 1), anchor: .bottom)
                .animation(.spring())
            Text(label)
                .foregroundColor(Color("TextColor"))
                .font(.system(size: 15, weight: .bold))
            Spacer().frame(height: 8)
        }
    }
    
}
