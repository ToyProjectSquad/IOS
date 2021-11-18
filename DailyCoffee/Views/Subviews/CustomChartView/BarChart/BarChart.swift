//
//  BarChart.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/31.
//

import SwiftUI

public struct BarChartView : View {
    
    @Environment(\.colorScheme)
    var colorScheme: ColorScheme
    
    @EnvironmentObject
    var chartVM: ChartViewModel
    
    @State
    var selection: Int = -1
    
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    
    public init(style: ChartStyle = Styles.barChartStyleOrangeLight) {
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.barChartStyleOrangeDark
    }
    
    public var body: some View {
        BarChartRow(selection: $selection,
                    data: chartVM.weeklyCaffeine,
                    accentColor: self.colorScheme == .dark ? self.darkModeStyle.accentColor : self.style.accentColor,
                    gradient: self.colorScheme == .dark ? self.darkModeStyle.gradientColor : self.style.gradientColor)
            .padding([.trailing, .leading, .top])
            .onAppear {
                chartVM.getWeeklyCoffee()
            }
    }
}
